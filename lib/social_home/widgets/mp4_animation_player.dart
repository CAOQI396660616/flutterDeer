// ignore_for_file: always_put_control_body_on_new_line

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Mp4AnimationPlayer extends StatefulWidget {
  const Mp4AnimationPlayer(
      {super.key,
      required this.asset,
      this.onCompleted,
      this.borderRadius = const BorderRadius.all(Radius.circular(16))});

  final String asset;
  final VoidCallback? onCompleted;
  final BorderRadius borderRadius;

  @override
  State<Mp4AnimationPlayer> createState() => _Mp4AnimationPlayerState();
}

class _Mp4AnimationPlayerState extends State<Mp4AnimationPlayer> {
  late final VideoPlayerController _controller;
  bool _completed = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)..addListener(_onVideoChanged);
    _initialize();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onVideoChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      if (_failed) {
        return const ColoredBox(
          color: Color(0xFF2B3031),
          child: Center(child: Icon(Icons.ondemand_video, color: Colors.white38, size: 32)),
        );
      }
      return const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF14D8D4)));
    }
    final Size videoSize = _controller.value.size;
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
            width: videoSize.width, height: videoSize.height, child: VideoPlayer(_controller)),
      ),
    );
  }

  void _onVideoChanged() {
    if (_completed || !_controller.value.isInitialized) return;
    final Duration position = _controller.value.position;
    final Duration duration = _controller.value.duration;
    if (duration > Duration.zero && position >= duration) {
      _completed = true;
      widget.onCompleted?.call();
    }
  }

  Future<void> _initialize() async {
    try {
      await _controller.initialize();
      if (!mounted) return;
      await _controller.setLooping(false);
      await _controller.setVolume(0);
      await _controller.play();
      setState(() {});
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }
}
