import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayback extends StatefulWidget {
  @override
  _VideoPlaybackState createState() => _VideoPlaybackState();
}

class _VideoPlaybackState extends State<VideoPlayback> {
  VideoPlayerController _playerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    _playerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _playerController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _playerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            child: VideoPlayer(_playerController),
            aspectRatio: _playerController.value.aspectRatio,
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
