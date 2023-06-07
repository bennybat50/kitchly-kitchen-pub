
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';



class MediaPicker {
  List<Media> _listImagePaths = [];
  List<Media> _listVideoPaths = [];
  String dataImagePath = "";
  GalleryMode _galleryMode = GalleryMode.image;
  final _picker = ImagePicker();
  List<String> paths = [];
  List<Map> vDatas=[];
  Map vData = {};
  var path = '';
  Future<List<String>> selectImages({count, bool crop}) async {
    try {
      _galleryMode = GalleryMode.image;
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        selectCount: count,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: crop, height: 2, width: 2),
        compressSize: 20,
      );
      _listImagePaths.forEach((media) {
        paths.add(media.path.toString());
      });
    } catch (e) {
      print(e.toString());
    }

    return paths;
  }


Future<String> selectFromPickers()async{
  PickedFile image;
 try{
   image = await _picker.getImage(source: ImageSource.gallery);
 }catch(e){
   print(e.toString());
 }
 return image.path;
}

  Future<String> selectOneImage({bool crop}) async {
    try {
      _galleryMode = GalleryMode.image;
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        selectCount: 1,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: crop, height: 2, width: 2),
        compressSize: 20,
      );
      _listImagePaths.forEach((media) {
        path = media.path.toString();
      });
    } catch (e) {
      print(e.toString());
    }
    return path;
  }

    Future<List<Map>> selectVideos({count}) async {
    try {
      _galleryMode = GalleryMode.video;
      _listVideoPaths = await ImagePickers.pickerPaths(
          galleryMode: _galleryMode,
          selectCount: count,
          showCamera: true,
          compressSize: 20);
      _listVideoPaths.forEach((media) {
        vDatas.add({"videoPath":media.path,"thumbPath":media.thumbPath});
      });
    } catch (e) {
      print(e.toString());
    }

    return vDatas;
  }
  Future<Map> selectOneVideo() async {
    try {
      _galleryMode = GalleryMode.video;
      _listVideoPaths = await ImagePickers.pickerPaths(
          galleryMode: _galleryMode,
          selectCount: 1,
          showCamera: true,
          compressSize: 10);
      _listVideoPaths.forEach((media) {
        vData = {"videoPath":media.path,"thumbPath":media.thumbPath};
      });
    } catch (e) {
      print(e.toString());
    }
    return vData;
  }
  

  previewImage({path}) {
    ImagePickers.previewImage(path);
  }

  previewImages({List urls, int i}) {
    ImagePickers.previewImages(urls, i);
  }

  Future<String> useCamera({bool crop}) async {
    try {
      path = await ImagePickers.openCamera(
              compressSize: 20,
              cropConfig: CropConfig(enableCrop: crop, width: 2, height: 3))
          .then((Media media) {
        return media.path;
      });
    } catch (e) {
      print(e.toString());
    }
    return path;
  }

  Future<Map> takeVideo() async {
    
    try {
      vData = await ImagePickers.openCamera(
              cameraMimeType: CameraMimeType.video, compressSize: 20)
          .then((media) {
        vData['videoPath'] = media.path;
        vData['thumbPath'] = media.thumbPath;
        return vData;
      });
    } catch (e) {
      print(e.toString());
    }
    return vData;
  }
}
