import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:loading_animations/loading_animations.dart';
import 'StreamBuilder.dart';

successDialog(String info ,BuildContext context) {
  AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      padding: EdgeInsets.all(10),
      body: Column(
        children: <Widget>[
          Streambuilder('success',
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Streambuilder(info, TextStyle(fontSize: 16))
        ],
      ),
      btnOkOnPress: () {})
    ..show();
}

loading(BuildContext context){
  return AwesomeDialog(
    context: context,
    headerAnimationLoop: false,
    dialogType: DialogType.INFO,
    animType: AnimType.BOTTOMSLIDE,
    padding: EdgeInsets.all(10),
    body: Column(
      children: <Widget>[
        Streambuilder('dialog_attention',
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Streambuilder('connecting', TextStyle(fontSize: 16)),
        LoadingBouncingGrid.circle()
      ],
    ),
  );
}

failedDialog(String info , BuildContext context) {
  AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.ERROR,
      padding: EdgeInsets.all(10),
      animType: AnimType.BOTTOMSLIDE,
      body: Column(
        children: <Widget>[
          Streambuilder('warning',
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Streambuilder(info, TextStyle(fontSize: 16))
        ],
      ),
      btnOkOnPress: () {})
    ..show();
}

writeDialog(String order, BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.INFO,
    animType: AnimType.BOTTOMSLIDE,
    padding: EdgeInsets.all(10),
    body: Column(
      children: <Widget>[
        Streambuilder('dialog_attention',
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Streambuilder('connect', TextStyle(fontSize: 16))
      ],
    ),
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      var _loading = loading(context);
      _loading.show();
      try {
        await FlutterNfcKit.poll();
        String re1 =
        await FlutterNfcKit.transceive('00A4040007A0000005272101');
        if (re1 == '9000') {
          String re2 = await FlutterNfcKit.transceive(order);
          if (re2 == '9000') {
            _loading.dissmiss();
            successDialog('result_success',context);
          } else {
            _loading.dissmiss();
            failedDialog('result_Addfailed',context);
          }
        } else {
          _loading.dissmiss();
          failedDialog('result_Confailed',context);
        }
      } catch (e) {
        _loading.dissmiss();
        failedDialog('poll_timeout',context);
      }
    },
  )..show();
}

alertDialog(BuildContext context) {
  AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      padding: EdgeInsets.all(10),
      body: Column(
        children: <Widget>[
          Streambuilder('dialog_attention', TextStyle(fontSize: 24)),
          Streambuilder('credential_null', TextStyle(fontSize: 16))
        ],
      ),
      btnOkOnPress: () {})
    ..show();
}