import 'package:canaokey/MainPages/Personal.dart';
import 'package:canaokey/Models/StreamBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MainPages/Home.dart';
import 'DrawerPages/HelpPage.dart';
import 'DrawerPages/AboutPage.dart';
import 'Models/Bloc.dart';

class LanBloc extends InheritedWidget {
  final LanguageBloc bloc;

  const LanBloc(
    this.bloc, {
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static LanBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanBloc>();
  }

  @override
  bool updateShouldNotify(LanBloc old) {
    return true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LanguageBloc bloc = LanguageBloc();
  runApp(LanBloc(bloc, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: ScaffoldRoute());
  }
}

class ScaffoldRoute extends StatefulWidget {
  int selectedIndex = 0;

  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  List<Language> languages = [
    Language.English,
    Language.Chinese,
    Language.Japanese
  ];
  int currentLanguage = 0;
  static HomeContent homeContent = new HomeContent();
  static PersonalContent personalContent = new PersonalContent();
  final _pageList = [homeContent, personalContent];

  radioDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
                content: Container(
              height: 300,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                        groupValue: currentLanguage,
                        activeColor: Colors.blue,
                        value: 0,
                        onChanged: (value) {
                          state(() {
                            currentLanguage = value;
                            print(currentLanguage);
                          });
                        },
                      ),
                      Text('English'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        groupValue: currentLanguage,
                        activeColor: Colors.blue,
                        value: 1,
                        onChanged: (value) {
                          state(() {
                            currentLanguage = value;
                            print(currentLanguage);
                          });
                        },
                      ),
                      Text('中文')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        groupValue: currentLanguage,
                        activeColor: Colors.blue,
                        value: 2,
                        onChanged: (value) {
                          state(() {
                            currentLanguage = value;
                            print(currentLanguage);
                          });
                        },
                      ),
                      Text('日本語')
                    ],
                  ),
                  FlatButton(
                    child: Streambuilder('confirm',
                        TextStyle(fontSize: 16, color: Colors.white)),
                    color: Colors.green,
                    onPressed: () {
                      LanBloc.of(context)
                          .bloc
                          .languageSink
                          .add(languages[currentLanguage]);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Streambuilder('app_title', TextStyle(fontSize: 22)),
            actions: <Widget>[
              IconButton(
                icon: Image.asset('lib/Images/CanokeyLogo.png'),
              ),
            ]),
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
                  title: Streambuilder('about_page', TextStyle(fontSize: 16)),
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
                  title: Streambuilder('help_page', TextStyle(fontSize: 16)),
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
              InkWell(
                child: ListTile(
                  title: Streambuilder('language', TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.language,
                    size: 30,
                  ),
                ),
                onTap: () {
                  radioDialog();
                },
              )
            ],
          ),
        ),
        //抽屉
        bottomNavigationBar: BottomNavigationBar(
          // 底部导航
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Streambuilder('home_page', TextStyle(fontSize: 14)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              title: Streambuilder('credentials_page', TextStyle(fontSize: 14)),
            ),
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
      widget.selectedIndex = index;
    });
  }
}
