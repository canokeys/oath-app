import 'dart:async';

import 'package:canaokey/Models/DataSave.dart';
import 'package:canaokey/Models/MultiLanguage.dart';
import 'package:rxdart/rxdart.dart';

enum Language{
  English,
  Chinese,
  Japanese
}


class LanguageBloc{
  final languagePackages = [English, Chinese, Japanese];
  final _languagePackageObject = BehaviorSubject<LanguagePackage>();
  Stream<LanguagePackage> get languageStream => _languagePackageObject.stream;

  final _switchSubject = StreamController<Language>();
  Sink<Language> get languageSink => _switchSubject.sink;

  LanguageBloc(){
    Functions.loadSettings(Settings.filename).then((value) => _languagePackageObject.add(languagePackages[value.currentLan]));
    _switchSubject.stream.listen((Language language) {
      if(language == Language.Chinese){
        _languagePackageObject.add(Chinese);
      }
      else if(language == Language.English){
        _languagePackageObject.add(English);
      }
      else if(language==Language.Japanese){
        _languagePackageObject.add(Japanese);
      }
    });
  }
}