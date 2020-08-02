import 'package:canaokey/MainPages/Home.dart';
import 'package:flutter/material.dart';
import '../Models/KeysModule.dart';

class PersonalContent extends StatefulWidget {
  static String _credentialInfo;
  void credentialInfoSet(String value){
    _credentialInfo=value;
  }
  KeysModule passWordsModule= KeysModule(UniqueKey(), 'Person');
  @override
  _PersonalContentState createState() => _PersonalContentState();
}

class _PersonalContentState extends State<PersonalContent> {

  @override
  Widget build(BuildContext context) {

    return widget.passWordsModule;
  }
}