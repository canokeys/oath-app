import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DataSave.dart';
import 'StreamBuilder.dart';
// ignore: must_be_immutable
class CanokeyModule extends StatefulWidget {
  String id, type, standard, canokeyName, transeive;
  Function _callback;
  int recentVolume = 0, totalVolume = 0;

  CanokeyModule(Key key, this._callback, this.id,
      this.type, this.standard, this.canokeyName, this.transeive)
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
        body: Column(
          children: <Widget>[
            Streambuilder('dialog_attention',TextStyle(fontSize: 24)),
            Streambuilder('dialog_removeConfirm',TextStyle(fontSize: 16))
          ],
        ),
        btnOkOnPress: () async {
          DataBase dataBase = await Functions.loadDataBase(DataBase.filename);
          dataBase.removeDataById(widget.id);
          Functions.writeDataBase(DataBase.filename, dataBase);
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
                        title:  Streambuilder('canokey_name',TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),widget.canokeyName),
                        subtitle:Streambuilder('canokey_id',TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),widget.id),
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
                        title:  Streambuilder('canokey_standard',TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),widget.standard),
                      ),
                      ListTile(
                        title:  Streambuilder('canokey_OATH',TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),widget.transeive),
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
