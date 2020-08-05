import 'dart:math';
import 'package:canaokey/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:canaokey/Models/LeftScrollPrefab.dart';
import 'dart:io' show sleep;
import 'dart:convert';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:base32/base32.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class KeysModule extends StatefulWidget {
  String heroTag;

  KeysModule(Key key, this.heroTag) : super(key: key);

  @override
  _KeysModuleState createState() => _KeysModuleState();
}

class _KeysModuleState extends State<KeysModule> {
  bool enableCanokey = false;
  var HomeRow = <Widget>[];

  List<String> parseData(String credentialList) {
    RegExp _regexp = RegExp(r"(71\w*?7502\w{4})");
    List<RegExpMatch> _matches = _regexp.allMatches(credentialList).toList();
    return _matches.map((_match) => _match.group(1)).toList();
  }

  parseResponse(String response, List<String> hotp, List<Map> totp) {
    print(response);
    for (int i = 0; i < response.length; i++) {
      if (response[i] + response[i + 1] + response[i + 2] + response[i + 3] ==
          '9000')
        return;
      else if (response[i] + response[i + 1] == '71') {
        int nameLen = _hexToInt(response[i + 2] + response[i + 3]) * 2;
        String name = response.substring(
            i + 4, i + 4 + nameLen); //print('name: $name');
        if (response[i + 4 + nameLen] + response[i + 4 + nameLen + 1] == '77') {
          hotp.add(name);
          i += (4 + nameLen + 6) - 1;
        } else
        if (response[i + 4 + nameLen] + response[i + 4 + nameLen + 1] == '76') {
          String totpkey = response.substring(
              i + 4 + nameLen + 6, i + 4 + nameLen + 14);
          Map totpInfo = {
            'totpName': name,
            'totpKey': totpkey
          };
          totp.add(totpInfo);
          i += (4 + nameLen + 14) - 1;
        }
      }
    }
  }

  Map<String, dynamic> otpauth(String input) {
    RegExp _regexp = RegExp(r"otpauth://(.+)/(.+)\?(.+)$");
    RegExpMatch _match = _regexp.firstMatch(input);
    Map<String, dynamic> result = {
      "otpType": _match.group(1),
      "otpName": _match.group(2)
    };
    result.addAll(Uri.splitQueryString(_match.group(3)));
    return result;
  }

  scan() async {
    var scanResult = await BarcodeScanner.scan();
    print(scanResult.rawContent); // The barcode content
    Map regResult = otpauth(scanResult.rawContent);
    print(regResult);
    String order = '00010000';
    String otpType;
    int datalen = 0;
    String otpName = regResult['otpName'];
    String tmpStr = '';
    for (int i = 0; i < otpName.length; i++) {
      if (otpName[i] == '%') {
        int decode = int.parse(otpName[i + 1] + otpName[i + 2], radix: 16);
        String tmp = utf8.decode([decode]);
        tmpStr += tmp;
        i += 2;
      } else {
        tmpStr += otpName[i];
      }
    }
    otpName = tmpStr;
    List<int> encodeName = utf8.encode(otpName);
    String accountName = '';
    for (int i = 0; i < encodeName.length; i++) {
      accountName += encodeName[i].toRadixString(16);
    }
    int nmlen = (accountName.length / 2).round();
    String nameLen;
    nameLen = nmlen.toRadixString(16).padLeft(2, '0');
    String key = base32.decodeAsHexString(regResult['secret']);
    print(key);
    int keyDatalen = (key.length / 2).round() + 2;
    String keyLen;
    keyLen = keyDatalen.toRadixString(16).padLeft(2, '0');
    print(keyLen);
    datalen += (2 + nmlen + 2 + keyDatalen);
    String dataLen;
    dataLen = datalen.toRadixString(16).padLeft(2, '0');
    if (regResult['otpType'] == 'hotp') {
      otpType = '11';
      String counterData = '';
      if (regResult['counter'] != null) {
        int counterlen = regResult['counter']
            .toString()
            .length;
        int cnt = 0;
        while (cnt < 8 - counterlen) {
          counterData += '0';
          cnt++;
        }
        datalen += 6;
        dataLen = datalen.toRadixString(16).padLeft(2, '0');
        counterData += int.parse(regResult['counter'], radix: 16).toString();
        print(counterData);
        order +=
        '${dataLen}71${nameLen}${accountName}73${keyLen}${otpType}06${key}7A04${counterData}';
      } else {
        order +=
        '${dataLen}71${nameLen}${accountName}73${keyLen}${otpType}06${key}';
      }
      print(order);
      _writeDialog(order);
    } else {
      otpType = '21';
      order +=
      '${dataLen}71${nameLen}${accountName}73${keyLen}${otpType}06${key}';
      print(order);
      _writeDialog(order);
    }
  }

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

  _successDialog(String info) {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Success!',
        desc: info,
        btnOkOnPress: () {}
    )
      ..show();
  }

  _failedDialog(String info) {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Failed',
        desc: info,
        btnOkOnPress: () {}
    )
      ..show();
  }

  _writeDialog(String order) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Mention!',
      desc: 'Please use NFC to connect Canokey.We are adding new account now.',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await FlutterNfcKit.poll();
        String re1 = await FlutterNfcKit.transceive(
            '00A4040007A0000005272101');
        print(re1);
        if (re1 == '9000') {
          String re2 = await FlutterNfcKit.transceive(order);
          print(re2);
          if (re2 == '9000') {
            _successDialog('Add Account Successfully.');
          }
          else {
            _failedDialog(
                'Something Went Wrong!Please Try Again.Maybe This Account Has Been Added Before?');
          }
        }
        else {
          _failedDialog(
              'Something Went Wrong!Please Try Again.The Connection Went Wrong.');
        }
        sleep(new Duration(seconds: 1));
        await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
      },
      btnOkText: 'Start Connecting',
    )
      ..show();
//    String content =
//        'Please use NFC to connect Canokey.We are adding new account now.';
//    showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('Mention!'),
//            content: Text(content),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Start connecting'),
//                color: Colors.red,
//                onPressed: () async {
//                  NFCTag tag = await FlutterNfcKit.poll();
//                  String re1 = await FlutterNfcKit.transceive(
//                      '00A4040007A0000005272101');
//                  print(re1);
//                  if (re1 == '9000') {
//                    String re2 = await FlutterNfcKit.transceive(order);
//                    print(re2);
//                    if (re2 == '9000') {
//                      Navigator.pop(context);
//                      _successDialog('Add Account Successfully.');
//                    }
//                  }
//                  sleep(new Duration(seconds: 1));
//                  await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
//                },
//              ),
//              FlatButton(
//                child: Text('Cancel'),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              )
//            ],
//          );
//        });
  }

  _alertDialog() {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Mention!',
        desc: 'Credentials are null!',
        btnOkOnPress: () {}
    )
      ..show();
  }

  _addDialog() {
    TextEditingController _name = TextEditingController();
    TextEditingController _key = TextEditingController();
    int groupValue = 0;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return AlertDialog(
                title: Text('Add New Account'),
                content: Container(
                  height: 250,
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      Text('Account Name'),
                      Container(
                        child: TextField(
                          maxLength: 64,
                          controller: _name,
                          autofocus: false,
                        ),
                        height: 50,
                        width: 200,
                      ),
                      Text('Key (In Base32)'),
                      Container(
                        child: TextField(
                          maxLength: 128,
                          controller: _key,
                          autofocus: false,
                        ),
                        height: 50,
                        width: 200,
//                alignment: Alignment.center,
                      ),
                      Row(
                        children: <Widget>[
                          Text('HOTP'),
                          Radio(
                            value: 0,
                            groupValue: groupValue,
                            onChanged: (v) {
                              if (mounted)
                                state(() {
                                  groupValue = v;
                                  print(groupValue);
                                });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('TOTP'),
                          Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (v) {
                              if (mounted)
                                state(() {
                                  groupValue = v;
                                  print(groupValue);
                                });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    color: Colors.red,
                    onPressed: () async {
                      print('name:${_name.text},key:${_key
                          .text},type:$groupValue');
                      String typeAndalgorithm,
                          nameInutf8 = '';
                      if (groupValue == 0)
                        typeAndalgorithm = '11';
                      else
                        typeAndalgorithm = '21';
                      var intList = utf8.encode(_name.text);
                      for (int i = 0; i < intList.length; i++) {
                        nameInutf8 += intList[i].toRadixString(16);
                      }
                      String key = typeAndalgorithm + '06' +
                          base32.decodeAsHexString(_key.text);
                      int datalen = 2 + (nameInutf8.length / 2).floor() + 2 +
                          (key.length / 2).floor();
                      String nameLength = (nameInutf8.length / 2)
                          .floor()
                          .toRadixString(16)
                          .padLeft(2, '0');
                      String keyLength = (key.length / 2).floor().toRadixString(
                          16).padLeft(2, '0');
                      String dataLength = datalen.toRadixString(16).padLeft(
                          2, '0');
                      String order = '00010000${dataLength}71${nameLength}${nameInutf8}73${keyLength}${key}';
                      print(order);
                      await FlutterNfcKit.poll();
                      String re1 = await FlutterNfcKit.transceive(
                          '00A4040007A0000005272101');
                      print(re1);
                      if (re1 == '9000') {
                        String re2 = await FlutterNfcKit.transceive(order);
                        print(re2);
                        if (re2 == '9000') {
                          Navigator.pop(context);
                          _successDialog('Add Account Successfully.');
                        }
                      }
                      sleep(new Duration(seconds: 1));
                      await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
                    },
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        });
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
    print('radix2Result:$radix2result');
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

  String utf8Decode(String name) {
    List<int> decodeList = new List();
    for (int i = 0; i < name.length; i += 2) {
      decodeList.add(int.parse(name[i] + name[i + 1], radix: 16));
    }
    return utf8.decode(decodeList);
  }

  refresh() {
    AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Mention!',
        desc: 'Refreshing Credentials Now.Please Connecting To Canokey.',
        btnOkOnPress: () async {
          List<String> hotp = new List();
          List<Map> totp = new List();
          if (HomeRow.length != 0) HomeRow.removeRange(0, HomeRow.length);
          await FlutterNfcKit.poll();
          await FlutterNfcKit.transceive('00A4040007A0000005272101');
          print('Millisecond: ${DateTime
              .now()
              .millisecondsSinceEpoch}');
          int currentTime = (DateTime
              .now()
              .millisecondsSinceEpoch / 1000).round();
          String challenge = (currentTime / 30).floor()
              .toRadixString(16)
              .padLeft(16, '0');
          print('challenge: $challenge');
          String calculateALL = await FlutterNfcKit.transceive(
              '000500000A7408$challenge');
          while (RegExp(r"9000$").hasMatch(calculateALL) == false) {
            String moreData = await FlutterNfcKit.transceive('0006000000');
            calculateALL += moreData;
          }
          parseResponse(calculateALL, hotp, totp);
          print('hotp:$hotp');
          print('totp:$totp');
          if (hotp.length == 0 && totp.length == 0)
            _alertDialog();
          else {
            for (int i = 0; i < hotp.length; i++) {
              String strName = utf8Decode(hotp[i]);
              String utf8Name = hotp[i];
              HomeRow.add(leftScroll(
                  UniqueKey(), this.removeWidget, strName, utf8Name,
                  '* * * * * *', 'HOTP'));
            }
            for (int i = 0; i < totp.length; i++) {
              String strName = utf8Decode(totp[i]['totpName']);
              String utf8Name = totp[i]['totpName'];
              String calResult = calculateKey(totp[i]['totpKey']);
              HomeRow.add(leftScroll(
                  UniqueKey(), this.removeWidget, strName, utf8Name, calResult,
                  'TOTP'));
            }
            setState(() {
              HomeRow;
            });
            sleep(new Duration(seconds: 1));
            await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
          }
        }
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: <Widget>[
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _addDialog();
              });
            },
          ),
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.camera),
            onPressed: () async {
              scan();
            },
          ),
          FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.refresh),
              onPressed: () {
                refresh();
              })
        ],
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close,
      ),
      body: ListView(
        children: <Widget>[
          Column(children: HomeRow,)
        ],
      ),
    );
  }

  void removeWidget(Widget w) {
    HomeRow.remove(w);
    setState(() {});
  }
}
