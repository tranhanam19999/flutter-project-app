import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FetchImage with ChangeNotifier {
  late List<File> _files;
  late List<String> _list;

  List<File> get files => _files;
  List<String> get list => _list;
  Future<void> init() async {
    /// uri can be of android scheme content or file
    /// for iOS PHAsset identifier is supported as well
    List<Asset> assets = await selectImagesFromGallery();
    List<File> files = [];
    for (Asset asset in assets) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }
    List<String> data = [];

    _files = files;
    notifyListeners();
    if (files == null) {
      return null;
    } else {
      files.forEach((element) {
        data.add(element.path);
      });
    }
    _list = data;
    notifyListeners();
  }

  Future<List<Asset>> selectImagesFromGallery() async {
    return await MultiImagePicker.pickImages(
      maxImages: 65536,
      enableCamera: true,
      materialOptions: MaterialOptions(
        actionBarColor: "#FF147cfa",
        statusBarColor: "#FF147cfa",
      ),
    );
  }
}
