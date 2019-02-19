import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  String DataIndex;
  VideoPlay({Key key, this.DataIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _VideoPlay(videoPath: DataIndex);
}

class _VideoPlay extends State<VideoPlay> {
  _VideoPlay({Key key, this.videoPath});
  String videoPath;
  VideoPlayerController videoController;

  void initState() {
    super.initState();
    _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    videoController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
        backgroundColor: appBar,
      ),
      body: Center(
        child: videoController.value.initialized
            ? AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            videoController.value.isPlaying
                ? videoController.pause()
                : videoController.play();
          });
        },
        child: Icon(
          videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
