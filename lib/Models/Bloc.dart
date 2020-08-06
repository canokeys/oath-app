import 'dart:async';

import 'package:canaokey/Models/MultiLanguage.dart';
import 'package:rxdart/rxdart.dart';

enum Language{
  English,
  Chinese,
  Japanese
}


class LanguageBloc{
  final _languagePackageObject = BehaviorSubject<LanguagePackage>();
  Stream<LanguagePackage> get languageStream => _languagePackageObject.stream;

  final _switchSubject = StreamController<Language>();
  Sink<Language> get languageSink => _switchSubject.sink;

  LanguageBloc(){
    _languagePackageObject.add(English);
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