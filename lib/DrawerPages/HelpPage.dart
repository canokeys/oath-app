import 'package:flutter/material.dart';

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
    );
  }
}
