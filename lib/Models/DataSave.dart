import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String filename) async {
  final path = await _localPath();

  return File(join(path, filename));
}

// ignore: missing_return
Future<File> writeToFile(String data, String filename) async {
  final file = await _localFile(filename);
  file.writeAsString(data);
}

// ignore: missing_return
Future<String> readFromFile(String filename) async {
  try{
    final file = await _localFile(filename);

    String data = file.readAsStringSync();
    return data;
  } catch(e) {
    print(e);
  }
}

class Settings{
  int currentLan;
  bool flag;
  static String filename = "settings";

  Settings({this.currentLan, this.flag});

  // ignore: non_constant_identifier_names
  void setCurrentLan(int Lan){
    currentLan = Lan;
  }

  void setFlag(bool _flag){
    flag = _flag;
  }

  Settings.fromJson(Map<String, dynamic> json)
        :currentLan = json["currentLan"],
          flag = json["flag"];

  Map<String, dynamic> toJson() => {
    "currentLan": currentLan,
    "flag": flag,
  };
}

class Data{
  String id;
  String standard;
  String name;
  String transceive;

  Data(this.id, this.standard, this.name, this.transceive);
  Data.fromJson(Map<String, dynamic> json)
        :id = json["id"],
        standard = json["standard"],
        name = json["name"],
        transceive = json["transceive"];

  Map<String, dynamic> toJson() => {
    "id": id,
    "standard": standard,
    "name": name,
    "transceive": transceive
  };
}

class DataBase{
  DataBase(this._database);

  List<Data> _database;

  List<Data> get database => _database;

  static String filename = "savedata";

  void addData(Data data){
    _database.add(data);
  }

  void removeDataById(String id){
    Data data = _database.firstWhere((element) => element.id == id);
    _database.remove(data);
  }

  int getIndexById(String id){
    Data data = _database.firstWhere((element) => element.id == id,orElse: (){return null;});
    if (data==null)return -1;
    else return _database.indexOf(data);
  }

  DataBase.loadFromJson(String jsonString){
    _database = List<Data>();
    List<dynamic>jsonData = json.decode(jsonString);
    for(dynamic data in jsonData){
      Data newData = Data.fromJson(data);
      _database.add(newData);
    }
  }

  String toJsonString(){
    return json.encode(database.map((data) => data.toJson()).toList());
  }
}


class Functions{
  static Future<Settings> loadSettings(String filename) async{
    String jsonString = await readFromFile(filename);
    Settings settings;
    try{
      settings = Settings.fromJson(json.decode(jsonString));
    } catch(e){
      print(e);
      settings = Settings(currentLan: 0, flag: false);
    }
    return settings;
  }

  static Future<void> writeSettings(String filename, Settings settings) async{
    await writeToFile(json.encode(settings.toJson()), filename);
  }

  static Future<DataBase> loadDataBase(String filename) async{
    String jsonString = await readFromFile(filename);
    DataBase database;
    try{
      database = DataBase.loadFromJson(jsonString);
    } catch(e){
      database = DataBase([]);
    }
    return database;
  }

  static Future<void> writeDataBase(String filename, DataBase database) async {
    await writeToFile(database.toJsonString(), filename);
  }
}
