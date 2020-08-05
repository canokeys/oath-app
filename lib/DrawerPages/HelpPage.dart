import 'package:flutter/material.dart';
import 'AppFuncBrowse.dart';

class HelpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
              Navigator.pop(context);
          },
        ),
        title: Text('Help'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          InkWell(
            child: ListTile(
              title: Text('APP Instruction',style: TextStyle(fontSize: 24),),
              leading: Icon(Icons.help,size: 24,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppFuncBrowse()));
              },
            ),
          )
        ],
      ),
    );
  }
}
