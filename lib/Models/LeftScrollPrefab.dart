import 'dart:io' show sleep;
import 'package:canokey/Models/MultiLanguage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'StreamBuilder.dart';

// ignore: must_be_immutable, camel_case_types
class leftScroll extends StatefulWidget {
  Function callback;
  String text = 'null';
  String oneTimePassword;
  String nameInUtf8;
  // ignore: non_constant_identifier_names
  String Type;
  String calculateOrder;

  leftScroll(Key key, this.callback, this.text, this.nameInUtf8,
      this.oneTimePassword, this.Type)
      : super(key: key);

  @override
  _leftScrollState createState() => _leftScrollState();
}

// ignore: camel_case_types
class _leftScrollState extends State<leftScroll> {
  AsyncSnapshot<LanguagePackage> snapshot = new AsyncSnapshot.nothing();

  int _hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  String calculateKey(String str) {
    List<int> list = new List();
    for (int i = 0; i < str.length; i += 2) {
      String tmp = str[i] + str[i + 1];
      int tmpint = _hexToInt(tmp);
      list.add(tmpint);
    }
    print('list:$list');
    List strList = new List();
    for (int i = 0; i < list.length; i++) {
      strList.add(list[i].toRadixString(2).padLeft(8, '0'));
    }
    String radix2result = '';
    for (int i = 0; i < strList.length; i++) {
      radix2result += strList[i];
    }
    print(radix2result);
    var result = radix2to10(radix2result) % 1000000;
    return result.toString().padLeft(6, '0');
  }

  int radix2to10(String str) {
    int sum = 0;
    for (int i = 0; i < str.length; i++) {
      sum += int.parse(str[i]) * pow(2, str.length - 1 - i);
    }
    print(sum);
    return sum;
  }

  _alertDialog() {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        body: Column(
          children: <Widget>[
            Streambuilder('warning',TextStyle(fontSize: 24)),
            Streambuilder('dialog_removeConfirm',TextStyle(fontSize: 16))
          ],
        ),
        btnOkOnPress: () async {
          String nm = widget.nameInUtf8;
          int tmplength = widget.text.length + 2;
          String length, nmLenth;
          length=tmplength.toRadixString(16).padLeft(2,'0');
          nmLenth=(tmplength-2).toRadixString(16).padLeft(2,'0');
          String command = '00020000${length}71${(nmLenth)}$nm';
          await FlutterNfcKit.poll();
          await FlutterNfcKit.transceive('00A4040007A0000005272101');
          String result = await FlutterNfcKit.transceive((command));
          if (result == '9000') {
            widget.callback(this.widget);
          }
        },
      btnCancelOnPress: (){}
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoLeftScroll(
          key: Key('TODO: your key'),
          closeTag: LeftScrollCloseTag('TODO: your tag'),
          buttonWidth: 120,
          bounce: true,
          child: Container(
              height: 150,
              color: Colors.white,
              alignment: Alignment.center,
              child: ListTile(
                title: Text(
                  'password: ${widget.oneTimePassword}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Name: ${widget.text}\nType:${widget.Type}',
                  style: TextStyle(fontSize: 12),
                ),
                leading: Icon(Icons.vpn_key),
                trailing: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      String nameLen = (widget.nameInUtf8.length / 2)
                          .floor()
                          .toRadixString(16)
                          .padLeft(2, '0');
                      int datalen = 2 + (widget.nameInUtf8.length / 2).floor();
                      String tmpOrder = '00040000';
                      if (widget.Type == 'TOTP') {
                        int currentTime =
                            (new DateTime.now().millisecondsSinceEpoch / 1000)
                                .round();
                        String challenge = (currentTime / 30)
                            .floor()
                            .toRadixString(16)
                            .padLeft(16, '0');
                        datalen += 10;
                        tmpOrder +=
                            '${datalen.toRadixString(16).padLeft(2, '0')}71$nameLen${widget.nameInUtf8}7408$challenge';
                      } else {
                        tmpOrder +=
                            '${datalen.toRadixString(16).padLeft(2, '0')}71$nameLen${widget.nameInUtf8}';
                      }
                      print(tmpOrder);
                      await FlutterNfcKit.poll();
                      String connect = await FlutterNfcKit.transceive(
                          '00A4040007A0000005272101');
                      print(connect);
                      String calculate =
                          await FlutterNfcKit.transceive(tmpOrder);
                      print(calculate);
                      String hexKey = calculate.substring(6, 14);
                      String calResult = calculateKey(hexKey);
                      sleep(new Duration(seconds: 1));
                      await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
                      setState(() {
                        widget.oneTimePassword = calResult;
                      });
                    }),
              )),
          buttons: <Widget>[
            LeftScrollItem(
              text: 'Delete',
              color: Colors.red,
              onTap: () async {
                _alertDialog();
                setState(() {});
              },
              textColor: Colors.white,
            )
          ],
        ),
        Container(
          color: Colors.grey,
          height: 1.0,
        )
      ],
    );
  }
}
