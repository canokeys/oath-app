import 'package:canaokey/Models/StreamBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/CanokeyModule.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'dart:io' show sleep;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canaokey/Models/DataSave.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  var CanokeysRow = <Widget>[];
  NFCAvailability _nfcAvailability = NFCAvailability.not_supported;
  MaterialColor nfcAvailabilityColor = Colors.green;
  NFCTag _nfcTag;
  String _result, _canokeyName = 'null', _transceiveInfo;
  List<String> idRepository = new List();
  List<String> localID= new List(),localStandard= new List(),localName= new List(),localTransceive= new List();
  DataBase database;

  @override
  void initState(){
    super.initState();
    _nfcAvailabilityDetect();
    _loadInfo();
  }

  _loadInfo()async{
    database = await Functions.loadDataBase(DataBase.filename);
    CanokeysRow = database.database.map((data) => CanokeyModule(UniqueKey(), this.removeWidget, data.id, 'CanoKey', data.standard, data.name, data.transceive)).toList();
  }

  _alertDialog(String info) {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        body:Column(
          children: <Widget>[
            Streambuilder('dialog_attention',TextStyle(fontSize: 24)),
            Streambuilder(info,TextStyle(fontSize: 16))
          ],
        ) ,
        btnOkOnPress: () {}
    )..show();
  }

  _inputAndCreate() async{
    TextEditingController _controller = TextEditingController();
    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Input',
      body: Column(
        children: <Widget>[
          Streambuilder('namedCanokey',TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Container(
            child:
              TextField(
                maxLength: 15,
                controller: _controller,
                autofocus: false,
              ),
            height: 50,
            width: 200,
           )
        ],
      ),
      btnOkOnPress: (){
      setState(() {
        if (_result == '9000') {
          _transceiveInfo = 'Enabled';
        } else {
          _transceiveInfo = 'Disabled';
        }
        _canokeyName = _controller.text;
        idRepository.add(_nfcTag.id);
        CanokeysRow.add(CanokeyModule(UniqueKey(), this.removeWidget, _nfcTag?.id, 'Canokey', _nfcTag?.standard, _canokeyName, _transceiveInfo));
        Data newData = Data(_nfcTag.id, _nfcTag.standard, _canokeyName, _transceiveInfo);
        database.addData(newData);
        Functions.writeDataBase(DataBase.filename, database);
      });
      }
    )..show();
  }

  _nfcAvailabilityDetect() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }
    if (!mounted) return;
    setState(() {
      _nfcAvailability = availability;
      if (_nfcAvailability == NFCAvailability.available) {
        nfcAvailabilityColor = Colors.green;
      } else if (_nfcAvailability == NFCAvailability.not_supported) {
        nfcAvailabilityColor = Colors.grey;
      } else {
        nfcAvailabilityColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.cast_connected),
        onPressed: () async {
          try {
            NFCTag tag = await FlutterNfcKit.poll();
            setState(() {
              _nfcTag = tag;
            });
          } catch (error) {
            setState(() {
              _result = 'Error: poll time out';
              _alertDialog(_result);
            });
            return;
          }
          if (_nfcTag.standard == 'ISO 14443-4 (Type A)') {
            _result =
                await FlutterNfcKit.transceive('00A4040007A0000005272101');
          }
          DataBase dataBase = await Functions.loadDataBase(DataBase.filename);
          int tmpIndex = dataBase.getIndexById(_nfcTag.id);
          if (tmpIndex == -1) {
            _inputAndCreate();
          } else {
            _alertDialog('detectBefore');
          }
          sleep(new Duration(seconds: 1));
          await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
        },
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        children: <Widget>[
          ListTile(
            title: Streambuilder('NFC_availability',TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(
              '$_nfcAvailability',
              style: TextStyle(color: nfcAvailabilityColor),
            ),
            leading: Icon(
              Icons.nfc,
              color: nfcAvailabilityColor,
            ),
            trailing: IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.black,
              onPressed: (){
                _nfcAvailabilityDetect();
                setState(() {});
              },
            ),
          ),
          Column(
            children: CanokeysRow,
          )
        ],
      ),
    );
  }

  void removeWidget(Widget w) {
    int wIndex = CanokeysRow.indexOf(w);
    print('wIndex:$wIndex');
    CanokeysRow.remove(w);
    setState(() {});
  }
}
