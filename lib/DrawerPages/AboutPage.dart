import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutContent extends StatelessWidget {
  void _launchURL(String url) async {
    String url='https://github.com/canokeys/oath-app';
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              Navigator.pop(context);
          },
        ),
        title: Text('About'),
      ),
      body:ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          Container(
            height: 300,
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.blue, width: 3),
                image: DecorationImage(image: AssetImage('lib/Images/Canokey.png'), fit: BoxFit.fitWidth)),
          ),
          SizedBox(height: 25,),
          Text('Powered by Canokeys',style: TextStyle(fontSize: 24 ,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          ListTile(
            title: Text('Visit Github: ',style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold)),
            subtitle: InkWell(
              child:  Text('https://github.com/canokeys/oath-app',style: TextStyle(fontSize: 16,color: Colors.blue)),
              onTap: ()async {
                String url='https://github.com/canokeys/oath-app';
                if(await canLaunch(url)) {
                await launch(url);
                } else {
                print('Could not launch');
                }
              },
            ),
            leading: Icon(Icons.web),
          ),
          ListTile(
            title: Text('Email:',style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold)),
            subtitle: InkWell(
              child:  Text('2088083463@qq.com',style: TextStyle(fontSize: 16,color: Colors.blue)),
              onTap:()async{
                String url='mailto:2088083463@qq.com';
                if(await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch');
                }
              },
            ),
            leading: Icon(Icons.email),
          ),

        ],
      ),
    );
  }
}