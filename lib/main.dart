import 'package:canaokey/MainPages/Personal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MainPages/Home.dart';
import 'DrawerPages/SettingsPage.dart';
import 'DrawerPages/HelpPage.dart';
import 'DrawerPages/AboutPage.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: ScaffoldRoute()
    );
  }
}

class ScaffoldRoute extends StatefulWidget {
  int selectedIndex = 0;
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  static HomeContent homeContent=new HomeContent();
  static PersonalContent personalContent=new PersonalContent();
  final _pageList = [
    homeContent,
    personalContent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Canokey Users Client"),
          actions: <Widget>[
            IconButton(
              icon: Image.asset('lib/Images/CanokeyLogo.png'),
            ),
          ]
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  )),
              InkWell(
                child: ListTile(
                  //Settings
                  title: Text(
                    'Settings',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsContent()));
                  });
                },
              ),
              InkWell(
                child: ListTile(
                  //Settings
                  title: Text(
                    'About',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.error,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AboutContent()));
                  });
                },
              ),
              InkWell(
                child: ListTile(
                  //Settings
                  title: Text(
                    'Help',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.help,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HelpContent()));
                  });
                },
              ),
            ],
          ),
        ),
        //抽屉
        bottomNavigationBar: BottomNavigationBar(
          // 底部导航
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), title: Text('Credentials')),
          ],
          currentIndex: widget.selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        body: IndexedStack(
          index: widget.selectedIndex,
          children: _pageList,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex= index;
    });
  }
}
