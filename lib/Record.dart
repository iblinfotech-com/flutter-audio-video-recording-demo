import 'package:flutter/material.dart';
import 'globals.dart';
import 'AudioRecord.dart';
import 'VideoRecod.dart';

class Record extends StatefulWidget {
  Record({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => new RecordAudioVideo();
}

class RecordAudioVideo extends State<Record> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: appBar,
      ),
      body: new Container(
          padding: new EdgeInsets.only(left: 30, right: 30),
          child: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                // Button for Audio Recording
                ButtonTheme(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 8.0,
                    child: new Text("Record Audio",
                        style:
                            new TextStyle(fontSize: 20, color: Colors.white)),
                    color: appBar,
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AudioRecord()));
                    },
                  ),
                ),
                new Padding(
                padding: new EdgeInsets.only(top: 20.0),
              ),
                ButtonTheme(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 8.0,
                    child: new Text("Record Video",
                        style:
                            new TextStyle(fontSize: 20, color: Colors.white)),
                    color: appBar,
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new VideoRecord()));
                    },
                  ),
                ),
              ]))),
    );
  }
}
