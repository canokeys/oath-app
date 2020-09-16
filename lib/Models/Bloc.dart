import 'dart:async';
import 'package:canokey/Models/DataSave.dart';
import 'package:canokey/Models/MultiLanguage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tutorial_coach_mark/target_focus.dart';

enum Language { English, Chinese, Japanese, French, German }

class LanguageBloc {
  static List<TargetFocus> targets = List<TargetFocus>();
  static GlobalKey key1 = GlobalKey();
  static GlobalKey key2 = GlobalKey();
  static GlobalKey key3 = GlobalKey();
  static GlobalKey key4 = GlobalKey();

  final languagePackages = [English, Chinese, Japanese];
  final _languagePackageObject = BehaviorSubject<LanguagePackage>();
  Stream<LanguagePackage> get languageStream => _languagePackageObject.stream;

  // ignore: close_sinks
  final _switchSubject = StreamController<Language>();
  Sink<Language> get languageSink => _switchSubject.sink;

  LanguageBloc() {
    Functions.loadSettings(Settings.filename).then((value) =>
        _languagePackageObject.add(languagePackages[value.currentLan]));
    _switchSubject.stream.listen((Language language) {
      if (language == Language.Chinese) {
        _languagePackageObject.add(Chinese);
      } else if (language == Language.English) {
        _languagePackageObject.add(English);
      } else if (language == Language.Japanese) {
        _languagePackageObject.add(Japanese);
      } else if (language == Language.French) {
        _languagePackageObject.add(French);
      } else if (language == Language.German) {
        _languagePackageObject.add(German);
      }
    });
  }
}
