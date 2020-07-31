import 'package:flutter/material.dart';

class confirmDialog extends StatefulWidget {
  @override
  _confirmDialogState createState() => _confirmDialogState();
}

class _confirmDialogState extends State<confirmDialog> {
  String type = '0';

  _alertDialog() async{
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mention!'),
            content: Text('Are you sure to remove this $type ?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _alertDialog();
  }
}
