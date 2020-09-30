import 'package:canokey/Models/StartPage.dart';
import 'package:canokey/Models/DataSave.dart';
import 'package:canokey/Models/Tutorial.dart';
import 'package:canokey/Models/CredentialModule.dart';
import 'package:canokey/Models/StreamBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DrawerPages/AboutPage.dart';
import 'package:canokey/Models/Bloc.dart';

class LanBloc extends InheritedWidget {
  final LanguageBloc bloc;
  final Settings settings;

  const LanBloc(
    this.bloc,
    this.settings, {
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LanguageBloc bloc = LanguageBloc();
  Settings settings = await Functions.loadSettings(Settings.filename);
  runApp(LanBloc(bloc, settings, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: StartPage(),
    );
  }
}

// ignore: must_be_immutable
class ScaffoldRoute extends StatefulWidget {
  int selectedIndex = 0;

  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  List<Language> languages = [
    Language.English,
    Language.Chinese,
    Language.Japanese,
    Language.French,
    Language.German,
  ];
  int currentLanguage;

  @override
  void initState() {
    Tutorial.initTargets();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (!LanBloc.of(context).settings.flag) {
          Tutorial.showTutorial(context);
          LanBloc.of(context).settings.setFlag(true);
          Functions.writeSettings(
              Settings.filename, LanBloc.of(context).settings);
        }
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      currentLanguage = LanBloc.of(context).settings.currentLan;
    });
    super.didChangeDependencies();
  }

  Radio genRadio(int v,Function function){
    Radio radio = Radio(
      groupValue: currentLanguage,
      activeColor: Colors.blue,
      value: v,
      onChanged:function
    );
    return radio;
  }

  radioDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            Function func = (value) {
              state(() {
                currentLanguage = value;
                print(currentLanguage);
              });
            };
            return AlertDialog(
                content: Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      genRadio(0, func),
                      Text('English'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      genRadio(1, func),
                      Text('中文')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      genRadio(2, func),
                      Text('日本語')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      genRadio(3, func),
                      Text('Français')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      genRadio(4, func),
                      Text('Deutsch')
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
                      LanBloc.of(context)
                          .settings
                          .setCurrentLan(currentLanguage);
                      Functions.writeSettings(
                          Settings.filename, LanBloc.of(context).settings);
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
                icon: Icon(Icons.help),
                onPressed: () {
                  Tutorial.showTutorial(context);
                },
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
                  onTap: () {
                    Navigator.pop(context);
                    Tutorial.showTutorial(context);
                  },
                ),
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
        body: KeysModule());
  }
}
