import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class FileWriter{

  Future<String> get _localPath async {

    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
    
  }


  Future<File> get _localFile async {

    final path = await _localPath;
    return File('$path/Token.txt');

  }

  void removeFile() async{

    final file = await _localFile;
    file.delete();

  }

 Future<File> writeToken(String token) async {

    final file = await _localFile;
    return file.writeAsString('$token');

  }


  Future<String> readToken() async {

    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } 

    catch (e) {
      return "ERROR IN FILE HANDLING";
    }

  }



  String getID() {
    String val;
    readToken().then((value){
      print(value);
      if(value[57] != null) {
        print("VALUE " + value[57]);
        val = value;
        return val;
      }
      else {
        return val;
      }
    });
    return val;
  }

  Future<String> getID1() async {
    
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents[57];
    }

    catch (e) {
      return "0";
    }

  }

}