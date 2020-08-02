import 'package:canaokey/MainPages/Personal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MainPages/Home.dart';
import 'DrawerPages/SettingsPage.dart';
import 'DrawerPages/HelpPage.dart';
import 'DrawerPages/AboutPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: ScaffoldRoute(),
    );
  }
}

class ScaffoldRoute extends StatefulWidget {
  int selectedIndex = 0;
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {

  String accountName = 'Chino';
  bool login = false;
  String loginText = 'Login';
  String _credential;
  Color loginButtonColor = Colors.green;
  static HomeContent homeContent=new HomeContent();
  static PersonalContent personalContent=new PersonalContent();
  final _pageList = [
    //点击并加载的页面
    homeContent,
    personalContent
  ];

  String get credentialList => _credential;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text("Canokey Users Client"),
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
              Container(
                //头像
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(160),
                    border: Border.all(color: Colors.blue, width: 1.0),
                    image: DecorationImage(
                        image: AssetImage(
                            'lib/Images/AccountTest.jpg'),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: Text(
                  'Account:$accountName',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
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
              SizedBox(
                height: screenSize.height-550,
              ),
              InkWell(
                child: ListTile(
                  title: Text(
                    loginText,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(
                    Icons.power_settings_new,
                    size: 30,
                    color: loginButtonColor,
                  ),
                ),
                onTap: () {
                  setState(() {
                    login = !login;
                    if (login) {
                      loginText = 'Quit';
                      loginButtonColor = Colors.red;
                    } else {
                      loginText = 'Login';
                      loginButtonColor = Colors.green;
                    }
                  });
                },
              )
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
