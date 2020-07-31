import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

// ignore: must_be_immutable
class CanokeyModule extends StatefulWidget {
  String text, type, standard,canokeyName,transeive;
  Function _callback;
  int recentVolume = 0,
      totalVolume = 0;


  CanokeyModule(Key key, @required this._callback, String this.text,
      String this.type, this.standard,this.canokeyName,this.transeive)
      : super(key: key);

  @override
  _CanokeyModuleState createState() => _CanokeyModuleState();
}

class _CanokeyModuleState extends State<CanokeyModule> {
  MaterialAccentColor widgetColor = Colors.lightBlueAccent;

  _alertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mention!'),
            content: Text('Are you sure to remove this ${widget.type} ?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text('Yes'),
                onPressed: () {
                  widget._callback(this.widget);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
            child: Ink(
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: widgetColor, width: 1.0),
              ),
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListView(
                        physics: new NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          ListTile(
                            title: Text('Name: ${widget.canokeyName}',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
                            subtitle: Text('Canokey ID: ${widget.text}'
                              ,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                _alertDialog();
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            title: Text(
                              'Volume: ${widget.recentVolume}/${widget
                                  .totalVolume}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              'Standard: ${widget.standard}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          ListTile(title: Text(
                            'OATH Application: ${widget.transeive}', style: TextStyle(
                              color: Colors.white, fontSize: 16),
                          ),)
                        ],
                      ),
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/Images/canokeyTag.png'),
                            alignment: Alignment.centerLeft,
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
                onTap: () async {
                  setState(() {

                  }); //详细信息页
                },
              ),
            )),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
