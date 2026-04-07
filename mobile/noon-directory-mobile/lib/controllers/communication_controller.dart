import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/enum.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/models/chat_room_data.dart';
import 'package:noon/models/chat_room_last_message.dart';
import 'package:noon/models/message_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import '../core/constant/api_urls.dart';
import '../core/failures.dart';
import '../data/api_services.dart';
import 'global_controller.dart';
import 'login_controller.dart';

class CommunicationController extends GetxController
    with StateMixin<List<ChatRoomData>>, GetSingleTickerProviderStateMixin {
  final _apiService = ApiService();
  final controller = Get.find<GlobalController>();
  final loginController = Get.find<LoginController>();
  final profileController = Get.find<ProfileController>();
  final directMessages = <ChatRoomData>[].obs;
  final groups = <ChatRoomData>[].obs;
  final pageController = PageController();
  final selectedPageIndex = 0.obs;
  late TabController tabController;

  int get unreadDirectMessagesCount =>
      directMessages.fold(0, (sum, chat) => sum + chat.unreadCount);

  int get unreadGroupsCount =>
      groups.fold(0, (sum, chat) => sum + chat.unreadCount);

  @override
  onInit() {
    tabController = TabController(length: 2, vsync: this);
    fetchChats();
    super.onInit();
  }

  @override
  void onClose() {
    directMessages.close();
    groups.close();
    pageController.dispose();
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchChats() async {
    try {
      final String url;

      if (controller.isTeacher) {
        url = ApiUrls.teacherChats;
      } else if (controller.isParent) {
        url = ApiUrls.parentChats;
      } else {
        url = ApiUrls.studentChats;
      }

      change(null, status: RxStatus.loading());
      final res = await _apiService.get(
        url: url,
        queryParameters: {'sortBy': 'updatedAt', 'sortDirection': 'desc'},
      );

      if (res.data != null) {
        final items = List<ChatRoomData>.from(
          res.data['data'].map((e) => ChatRoomData.fromJson(e)),
        );
        items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        if (items.isNotEmpty) {
          directMessages.assignAll(
            items.where((chat) => chat.isDirectMsg && chat.lastMessage != null),
          );
          groups.assignAll(items.where((chat) => chat.isGroup));

          profileController.unreadMessagesCount.value =
              unreadDirectMessagesCount + unreadGroupsCount;
        } else {
          profileController.unreadMessagesCount.value = 0;
        }
        change(null, status: RxStatus.success());
        update();
      } else {
        dprint('❌ API response data is null');
      }
    } catch (e) {
      dprint(e);
      String error = e.toString();
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      change(null, status: RxStatus.error(error));
    }
  }

  Future<List<Map<String, dynamic>>> getTodayMessages() async {
    try {
      final String url;
      if (controller.isParent) {
        url = ApiUrls.parentTodayMessages;
      } else {
        url = ApiUrls.studentTodayMessages;
      }

      final res = await _apiService.get(url: url);

      if (res.data != null && res.data['data'] != null) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      dprint('Error fetching today messages: $e');
      return [];
    }
  }

  Future<bool> createDirectMsgChat({required String teacherId}) async {
    try {
      EasyLoading.show();

      final accountTypeName = Hive.box(
        AppStrings.boxKey,
      ).get(AppStrings.accountTypeKey);
      final isStudent = accountTypeName == AccountType.student.name;

      var response = await _apiService.post(
        url: isStudent
            ? ApiUrls.studentDirectMsgWithTeacher
            : ApiUrls.parentDirectMsgWithTeacher,
        body: {'teacherId': teacherId, 'initialMessage': ''},
      );

      if (response.data != null) {
        final data = response.data['data'];
        if (data != null && data['roomId'] != null) {
          Get.back();
          await Get.toNamed(
            ScreensUrls.conversationScreenUrl,
            arguments: {
              'roomId': data['roomId'],
              'roomName': data['roomName'] ?? data['teacher']?['name'] ?? '',
              'schoolId': profileController.user.value!.schoolId,
            },
          );

          await fetchChats();
          return true;
        } else {
          await fetchChats();
          return true;
        }
      }
      return false;
    } catch (e) {
      String error = e.toString();
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> createDirectMsgChatWithStudent({
    required String studentId,
  }) async {
    try {
      EasyLoading.show();

      var response = await _apiService.post(
        url: ApiUrls.teacherDirectMsgWithStudent,
        body: {'studentId': studentId, 'initialMessage': ''},
      );

      if (response.data != null) {
        final data = response.data['data'];
        if (data != null && data['roomId'] != null) {
          Get.back();
          await Get.toNamed(
            ScreensUrls.conversationScreenUrl,
            arguments: {
              'roomId': data['roomId'],
              'roomName': data['roomName'] ?? data['student']?['name'] ?? '',
              'schoolId': profileController.user.value!.schoolId,
            },
          );

          await fetchChats();
          return true;
        } else {
          await fetchChats();
          return true;
        }
      }
      return false;
    } catch (e) {
      String error = e.toString();
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> createDirectMsgChatWithAdmin() async {
    try {
      EasyLoading.show();

      var response = await _apiService.post(
        url: ApiUrls.teacherDirectMsgWithAdmin,
        body: {'initialMessage': ''},
      );

      if (response.data != null) {
        final data = response.data['data'];
        if (data != null && data['roomId'] != null) {
          await Get.toNamed(
            ScreensUrls.conversationScreenUrl,
            arguments: {
              'roomId': data['roomId'],
              'roomName': data['roomName'] ?? 'Administration',
              'schoolId': profileController.user.value!.schoolId,
            },
          );

          await fetchChats();
          return true;
        } else {
          await fetchChats();
          return true;
        }
      }
      return false;
    } catch (e) {
      String error = e.toString();
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  void changePage(int index) {
    selectedPageIndex.value = index;
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
    if (tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  void onPageChanged(int index) {
    selectedPageIndex.value = index;
    if (tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  void bumpChatToTopFromMessage({
    required String roomId,
    required MessageModel message,
  }) {
    try {
      final int dmIndex = directMessages.indexWhere((c) => c.id == roomId);
      if (dmIndex != -1) {
        final ChatRoomData original = directMessages[dmIndex];
        final ChatRoomData updated = original.rebuild((b) {
          b.updatedAt = message.createdAt;
          b.lastMessage = ChatRoomLastMessage(
            (lm) => lm
              ..id = message.id
              ..content = message.text
              ..messageType = 'text'
              ..fileName = null
              ..filePath = null
              ..fileUrl = null
              ..fileSize = null
              ..fileMimeType = null
              ..fileDuration = null
              ..senderId = message.senderId
              ..senderType = message.senderType
              ..senderName = message.senderName
              ..roomId = roomId
              ..schoolId = original.schoolId
              ..isDeletedString = 'FALSE'
              ..isEditedString = 'FALSE'
              ..isReadString = 'TRUE'
              ..readAt = null
              ..editedAt = null
              ..createdAt = message.createdAt
              ..updatedAt = message.createdAt,
          ).toBuilder();
        });

        directMessages.removeAt(dmIndex);
        directMessages.insert(0, updated);
        update();
        return;
      }

      final int grpIndex = groups.indexWhere((c) => c.id == roomId);
      if (grpIndex != -1) {
        final ChatRoomData original = groups[grpIndex];
        final ChatRoomData updated = original.rebuild((b) {
          b.updatedAt = message.createdAt;
          b.lastMessage = ChatRoomLastMessage(
            (lm) => lm
              ..id = message.id
              ..content = message.text
              ..messageType = 'text'
              ..fileName = null
              ..filePath = null
              ..fileUrl = null
              ..fileSize = null
              ..fileMimeType = null
              ..fileDuration = null
              ..senderId = message.senderId
              ..senderType = message.senderType
              ..senderName = message.senderName
              ..roomId = roomId
              ..schoolId = original.schoolId
              ..isDeletedString = 'FALSE'
              ..isEditedString = 'FALSE'
              ..isReadString = 'TRUE'
              ..readAt = null
              ..editedAt = null
              ..createdAt = message.createdAt
              ..updatedAt = message.createdAt,
          ).toBuilder();
        });

        groups.removeAt(grpIndex);
        groups.insert(0, updated);
        update();
      }
    } catch (e) {
      dprint('Error bumping chat to top: $e');
    }
  }
}
