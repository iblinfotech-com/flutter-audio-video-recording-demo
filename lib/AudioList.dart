import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AudioList();
}

class _AudioList extends State<AudioList> {
  var previousIndex = null;
  bool _isPlay = false;
  bool _isStop = false;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound = new FlutterSound();
  
  List<String> data = List<String>();
  List<bool> dataSelect = List<bool>();

  void initState() {
    super.initState();

    LoadData();
  }

// ================================ Find Local Path of folder ================================

  Future<String> _localPath() async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }

// ================================ Load Data for List View ================================

  LoadData() async {
    var dirPath = await _localPath();
    var systemTempDir = new Directory("$dirPath/AudioRecord");
    systemTempDir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      setState(() {
        data.insert(0, entity.path);
        dataSelect.add(false);
      });
    });
  }

// ================================ Click Event Of Play Button ================================

  _play(index) async {
    _pause(index);
    if (previousIndex != null && previousIndex != index) {
      setState(() {
        _isPlay = true;
        _isStop = false;
        dataSelect[index] = true;
        dataSelect[previousIndex] = false;
        previousIndex = index;
      });
    } else {
      setState(() {
        _isPlay = true;
        _isStop = false;
        dataSelect[index] = true;
        previousIndex = index;
      });
    }
    await flutterSound.startPlayer(data[index]);
  }

// ================================ Click Event Of Pause Button ================================

  _pause(index) async {
    setState(() {
      _isPlay = false;
      _isStop = true;
      dataSelect[index] = false;
    });
    await flutterSound.stopPlayer();
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: Row(children: <Widget>[
                    new Expanded(
                      child: Text(
                        data[index].split("/")[5],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                        iconSize: 40,
                        icon: !dataSelect[index]
                            ? Icon(Icons.play_arrow)
                            : Icon(Icons.stop),
                        onPressed: () {
                          !dataSelect[index] ? _play(index) : _pause(index);
                        })
                  ])),
            );
          }),
    );
  }
}
