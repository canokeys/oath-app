import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CanokeyModule extends StatefulWidget {
  String id, type, standard, canokeyName, transeive;
  Function _callback;
  int recentVolume = 0, totalVolume = 0;

  CanokeyModule(Key key, @required this._callback, String this.id,
      String this.type, this.standard, this.canokeyName, this.transeive)
      : super(key: key);

  @override
  _CanokeyModuleState createState() => _CanokeyModuleState();
}

class _CanokeyModuleState extends State<CanokeyModule> {
  MaterialAccentColor widgetColor = Colors.lightBlueAccent;

  _alertDialog() {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Mention!',
        desc: 'Are you sure to remove this ${widget.type} ?',
        btnOkOnPress: () async {
          final prefs = await SharedPreferences.getInstance();
          List<String> localID = prefs.getStringList('id');
          List<String> localStandard = prefs.getStringList('standard');
          List<String> localName = prefs.getStringList('name');
          List<String> localTransceive = prefs.getStringList('transceive');
          print('Before\nid:$localID\nstandard:$localStandard\nname:$localName\ntransceive:$localTransceive');
          localID.remove(widget.id);
          localStandard.remove(widget.standard);
          localName.remove(widget.canokeyName);
          localTransceive.remove(widget.transeive);
          print('After\nid:$localID\nstandard:$localStandard\nname:$localName\ntransceive:$localTransceive');
          prefs.setStringList('id', localID);
          prefs.setStringList('standard', localStandard);
          prefs.setStringList('name', localName);
          prefs.setStringList('transceive', localTransceive);
          widget._callback(this.widget);
        },
        btnCancelOnPress: () {})
      ..show();
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
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListTile(
                        title: Text('Name: ${widget.canokeyName}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Canokey ID: ${widget.id}',
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
                          'Standard: ${widget.standard}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'OATH Application: ${widget.transeive}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('lib/Images/CanokeyTag.png'),
                    alignment: Alignment.centerLeft,
                  )),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        )),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
