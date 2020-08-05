import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/CanokeyModule.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'dart:io' show sleep;
import 'package:awesome_dialog/awesome_dialog.dart';

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

  @override
  void initState(){
    super.initState();
    _nfcAvailabilityDetect();
    _loadInfo();
  }

  _loadInfo()async{
    final prefs =await SharedPreferences.getInstance();
    if (prefs.getStringList('id')!=null) {
      localID=prefs.getStringList('id');
      localStandard=prefs.getStringList('standard');
      localName=prefs.getStringList('name');
      localTransceive=prefs.getStringList('transceive');
      for (int i = 0; i < localID.length; i++) {
        CanokeysRow.add(CanokeyModule(
            UniqueKey(),
            this.removeWidget,
            localID[i],
            'Canokey',
            localStandard[i],
            localName[i],
            localTransceive[i]));
      }
    }
  }

  _alertDialog(String info) {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Mention!',
        desc: info,
        btnOkOnPress: () {}
    )..show();
  }

  _inputAndCreate() async{
    TextEditingController _controller = TextEditingController();
    final prefs=await SharedPreferences.getInstance();
    var tmpName = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: ListTile(
              title: Text(
                'Named your Canokey',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.border_color),
            ),
            content: Container(
              child: TextField(
                maxLength: 15,
                controller: _controller,
                autofocus: false,
              ),
              height: 50,
              width: 200,
//                alignment: Alignment.center,
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, _controller.text.toString());
                },
              )
            ],
          );
        });
    setState(() {
      if (_result == '9000') {
        _transceiveInfo = 'Enabled';
      } else {
        _transceiveInfo = 'Disabled';
      }
      _canokeyName = tmpName;
      idRepository.add(_nfcTag.id);
      CanokeysRow.add(CanokeyModule(UniqueKey(), this.removeWidget, _nfcTag?.id,
          'Canokey', _nfcTag?.standard, _canokeyName, _transceiveInfo));
      Map info={
        "nfcid":_nfcTag.id,
        "nfcstandard":_nfcTag.standard,
        "name":_canokeyName,
        "transceive":_transceiveInfo
      };
      localID.add(_nfcTag.id);
      localStandard.add(_nfcTag.standard);
      localName.add(_canokeyName);
      localTransceive.add(_transceiveInfo);
      prefs.setStringList('id', localID);
      prefs.setStringList('standard', localStandard);
      prefs.setStringList('name', localName);
      prefs.setStringList('transceive', localTransceive);
    });
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
              _result = 'Error: $error';
              _alertDialog(_result);
            });
            return;
          }
          if (_nfcTag.standard == 'ISO 14443-4 (Type A)') {
            _result =
                await FlutterNfcKit.transceive('00A4040007A0000005272101');
          }
          int tmpIndex = idRepository.indexOf(_nfcTag.id);
          if (tmpIndex == -1) {
            _inputAndCreate();
          } else {
            _alertDialog('This Canokey has been connected before');
          }
          sleep(new Duration(seconds: 1));
          await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
        },
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        children: <Widget>[
          ListTile(
            title: Text(
              'Equipment NFC Availability',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
    print('wIndex:$wIndex\nidRepository:$idRepository');
    CanokeysRow.remove(w);
    idRepository.removeAt(wIndex);
    setState(() {});
  }
}
