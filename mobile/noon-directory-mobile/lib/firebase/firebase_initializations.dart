import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/function.dart';
import 'package:noon/core/print_value.dart';
import 'package:s_extensions/s_extensions.dart';
import '../core/constant/app_strings.dart';
import '../firebase_options.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const androidInitializationSettings = AndroidInitializationSettings(
  '@mipmap/ic_launcher',
);

const darwinInitializationSettings = DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
);

const notificationsInitializationSettings = InitializationSettings(
  android: androidInitializationSettings,
  iOS: darwinInitializationSettings,
);

Future<void> initializeFirebase() async {
  final box = Hive.box(AppStrings.boxKey);
  const String firebaseTokenKey = AppStrings.firebaseTokenKey;
  await Firebase.initializeApp(
    name: 'Noon-${Platform.localeName}',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settings = await FirebaseMessaging.instance.requestPermission();

  dprint('iOS notification permission status: ${settings.authorizationStatus}');
  dprint(
    'Alert: ${settings.alert}, Badge: ${settings.badge}, Sound: ${settings.sound}',
  );

  if (Platform.isIOS) {
    String? apnsToken;
    try {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken().timeout(
        10.sec,
      );
      dprint('APNs Token retrieved: $apnsToken');
    } catch (e) {
      dprint('Error getting APNs token: $e');
      await Future.delayed(1.sec);
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      dprint('APNs Token (retry): $apnsToken');
    }

    if (apnsToken != null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      dprint('Firebase Messaging Token (FCM): $fcmToken');
      if (fcmToken != null) {
        await box.put(firebaseTokenKey, fcmToken);
        dprint('FCM token saved to Hive');
      } else {
        dprint('FCM token is null - notifications may not work');
      }
    } else {
      dprint('APNs token is null after retry - notifications will not work');
      dprint('Please ensure:');
      dprint('1. Push Notifications capability is enabled in Xcode');
      dprint('2. APNs certificate is configured in Firebase Console');
      dprint('3. App is running on a real device (not simulator)');
    }
  } else {
    FirebaseMessaging.instance.getToken().then((token) async {
      dprint('Firebase Messaging Token: $token');
      if (token != null) {
        await box.put(firebaseTokenKey, token);
      }
    });
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    dprint('Firebase Messaging Token refresh: $token');
    await box.put(firebaseTokenKey, token);
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // ? Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    dprint('Got a message whilst in the foreground!');
    dprint('Message data: ${message.data}');

    if (message.notification != null) {
      Get.snackbar(
        message.notification?.title ?? 'أشعار',
        message.notification?.body ?? 'لديك رسالة جديدة',
        duration: 3.sec,
        onTap: (snack) => openApp(message),
        backgroundColor: AppColors.primary,
        colorText: AppColors.neutralWhite,
        borderRadius: getDynamicWidth(20),
      );
    } else {
      dprint(
        'Data-only message received in foreground, no UI notification needed',
      );
    }
  });

  await initializeLocalNotifications();

  await createFirebaseNotificationsChannel();

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    dprint('Firebase Message opened app: ${event.notification.toString()}');
    dprint('Firebase Message data: ${event.data.toString()}');
    openApp(event);
  });

  // ? Handle notification when app is launched from terminated state
  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();
  if (initialMessage != null) {
    dprint(
      'App launched from terminated state via notification: ${initialMessage.notification.toString()}',
    );
    dprint('Initial message data: ${initialMessage.data.toString()}');
    dprint('Initial message ID: ${initialMessage.messageId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(1500.msec, () {
        dprint('Processing initial message navigation...');
        openApp(initialMessage);
      });
    });
  }

  await FirebaseAnalytics.instance.logAppOpen();
}

void openApp(RemoteMessage event) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      String? type = event.data['type'];
      final isAlert = event.data['isAlert'] == "TRUE";

      goToTargetPage(type ?? '', isAlert: isAlert);
    } catch (e) {
      goToTargetPage('');
    }
  });
}

Future<void> initializeLocalNotificationsCore({
  bool requestPermissions = true,
}) async {
  if (requestPermissions) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  await flutterLocalNotificationsPlugin.initialize(
    notificationsInitializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
}

Future<void> initializeLocalNotifications() async {
  await initializeLocalNotificationsCore();
}

Future<void> createFirebaseNotificationsChannel() async {
  final AndroidNotificationChannel androidNotificationChannel =
      const AndroidNotificationChannel(
        'Noon Channel',
        'Noon Channel',
        description: 'Noon Channel',
        playSound: true,
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
      );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(androidNotificationChannel);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    name: 'Noon-${Platform.localeName}',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  dprint("Handling a background message: ${message.messageId}");
  dprint("Background message data: ${message.data}");
  dprint("Message notification: ${message.notification}");

  final shouldShowLocalNotification = message.notification == null;

  if (shouldShowLocalNotification) {
    await initializeLocalNotificationsCore(requestPermissions: false);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'Noon Channel',
        'Noon Channel',
        channelDescription: 'Noon Channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final payload = jsonEncode(message.data);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'] ?? 'Notification',
      message.data['body'] ?? 'You have a new message',
      notificationDetails,
      payload: payload,
    );

    dprint("Local notification shown for data-only message");
  } else {
    dprint("Skipping local notification - Firebase will handle automatically");
  }
}

void onDidReceiveNotificationResponse(NotificationResponse details) {
  dprint('onDidReceiveNotificationResponse: ${details.payload}');
  try {
    if (details.payload != null && details.payload!.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(details.payload!);
      data.forEach((key, value) => dprint('Notification data - $key: $value'));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        String? type = data['type'];
        final isAlert = data['isAlert'] == "TRUE";
        dprint('Local notification clicked with type: $type');
        goToTargetPage(type ?? '', isAlert: isAlert);
      });
    } else {
      dprint('No payload in notification response, navigating to home');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        goToTargetPage('');
      });
    }
  } catch (e) {
    dprint('Error parsing notification payload: $e');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goToTargetPage('');
    });
  }
}
