import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadFile {
  File file;
  var path;
  Future downloadImage({url, filename}) async{
    path=await http.readBytes(url).then((buffer) async {
      String dir = (await getApplicationDocumentsDirectory()).path;
      file = File("$dir/$filename" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg");
      RandomAccessFile rf = file.openSync(mode: FileMode.write);
      rf.writeFromSync(buffer);
      rf.flushSync();
      rf.closeSync();
      return file.path;
    }).catchError((error) {
      print("DOWNLOAD ERROR${error.toString()}");
      return null;
    });
    return path;
  }

  Future downloadVideo({url, filename}) async{
    path=await http.readBytes(url).then((buffer) async {
      String dir = (await getApplicationDocumentsDirectory()).path;
      file = File("$dir/$filename" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".mp4");
      RandomAccessFile rf = file.openSync(mode: FileMode.write);
      rf.writeFromSync(buffer);
      rf.flushSync();
      rf.closeSync();
      return file.path;
    }).catchError((error) {
      print("DOWNLOAD ERROR${error.toString()}");
      return null;
    });
    return path;
  }

  Future<String> saveFile(String fileName,File imageFile)async{
    try{
      final directory = await getApplicationDocumentsDirectory();
      final myImagePath = '${directory.path}';
      DateTime dateNow = DateTime.now();
      file=await imageFile.copy("$myImagePath/$fileName${dateNow.millisecondsSinceEpoch}.jpg");
      return file.path;
    }catch(e){
      return null;
    }
  }
}
