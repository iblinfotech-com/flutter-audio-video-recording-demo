import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'globals.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AudioRecord();
}

class _AudioRecord extends State<AudioRecord> {
  var fileName = TextEditingController();

  bool _isStart = false;
  bool _isStop = false;

  String btnStatus = "";
  String path = "";
  String filePath = "";
  var filename;
  var dirPath;

  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound = new FlutterSound();

  void initState() {
    super.initState();

    _localPath();
  }

  Future<String> _localPath() async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }

// ================================ Create folder for Storing Audio ================================

  createFolder() async {
    dirPath = await _localPath();
    new Directory("$dirPath/AudioRecord")
        .create(recursive: true)
        .then((Directory directory) {});
  }

// ================================ Create Random Int for FileName ================================

  fileName1() {
    var rng = new Random();
    return rng.nextInt(1000);
  }

// ================================ Click Event of Start Recording Button ================================

  _start() async {
    setState(() {
      btnStatus = "Start";
    });
    setState(() {
      _isStart = true;
      _isStop = false;
    });
    dirPath = await _localPath();
    final myDir = new Directory("$dirPath/AudioRecord");
    myDir.exists().then((isThere) {
      isThere ? print('exists') : createFolder();
    });
    filename = fileName1();
    filePath = "$dirPath/AudioRecord/$filename.mp4";
    print(filePath);
    path = await flutterSound.startRecorder(filePath);
  }

// ================================ Click Event of Stop Recording Button ================================

  _stop() async {
    setState(() {
      btnStatus = "Stop";
      fileName.text = "${filename.toString()}";
    });
    setState(() {
      _isStart = false;
      _isStop = true;
    });
    fileNameAlertBox();
    await flutterSound.stopRecorder();
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
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
                // decoration: new InputDecoration(): "$filename"),
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('Descard'),
                    onPressed: () {
                      _discard();
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('Save'),
                    onPressed: () {
                      _save();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  _save() async {
    var val = fileName.text;
    var dirPath = await _localPath();
    await new File(filePath).rename("$dirPath/AudioRecord/$val.mp4");
  }

  _discard() async {
    print("discard");
    print(filename);
    new Directory("$dirPath/AudioRecord/$filename.mp4").delete(recursive: true);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Audio Recoder"),
        backgroundColor: appBar,
      ),
      body: new Container(
          color: appColor,
          child: new Center(
              child: Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 100.0),
              ),
              Text(
                "Audio Recorder $btnStatus",
                style: TextStyle(fontSize: 20),
              ),
              new Padding(
                padding: new EdgeInsets.only(top: 50.0),
              ),
              // Start, Stop, Play, Pause Buttons
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        color: _isStart == true ? Colors.grey[300] : appColor,
                        child: IconButton(
                          iconSize: 50,
                          color: appBar,
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {
                            _start();
                          },
                        )),
                    Container(
                        color: _isStop == true ? Colors.grey[300] : appColor,
                        child: IconButton(
                          iconSize: 50,
                          color: appBar,
                          icon: Icon(Icons.stop),
                          onPressed: () {
                            _stop();
                          },
                        )),
                  ])
            ],
          ))),
    );
  }
}
