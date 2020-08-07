import 'package:flutter/material.dart';
import '../Models/KeysModule.dart';

// ignore: must_be_immutable
class PersonalContent extends StatefulWidget {
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