import 'package:flutter/material.dart';
import 'globals.dart';
import 'List.dart';
import 'Record.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _simpleBottomBar();
  }
}

class _simpleBottomBar extends State<Home> {
  @override
  int _currentIndex = 0;
  final _widgetOptions = [
    RecodList(title: 'Record List'),
    Record(title: 'Recode')
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentIndex),
      // backgroundColor: appBar,
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: appBar,
        ),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          fixedColor: Colors.white, //when item selected
          items: [
            new BottomNavigationBarItem(
                title: Text('List'), icon: Icon(Icons.list)),
            new BottomNavigationBarItem(
                title: Text('Record'), icon: Icon(Icons.radio_button_checked))
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Message extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        alignment: Alignment.center,
        child: IconButton(
          iconSize: 200,
          color: Colors.indigo[200],
          icon: Icon(Icons.mail),
          onPressed: () {},
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      alignment: Alignment.center,
      child: IconButton(
        iconSize: 200,
        color: Colors.indigo[200],
        icon: Icon(Icons.person),
        onPressed: () {},
      ),
    ));
  }
}
