import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final PremadeRequestURL passableURL;

  const VideoPlayer({Key? key, required this.passableURL}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      widget.passableURL.url,
      httpHeaders: widget.passableURL.headers != null
          ? (widget.passableURL.headers!.map((key, value) => MapEntry(key, value.toString())))
          : {"User-Agent": getRandomUserAgent()},
    );

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        aspectRatio: 16 / 9,
        allowedScreenSleep: false,
        allowMuting: true,
        autoPlay: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(controller: _chewieController),
    );
  }
}
