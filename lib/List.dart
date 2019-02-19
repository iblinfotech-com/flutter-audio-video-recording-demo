import 'package:flutter/material.dart';
import 'AudioList.dart';
import 'VideoList.dart';
import 'globals.dart';

class RecodList extends StatefulWidget {
  RecodList({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => new RecordList();
}

class RecordList extends State<RecodList> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Audio List", icon: Icon(Icons.audiotrack)),
              Tab(text: "Video List", icon: Icon(Icons.videocam)),
            ],
          ),
          title: Text(widget.title),
          backgroundColor: appBar,
        ),
        body: TabBarView(
          children: [
            AudioList(),
            VideoList(),
          ],
        ),
      ),
    );
  }
}
