import 'dart:async';
import 'dart:io';


class FileWriter{

  Future<File> get _localFile async {
    return File('/Users/samantharain/Desktop/SchoolProjects/RoomSliceAppClient/Roomslice/lib/Token.txt');
  }


 Future<File> writeToken(String token) async {
    final file = await _localFile;

  // Write the file.
    return file.writeAsString('$token');
  }


  Future<String> readToken() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();
      // print("Contents:");
      // print(contents);
      return contents;
    } 
    catch (e) {
      // If encountering an error, return 0.
      return "0";
    }
  }



  //Needs to be fixed
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

      // Read the file.
      String contents = await file.readAsString();
      
      return contents[57];
  }

    catch (e) {
      // If encountering an error, return 0.
      return "0";
    }
}
}