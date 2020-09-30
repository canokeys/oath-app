import 'package:canokey/main.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  void initState() {
    super.initState();
    countDown();
  }

  void countDown() {
    var _duration = Duration(seconds: 3);
    Future.delayed(_duration, newPage);
  }

  void newPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ScaffoldRoute()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.height / 5,
                  ),
                  Container(
                    height: size.height / 2.75,
                    width: size.height / 2.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('lib/Images/Canokey.png'))),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Text(
                    'Canokey Client',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w100),
                  ),
                  SizedBox(
                    height: size.height / 5,
                  ),
                  Text(
                    'version: 0.0.3',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              width: size.width,
              height: size.height,
            )
          ],
        ),
      ),
    );
  }
}
