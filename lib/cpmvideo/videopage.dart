import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AutoplayLoopVideo extends StatefulWidget {
  final String videoUrl;

  const AutoplayLoopVideo({super.key, required this.videoUrl});
  @override
  // ignore: library_private_types_in_public_api
  _AutoplayLoopVideoState createState() => _AutoplayLoopVideoState();
}

class _AutoplayLoopVideoState extends State<AutoplayLoopVideo> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        // Set to false to hide controls
        showControls: false,
        // Set to false to hide play/pause button
        showControlsOnInitialize: false,
        aspectRatio: 3 / 2,
        maxScale: double.infinity,
        // Set to false to hide the progress bar
        showOptions: false,
        draggableProgressBar: false);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
