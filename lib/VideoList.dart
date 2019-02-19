import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'VideoPlay.dart';
import 'package:path_provider/path_provider.dart';

class VideoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _VideoList();
}

class _VideoList extends State<VideoList> {
  List<String> data = List<String>();

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
    var systemTempDir = new Directory("$dirPath/Movies/flutter_test");
    print("path:$systemTempDir");
    systemTempDir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      setState(() {
        data.insert(0, entity.path);
      });
    });
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
                        data[index].split("/")[6],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new VideoPlay(
                                        DataIndex: data[index],
                                      )));
                        })
                  ])),
            );
          }),
    );
  }
}
