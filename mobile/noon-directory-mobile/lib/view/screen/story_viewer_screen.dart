import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<dynamic> stories;
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> with SingleTickerProviderStateMixin {
  late int currentIndex;
  VideoPlayerController? _videoController;
  late AnimationController _progressController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _progressController = AnimationController(vsync: this);
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadStory(currentIndex);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _progressController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _loadStory(int index) async {
    setState(() => _isLoading = true);
    _progressController.reset();

    _videoController?.dispose();
    _videoController = null;

    final story = widget.stories[index];
    final videoUrl = story['videoUrl'] as String;

    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    try {
      await _videoController!.initialize();
      if (!mounted) return;
      
      final duration = story['duration'] != null
          ? Duration(seconds: story['duration'] as int)
          : _videoController!.value.duration;

      _progressController.duration = duration;
      _videoController!.play();
      _progressController.forward();
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _nextStory();
    }
  }

  void _nextStory() {
    if (currentIndex < widget.stories.length - 1) {
      setState(() => currentIndex++);
      _loadStory(currentIndex);
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStory() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _loadStory(currentIndex);
    }
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (details.globalPosition.dx < screenWidth / 3) {
      _prevStory();
    } else {
      _nextStory();
    }
  }

  void _onLongPressStart(_) {
    _videoController?.pause();
    _progressController.stop();
  }

  void _onLongPressEnd(_) {
    _videoController?.play();
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, context),
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video layer
            if (_videoController != null && _videoController!.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),

            // Loading indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),

            // Top gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),

            // Progress bars
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              child: Row(
                children: List.generate(
                  widget.stories.length,
                  (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: i < currentIndex
                            ? Container(color: Colors.white)
                            : i == currentIndex
                                ? AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (context, child) => LinearProgressIndicator(
                                      value: _progressController.value,
                                      backgroundColor: Colors.white30,
                                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                                      minHeight: 3,
                                    ),
                                  )
                                : Container(color: Colors.white30),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Story info header
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  // Advertiser avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.purple.shade400,
                    ),
                    child: Center(
                      child: Text(
                        (story['advertiserName'] ?? story['title'] ?? 'S')[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story['advertiserName'] ?? story['title'] ?? '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        if (story['title'] != null && story['advertiserName'] != null)
                          Text(
                            story['title'],
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom gradient + link button
            if (story['link'] != null && (story['link'] as String).isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    top: 40,
                    left: 20,
                    right: 20,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(story['link']);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward, size: 18, color: Colors.black87),
                          SizedBox(width: 6),
                          Text(
                            'اسحب للأعلى',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
