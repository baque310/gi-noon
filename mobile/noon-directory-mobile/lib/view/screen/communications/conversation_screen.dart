import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/conversation_controller.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/extensions/int_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/message_model.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/send_message_box.dart';
import 'package:s_extensions/extensions/list_ext.dart';
import 'package:s_extensions/extensions/number_ext.dart';
import 'package:s_extensions/extensions/widget_ext.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with WidgetsBindingObserver {
  final controller = Get.find<ConversationController>();
  final gController = Get.find<GlobalController>();
  double _keyboardHeight = 0.0;
  late final String roomName;

  @override
  void initState() {
    super.initState();
    roomName = Get.arguments?['roomName'];
    WidgetsBinding.instance.addObserver(this);
    _keyboardHeight = DeviceUtils.keyboardHeight;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final newKeyboardHeight = DeviceUtils.keyboardHeight;

    if (_keyboardHeight != newKeyboardHeight) {
      setState(() {
        _keyboardHeight = newKeyboardHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: CustomAppBar(appBarName: roomName, isLeading: true),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Obx(() {
              if (controller.hasSocketError.value) {
                return Expanded(
                  child: Center(
                    child: NoDataWidget(
                      title: controller.socketErrorMessage.value,
                    ),
                  ),
                );
              }

              return controller.obx(
                (messages) {
                  return Expanded(
                    child: ListView.separated(
                      controller: controller.scrollController,
                      padding: const .symmetric(horizontal: 10, vertical: 20),
                      itemBuilder: (_, i) {
                        MessageModel message = messages![i];

                        if (message.senderType == 'system') {
                          return Padding(
                            padding: const .symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.gray600Color.withValues(
                                        alpha: .1,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  message.text,
                                  style: AppTextStyles.regular12.copyWith(
                                    color: AppColors.black87Color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.black87Color.withValues(
                                        alpha: .1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        bool showTimeAtLastMessageOnly =
                            i == messages.length - 1 ||
                            message.senderType != messages[i + 1].senderType;
                        bool showProfileAtFirstMessageOnly =
                            !_isSentByMe(message.senderId) &&
                            (i == 0 || _isSentByMe(messages[i - 1].senderId));
                        // current message.senderName == previous message.senderName
                        bool isSameSenderAsPreviousMsg =
                            i > 0 &&
                            message.senderName == messages[i - 1].senderName;
                        return Column(
                          spacing: 4,
                          children: [
                            if (i == 0 ||
                                _isCurrentDateAfterPrevious(
                                  message.createdAt,
                                  messages[i - 1].createdAt,
                                ))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      message.createdAt.toLocal().isToday
                                          ? "اليوم"
                                          : message.createdAt
                                                .toLocal()
                                                .isYesterday
                                          ? AppLanguage.yesterdayStr.tr
                                          : message.createdAt
                                                .toLocal()
                                                .formatDateToYearMonthDay,
                                      style: AppTextStyles.medium12.copyWith(
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (message.validate &&
                                message.text != 'Audio Message')
                              MessageBubble(
                                message: message,
                                isSentByMe: _isSentByMe(message.senderId),
                                showTime: showTimeAtLastMessageOnly,
                                showProfile: showProfileAtFirstMessageOnly,
                                isSameSender: isSameSenderAsPreviousMsg,
                              ),
                          ],
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 0.5),
                      itemCount: messages?.length ?? 0,
                    ),
                  );
                },
                onLoading: const Expanded(child: Center(child: Loading())),
                onError: (e) => Expanded(
                  child: Center(
                    child: NoDataWidget(title: e ?? 'An error occurred'),
                  ),
                ),
              );
            }),
            const SendMessageBox(),

            SizedBox(height: _keyboardHeight > 0 ? 0 : 45),
          ],
        ),
      ),
    );
  }

  bool _isSentByMe(String senderId) =>
      gController.userId == senderId ||
      (senderId == 'current_user') && !gController.isTeacher;

  bool _isCurrentDateAfterPrevious(DateTime current, DateTime previous) {
    return current.day > previous.day ||
        current.month > previous.month ||
        current.year > previous.year;
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    this.showTime = false,
    this.showProfile = false,
    this.isSameSender = false,
  });

  final MessageModel message;
  final bool isSentByMe, showTime, showProfile, isSameSender;

  @override
  Widget build(BuildContext context) {
    final conv = Get.find<ConversationController>();

    return GestureDetector(
      onLongPress: () => deleteMessage(context),
      child: Row(
        mainAxisAlignment: isSentByMe ? .end : .start,
        crossAxisAlignment: .start,
        children: [
          // ? sender image
          if (!isSentByMe) ...[
            if (showProfile)
              SvgPicture.asset(
                AppAssets.icProfileFull,
                width: getDynamicWidth(32),
                colorFilter: .mode(
                  AppColors.primary.withValues(alpha: .7),
                  .srcIn,
                ),
              )
            else
              SizedBox(width: getDynamicWidth(32)),
            const SizedBox(width: 8),
          ],

          // ? message bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isSentByMe ? .end : .start,
              mainAxisSize: .min,
              children: [
                // ? message shape
                Container(
                  constraints: BoxConstraints(maxWidth: 0.75.screenWidth),
                  padding: message.isImage || message.isFile
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                  decoration: BoxDecoration(
                    gradient: isSentByMe
                        ? const LinearGradient(
                            colors: [Color(0xFF735BF2), Color(0xFFA58FFA)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: isSentByMe ? null : AppColors.neutralWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(24),
                      topRight: const Radius.circular(24),
                      bottomLeft: isSentByMe
                          ? const Radius.circular(4)
                          : const Radius.circular(24),
                      bottomRight: isSentByMe
                          ? const Radius.circular(24)
                          : const Radius.circular(4),
                    ),
                    border: Border.all(
                      color: isSentByMe
                          ? Colors.transparent
                          : AppColors.neutralMidGrey.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      // ? opposite sender name.
                      if (!isSentByMe && showProfile) ...[
                        Text(
                          message.senderName,
                          style: AppTextStyles.bold12.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],

                      // ? text message
                      if (message.isText)
                        Text(
                          message.text,
                          style: AppTextStyles.regular16.copyWith(
                            color: isSentByMe ? Colors.white : Colors.black87,
                          ),
                          textAlign: isSentByMe ? .right : .left,
                        )
                      // ? image message
                      else if (message.isImage && message.fileUrl != null)
                        SizedBox(
                          height: getDynamicHeight(156),
                          width: getDynamicWidth(350),
                          child: GestureDetector(
                            onTap: () => Get.to(
                              () => ShowImageGalleryScreen(
                                img: ["${ApiUrls.baseUrl}${message.fileUrl}"],
                                images: const [],
                                isLocal: false,
                              ),
                            ),
                            child: CustomNetworkImgProvider(
                              imageUrl: "${ApiUrls.baseUrl}${message.fileUrl}",
                              height: 156,
                              width: 156,
                              radius: 12,
                            ),
                          ),
                        )
                      // ? audio message
                      else if (message.isAudio && message.fileUrl != null)
                        AudioMessageBubble(
                          url: "${ApiUrls.baseUrl}${message.fileUrl}",
                          isSentByMe: isSentByMe,
                          duration: message.fileDuration != null
                              ? Duration(
                                  milliseconds: (message.fileDuration! * 1000)
                                      .toInt(),
                                )
                              : null,
                        )
                      // ? file message
                      else if (message.isFile && message.fileUrl != null)
                        Container(
                          height: 50,
                          padding: .symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () async {
                              if (isSentByMe) {
                                final fileName =
                                    (message.fileName ??
                                            (message.fileUrl?.split('/').last ??
                                                ''))
                                        .toString();
                                final localPath = conv.localPathFor(fileName);
                                if (localPath != null) {
                                  final ext = localPath
                                      .split('.')
                                      .last
                                      .toLowerCase();
                                  final isPdf = ext == 'pdf';
                                  if (isPdf) {
                                    Get.to(
                                      () => PdfViewerScreen(
                                        pdfUrl: localPath,
                                        isLocalFile: true,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Row(
                              children: [
                                // ? file icon
                                Icon(
                                  Icons.insert_drive_file,
                                  color: isSentByMe
                                      ? Colors.white
                                      : AppColors.mainColor,
                                ),
                                const SizedBox(width: 8),

                                // ? file name and size
                                [
                                      Text(
                                        (message.fileName ??
                                                message.fileUrl
                                                    ?.split('/')
                                                    .last ??
                                                'file')
                                            .toString(),
                                        maxLines: 1,
                                        overflow: .ellipsis,
                                        style: AppTextStyles.regular14.copyWith(
                                          color: isSentByMe
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        (message.fileSize!.toKBMB()),
                                        style: AppTextStyles.regular14.copyWith(
                                          color: isSentByMe
                                              ? Colors.white.withValues(
                                                  alpha: .55,
                                                )
                                              : Colors.black87,
                                        ),
                                      ),
                                    ]
                                    .toColumn(
                                      mainAxisAlignment: .center,
                                      crossAxisAlignment: .start,
                                    )
                                    .expanded(),
                                const SizedBox(width: 8),

                                // ? download / open button
                                if (!isSentByMe)
                                  Obx(() {
                                    final fileName =
                                        (message.fileName ??
                                                (message.fileUrl
                                                        ?.split('/')
                                                        .last ??
                                                    ''))
                                            .toString();
                                    final isLoading =
                                        conv.downloadingFiles[fileName] == true;
                                    final isDownloaded = conv.isDownloaded(
                                      fileName,
                                      message.fileUrl!,
                                    );

                                    if (isLoading) {
                                      return SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.neutralWhite,
                                        ),
                                      );
                                    }

                                    return IconButton(
                                      onPressed: () async {
                                        if (isDownloaded) {
                                          final localPath = conv.localPathFor(
                                            fileName,
                                          );
                                          if (localPath != null) {
                                            final ext = localPath
                                                .split('.')
                                                .last
                                                .toLowerCase();
                                            final isPdf = ext == 'pdf';
                                            if (isPdf) {
                                              Get.to(
                                                () => PdfViewerScreen(
                                                  pdfUrl: localPath,
                                                  isLocalFile: true,
                                                ),
                                              );
                                            }
                                          }
                                          return;
                                        }
                                        await conv.downloadAttachment(
                                          url:
                                              "${ApiUrls.baseUrl}${message.fileUrl}",
                                          fileName: fileName,
                                        );
                                      },
                                      icon: Icon(
                                        isDownloaded
                                            ? Icons.check_circle_rounded
                                            : Icons.download_rounded,
                                        color: isSentByMe
                                            ? AppColors.neutralWhite.withValues(
                                                alpha: .75,
                                              )
                                            : AppColors.mainColor,
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 2.5),

                if (showTime) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: isSentByMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (isSentByMe)
                        const Icon(
                          Icons.done_all_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      if (isSentByMe) const SizedBox(width: 4),
                      Text(
                        '${message.createdAt.toLocal().formatDateTime} ${message.createdAt.toLocal().formatAmPm}',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.black60Color,
                        ),
                      ),
                      if (!isSentByMe) const SizedBox(width: 4),
                      if (!isSentByMe && showProfile)
                        Icon(
                          Icons.done_all_rounded,
                          size: 14,
                          color: AppColors.black60Color,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteMessage(BuildContext context) async {
    if (!isSentByMe) {
      return;
    }

    final confirmed = await showAlertDialog(
      title: AppLanguage.warning.tr,
      content: AppLanguage.deleteMsgDesc.tr,
      cancelActionText: AppLanguage.cancel.tr,
      defaultActionText: AppLanguage.deleteStr.tr,
    );
    if (confirmed == true) {
      final controller = Get.find<ConversationController>();
      controller.deleteMessage(message.id);
    }
  }
}

class AudioMessageBubble extends StatefulWidget {
  final String url;
  final bool isSentByMe;
  final Duration? duration;

  const AudioMessageBubble({
    super.key,
    required this.url,
    required this.isSentByMe,
    this.duration,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  late AudioPlayer _player;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setSourceUrl(widget.url);

    if (widget.duration != null) {
      _duration = widget.duration!;
    }

    _durationSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _positionSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _playerStateSub = _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playerState = s);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    super.dispose();
  }

  void _playPause() async {
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(widget.url));
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const .all(8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _playerState == PlayerState.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              color: widget.isSentByMe ? Colors.white : AppColors.mainColor,
              size: 32,
            ),
            onPressed: _playPause,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: _duration.inMilliseconds > 0
                      ? _position.inMilliseconds / _duration.inMilliseconds
                      : 0.0,
                  backgroundColor: widget.isSentByMe
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.isSentByMe ? Colors.white : AppColors.mainColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isSentByMe
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isSentByMe
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
