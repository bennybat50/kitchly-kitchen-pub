import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
class CompressImage{

  Future<File> compressAndGetFile({File file,name,extention}) async {
    print("testCompressAndGetFile");
    var dir = await path_provider.getTemporaryDirectory();
    DateTime now = DateTime.now();
    var targetPath = dir.absolute.path + "/$name${now.millisecondsSinceEpoch}$extention";
    var imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );
    print(imageFile.lengthSync());
    return imageFile;
  }

}