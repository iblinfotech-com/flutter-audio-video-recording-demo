import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';

class VideoRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _VideoRecord();
}

class _VideoRecord extends State<VideoRecord> {
  final fileName = TextEditingController();

  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady = false;
  int selectedCamera = 0;
  bool noCameraDevice = false;

  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  String imagePath;
  String filePath;
  String dirPath;
  var filename;
  bool btnState = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

// ================================ Create Random Int for FileName ================================

  fileName1() {
    var rng = new Random();
    return rng.nextInt(1000);
  }

//  ========================================== Camera Open Function ==========================================

  Future<void> _setupCamera() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      controller =
          new CameraController(cameras[selectedCamera], ResolutionPreset.high);
      await controller.initialize();
    } on CameraException catch (_) {}
    if (!mounted) return;
    setState(() {
      isReady = true;
    });
  }

//  ========================================== Video Record start button ==========================================

  void onVideoRecordButtonPressed() {
    setState(() {
      btnState = true;
    });
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getExternalStorageDirectory();
    dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    filename = fileName1();
    print(filename);
    filePath = '$dirPath/$filename.mp4';
    print("filePath:$filePath");

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    print(e.code);
    print(e.description);
  }

//  ==========================================Video Record stop button ==========================================Video Record start button

  void onStopButtonPressed() {
    setState(() {
      btnState = false;
      fileName.text = "${filename.toString()}";
    });
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> stopVideoRecording() async {
    print("stopVideo");
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    fileNameAlertBox();
    try {
      print("try");
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void fileNameAlertBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter File Name"),
              content: new TextField(
                controller: fileName,
                autofocus: true,
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      _discard();
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('Done'),
                    onPressed: () {
                      _save();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  _save() async {
    var val = fileName.text;
    await new File(filePath).rename('$dirPath/$val.mp4');
  }

  _discard() async {
    new Directory("$dirPath/$filename.mp4").delete(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: Text("Record Video"), backgroundColor: appBar),
      body: cameraa(),
    );
  }

  Widget cameraa() {
    if (controller == null || !controller.value.isInitialized) {
      return new Container();
    }
    return Container(
        child: Column(children: <Widget>[
      new Expanded(child: new CameraPreview(controller)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
              iconSize: 40,
              icon: new Icon(Icons.camera_front),
              onPressed: () => toggleCamera()),
          new IconButton(
              iconSize: 40,
              icon: btnState == false
                  ? new Icon(Icons.camera)
                  : new Icon(Icons.stop),
              onPressed: () {
                btnState == false
                    ? onVideoRecordButtonPressed()
                    : onStopButtonPressed();
              }),
        ],
      )
    ]));
  }

  void toggleCamera() {
    setState(() {
      selectedCamera = (selectedCamera == 1) ? 0 : 1;
      _setupCamera();
    });
  }
}
