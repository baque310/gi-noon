import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/file_helper.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/message_model.dart';
import 'package:noon/data/socket.dart';
import '../core/constant/api_urls.dart';
import '../core/constant/app_strings.dart';
import 'global_controller.dart';

class ConversationController extends GetxController
    with StateMixin<List<MessageModel>> {
  final _apiService = ApiService();
  final _gController = Get.find<GlobalController>();
  final List<MessageModel> _messages = [];

  final _box = Get.find<GlobalController>().box;
  final _socketService = SocketService();
  late final AppLifecycleListener _appLifecycleListener;

  String? _roomId;
  String? _schoolId;

  final scrollController = ScrollController();

  final isConnected = false.obs;
  final isConnecting = false.obs;
  final socketErrorMessage = ''.obs;
  final hasSocketError = false.obs;

  final hasJoinedRoom = false.obs;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 3;

  final pickedFiles = <File>[].obs;

  final Box<String> _downloadedFilesBox = Hive.box<String>('downloaded_files');
  final Box<String> _downloadedFilesPathsBox = Hive.box<String>(
    'downloaded_files_paths',
  );
  final downloadedFiles = <String>[].obs;
  final downloadedFilesPaths = <String>[].obs;
  final downloadingFiles = <String, bool>{}.obs;

  Future<void> pickFiles() async {
    Get.back();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      pickedFiles.addAll(
        result.files
            .map((e) => File(e.path ?? ''))
            .where((file) => !pickedFiles.contains(file))
            .toList(),
      );
    }
  }

  Future<void> pickImages() async {
    Get.back();
    final images = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      pickedFiles.addAll(
        images
            .map((e) => File(e.path))
            .where((file) => !pickedFiles.contains(file))
            .toList(),
      );
    }
  }

  void removeFile(File file) {
    pickedFiles.remove(file);
  }

  @override
  void onClose() {
    _socketService.dispose();
    scrollController.dispose();
    _appLifecycleListener.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _roomId = Get.arguments['roomId'];
    _schoolId = Get.arguments['schoolId'];

    dprint('Room ID: $_roomId');

    downloadedFiles.addAll(_downloadedFilesBox.values);
    downloadedFilesPaths.addAll(_downloadedFilesPathsBox.values);

    initConversationSocket();
    _setupMessageHandlers();

    _appLifecycleListener = AppLifecycleListener(
      onPause: () {
        dprint('App paused - Socket will be managed by system');
      },
      onResume: () {
        dprint('App resumed - Checking socket connection');
        _handleAppResume();
      },
      onDetach: () {
        dprint('App detached - Disconnecting socket');
        _socketService.disconnect();
      },
    );
  }

  Future<void> fetchConversationMessages() async {
    try {
      final String url;

      if (_gController.isTeacher) {
        url = '${ApiUrls.teacherChats}/$_roomId';
      } else if (_gController.isParent) {
        url = '${ApiUrls.parentConversationMessages}/$_roomId';
      } else {
        url = '${ApiUrls.studentChats}/$_roomId';
      }

      dprint('📡 Fetching conversation messages from: $url');
      change(null, status: RxStatus.loading());

      final res = await _apiService.get(
        url: url,
        queryParameters: {'count': 100},
      );

      if (res.data != null) {
        final items = List<MessageModel>.from(
          res.data['data'].map((e) => MessageModel.fromJson(e)),
        );

        _messages.clear();
        if (items.isNotEmpty) {
          _messages.addAll(items);
          dprint('📚 Loaded ${items.length} messages via API');
        }
        change(_messages, status: RxStatus.success());
        _scrollDown();
      } else {
        change(_messages, status: RxStatus.success());
      }
    } catch (e) {
      String error = e.toString();
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint('❌ Error fetching messages: $error');

      if (hasJoinedRoom.value) {
        dprint(
          '✅ Socket connection working, showing empty state instead of error',
        );
        change(_messages, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error(error));
      }
    }
  }

  void initConversationSocket() {
    final userId = _box.get(AppStrings.userIdKey);
    final tokenKey = _box.get(AppStrings.tokenKey);
    final accountType = _box.get(AppStrings.accountTypeKey);

    if (userId == null ||
        tokenKey == null ||
        accountType == null ||
        _schoolId == null) {
      dprint('❌ Socket Error: Missing required authentication data');
      Get.back();
      return;
    }

    dprint('🚀 Initializing socket connection...');
    dprint('User ID: $userId');
    dprint('Account Type: $accountType');
    dprint('School ID: $_schoolId');

    isConnecting.value = true;

    if (!_socketService.isInitialized) {
      _socketService.init('${ApiUrls.baseUrl}/chat');
    }

    _setupSocketEventHandlers(userId, accountType, _schoolId!);
    final connected = _socketService.connect();

    if (!connected) {
      isConnected.value = false;
      isConnecting.value = false;
      _handleConnectionError();
    }
  }

  void _setupSocketEventHandlers(
    String userId,
    String accountType,
    String schoolId,
  ) {
    _socketService.onConnect((_) {
      dprint('✅ Socket connected successfully');
      isConnected.value = true;
      isConnecting.value = false;
      _reconnectAttempts = 0;

      hasSocketError.value = false;
      socketErrorMessage.value = '';

      _socketService.emit(
        'register',
        args: {'userId': userId, 'userType': accountType, 'schoolId': schoolId},
      );
    });

    _socketService.onDisconnect((error) {
      dprint(tag: 'Socket', '❌ Socket disconnected, $error');
      isConnected.value = false;
      isConnecting.value = false;
      hasJoinedRoom.value = false;

      dprint(
        tag: 'Socket',
        'Waiting for automatic reconnection or app lifecycle event',
      );
    });

    _socketService.onConnectError((error) {
      dprint(tag: 'Socket', '❌ Socket connection error, $error');
      isConnected.value = false;
      isConnecting.value = false;
      hasJoinedRoom.value = false;
      _handleConnectionError();

      dprint(
        tag: 'Socket',
        'Connection error handled, waiting for automatic retry',
      );
    });

    _socketService.onReconnecting((error) {
      dprint(tag: 'Socket', '🚀 Reconnecting, $error');
      isConnected.value = false;
      isConnecting.value = true;
    });

    _socketService.onReconnected((connectionId) {
      dprint(tag: 'Socket', '✅ Reconnected with connectionId: $connectionId');
      isConnected.value = true;
      isConnecting.value = false;

      _rejoinRoom();
    });

    _socketService.on('registered', (data) {
      dprint('✅ Successfully registered, $data');
      if (isConnected.value) {
        try {
          joinRoom();
        } catch (e) {
          dprint('❌ Error joining room after registration, $e');
          _handleSocketError(e);
        }
      }
    });

    _socketService.on('error', (data) {
      dprint('❌ Socket Error, $data');
      _handleSocketError(data);
    });

    _socketService.on('connect_error', (data) {
      dprint('❌ Connection Error: $data');
      _handleConnectionError();
    });

    _socketService.on('reconnect_attempt', (attemptNumber) {
      dprint('🔄 Reconnection attempt #$attemptNumber');
      isConnecting.value = true;
    });

    _socketService.on('reconnect_failed', (_) {
      dprint('❌ Reconnection failed after $maxReconnectAttempts attempts');
      Get.back();
    });
  }

  void _handleSocketError(dynamic data) {
    String errorMessage = 'An unexpected error occurred';

    if (data is Map<String, dynamic>) {
      errorMessage = data['message'] ?? data.toString();
    } else if (data is String) {
      errorMessage = data;
    }

    dprint('Handling socket error: $errorMessage');

    if (errorMessage.contains('صلاحية للوصول')) {
      dprint('🔐 Permission error detected, allowing UI to function...');
      hasJoinedRoom.value = true;
      hasSocketError.value = false;
      change(_messages, status: RxStatus.success());
      return;
    }

    isConnected.value = false;
    hasJoinedRoom.value = false;
    hasSocketError.value = true;
    socketErrorMessage.value = errorMessage;

    change(null, status: RxStatus.error(errorMessage));
  }

  void _handleConnectionError() {
    _reconnectAttempts++;
    hasJoinedRoom.value = false;

    if (_reconnectAttempts >= maxReconnectAttempts) {
      Get.back();
    }
  }

  void joinRoom() {
    if (isConnected.value) {
      try {
        dprint('🚪 Joining room: $_roomId with schoolId: $_schoolId');
        _socketService.emit(
          'join_room',
          args: {'roomId': _roomId, 'schoolId': _schoolId},
        );

        Future.delayed(const Duration(seconds: 5), () {
          if (_messages.isEmpty && status.isSuccess) {
            dprint('⏰ Socket timeout - fallback to API for messages');
            fetchConversationMessages();
          }
        });
      } catch (e) {
        dprint('❌ Error joining room, $e');
        _handleSocketError(e);
        fetchConversationMessages();
      }
    } else {
      dprint('⚠️ Cannot join room: Socket not connected yet');
      fetchConversationMessages();
    }
  }

  void _setupMessageHandlers() {
    _socketService.on('messageSent', (data) {
      try {
        EasyLoading.dismiss();
        dprint('✅ Message Sent: $data');
        final message = MessageModel.fromJson(data);
        _messages.add(message);
        change(_messages, status: RxStatus.success());
        _scrollDown();

        final comm = Get.find<CommunicationController>();
        final roomId = _roomId;
        if (roomId != null && roomId.isNotEmpty) {
          comm.bumpChatToTopFromMessage(roomId: roomId, message: message);
        }

        Get.find<CommunicationController>().fetchChats();
      } catch (e) {
        dprint('❌ Error processing messageSent: $e');
      }
    });

    _socketService.on('newMessage', (data) {
      try {
        dprint('📨 New Message: $data');
        final message = MessageModel.fromJson(data);
        _messages.add(message);
        change(_messages, status: .success());
        _scrollDown();
        pickedFiles.clear();

        final comm = Get.find<CommunicationController>();
        final roomId = _roomId;
        if (roomId != null && roomId.isNotEmpty) {
          comm.bumpChatToTopFromMessage(roomId: roomId, message: message);
        }
      } catch (e) {
        dprint('❌ Error processing newMessage: $e');
      }
    });

    _socketService.on('message_deleted', (data) {
      try {
        dprint('🗑️ Message Deleted: $data');
        _messages.removeWhere((msg) => msg.id == data['messageId']);
        change(_messages, status: RxStatus.success());
      } catch (e) {
        dprint('❌ Error processing message_deleted: $e');
      }
    });

    _socketService.on('sendMessage_error', (data) {
      dprint('❌ Send Message Error: $data');
      EasyLoading.dismiss();
    });

    _socketService.on('joined_room', (data) {
      try {
        dprint('🏠 Joined Room: $data');
        EasyLoading.dismiss();
        final response = data as Map<String, dynamic>;
        _messages.clear();

        hasJoinedRoom.value = true;

        if (response.containsKey('previousMessages') &&
            response['previousMessages'] != null &&
            response['previousMessages'].isNotEmpty) {
          final previousMessages = List<MessageModel>.from(
            response['previousMessages'].map((e) => MessageModel.fromJson(e)),
          );
          dprint(
            '📚 Loading ${previousMessages.length} previous messages via socket',
          );
          _messages.addAll(previousMessages);
          change(_messages, status: RxStatus.success());
          _scrollDown();
        } else {
          final joinMessage = response['message'] ?? 'تم الانضمام للغرفة بنجاح';
          dprint('📝 Creating system message: $joinMessage');

          final systemMessage = MessageModel(
            (b) => b
              ..id = 'system_${DateTime.now().millisecondsSinceEpoch}'
              ..text = joinMessage
              ..senderId = 'system'
              ..senderName = 'النظام'
              ..senderType = 'system'
              ..createdAt = DateTime.now(),
          );

          _messages.add(systemMessage);
          change(_messages, status: RxStatus.success());
          _scrollDown();

          dprint('⚠️ No previous messages from socket, trying API fallback');
          fetchConversationMessages();
        }
      } catch (e) {
        dprint('❌ Error processing joined_room: $e');
        fetchConversationMessages();
      }
    });

    _socketService.on('roomStatus', (data) {
      dprint('🏠 Room Status: $data');
    });
  }

  Future<void> sendMessage(String message) async {
    dprint('sendMessage($message)');
    if (message.trim().isEmpty && pickedFiles.isEmpty) {
      dprint('❌ Cannot send empty message');
      return;
    }

    if (!isConnected.value) {
      dprint('❌ Cannot send message: Socket not connected');
      return;
    }

    if (_roomId == null || _roomId!.isEmpty) {
      dprint('Cannot send message: Room ID is missing');
      return;
    }

    dprint('📤 Sending message: ${message.trim()}');
    dprint('Room ID: $_roomId');

    try {
      EasyLoading.show();
      if (pickedFiles.isNotEmpty) {
        dprint('sending files');
        for (final file in pickedFiles) {
          final name = file.path.split('/').last;
          final ext = name.split('.').last.toLowerCase();
          final isImage = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp',
            'bmp',
          ].contains(ext);

          final attached = await _uploadChatFile(
            file,
            caption: message.trim().isNotEmpty ? message.trim() : null,
          );
          dprint(attached);
          if (attached == null) continue;

          if (!isImage) {
            final attachedName = attached['fileName']?.toString();
            addDownloadedFile(attachedName ?? name, file.path);
          }

          _socketService.emit(
            'sendMessage',
            args: {
              'roomId': _roomId,
              'message': message.trim().isNotEmpty
                  ? message.trim()
                  : (isImage ? 'تم إرسال صورة' : 'تم إرسال ملف'),
              'messageType': isImage ? 'image' : 'file',
              'attachedFile': attached,
            },
          );
        }
        pickedFiles.clear();
      } else {
        _socketService.emit(
          'sendMessage',
          args: {
            'roomId': _roomId,
            'message': message.trim(),
            'messageType': 'text',
          },
        );
      }
    } catch (e) {
      dprint('❌ Error sending message: $e');
      EasyLoading.dismiss();
    }
  }

  Future<void> sendAudioMessage(String path, double duration) async {
    if (!isConnected.value) {
      dprint('❌ Cannot send message: Socket not connected');
      return;
    }

    try {
      EasyLoading.show();
      final file = File(path);
      final attached = await _uploadChatFile(file, duration: duration);

      if (attached != null) {
        _socketService.emit(
          'sendMessage',
          args: {
            'roomId': _roomId,
            'message': 'Audio Message',
            'messageType': 'audio',
            'attachedFile': attached,
          },
        );
      }
      EasyLoading.dismiss();
    } catch (e) {
      dprint('❌ Error sending audio: $e');
      EasyLoading.dismiss();
    }
  }

  Future<Map<String, dynamic>?> _uploadChatFile(
    File file, {
    String? caption,
    double? duration,
  }) async {
    try {
      final name = file.path.split('/').last;
      final ext = name.split('.').last.toLowerCase();

      final body = dio.FormData.fromMap({
        'roomId': _roomId,
        if (caption != null && caption.isNotEmpty) 'message': caption,
        if (duration != null) 'duration': duration,
        'file': await dio.MultipartFile.fromFile(
          file.path,
          filename: name,
          contentType: ext == 'm4a' ? MediaType('audio', 'm4a') : null,
        ),
      });
      final res = await _apiService.post(
        url: ApiUrls.chatFilesUpload,
        body: body,
      );
      final data = res.data;
      if (data is Map<String, dynamic>) {
        return (data['fileInfo'] as Map<String, dynamic>?) ?? data;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  bool isDownloaded(String fileName, String filePath) =>
      downloadedFiles.any((f) => f.contains(fileName)) ||
      downloadedFilesPaths.any((p) => p.contains(filePath));

  String? localPathFor(String fileName) {
    for (final p in downloadedFilesPaths) {
      if (p.contains(fileName)) return p;
    }
    return null;
  }

  Future<void> downloadAttachment({
    required String url,
    required String fileName,
  }) async {
    try {
      downloadingFiles[fileName] = true;
      downloadingFiles.refresh();

      await FileHelper.downloadFile(
        url: url,
        name: fileName,
        onComplete: (savedName, path) {
          addDownloadedFile(savedName, path);

          downloadingFiles.remove(fileName);
          downloadingFiles.refresh();
        },
      );
    } catch (_) {
      downloadingFiles.remove(fileName);
      downloadingFiles.refresh();
    }
  }

  void addDownloadedFile(String fileName, String path) {
    if (!downloadedFiles.contains(fileName)) {
      downloadedFiles.add(fileName);
      downloadedFilesPaths.add(path);
      _downloadedFilesBox.put(fileName, fileName);
      _downloadedFilesPathsBox.put(fileName, path);
      downloadedFiles.refresh();
    }
  }

  Future<void> deleteMessage(String id) async {
    try {
      _socketService.emit(
        'delete_message',
        args: {'roomId': _roomId, 'messageId': id},
      );
    } catch (e) {
      dprint('❌ Error deleting message: $e');
    }
  }

  Future<void> _scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> _handleAppResume() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      bool actuallyConnected = _socketService.isConnected;

      dprint(
        'Socket connection status - isConnected: ${isConnected.value}, actuallyConnected: $actuallyConnected',
      );

      if (!actuallyConnected || !isConnected.value) {
        dprint('Attempting to reconnect socket after app resume');

        isConnected.value = false;
        isConnecting.value = false;
        hasJoinedRoom.value = false;

        _socketService.disconnect();

        await Future.delayed(const Duration(milliseconds: 1000));

        initConversationSocket();
      } else {
        dprint('Socket is already connected, no reconnection needed');
      }
    } catch (e) {
      dprint('Error during app resume handling: $e');
      initConversationSocket();
    }
  }

  void _rejoinRoom() {
    if (_roomId != null && _schoolId != null) {
      try {
        dprint('Rejoining room after reconnection: $_roomId');
        _socketService.emit(
          'join_room',
          args: {'roomId': _roomId, 'schoolId': _schoolId},
        );
      } catch (e) {
        dprint('Error rejoining room: $e');
      }
    } else {
      dprint('Cannot rejoin room: roomId or schoolId is null');
    }
  }
}
