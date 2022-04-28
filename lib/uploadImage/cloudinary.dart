import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter/foundation.dart';

class CloudImage with ChangeNotifier {
  dynamic _response;
  late List<String> _urlList;
  bool _isloading = true;
  dynamic get urlList => _urlList;
  String get response => _response;
  bool get isloading => _isloading;
  Future<void> upload(List<String> imagesList) async {
    CloudinaryClient client = new CloudinaryClient(
      "332425848898674",
      "TlbFs2cpNa6QdnLN2kJH-kVMUlc",
      "fresh-shop",
    );
    List<CloudinaryResponse> response = await client.uploadImages(imagesList,
        filename: "image_", folder: "Flutter");
    _response = response;
    notifyListeners();
    if (_response == null) {
      return null;
    } else {
      List<String> urlList = [];
      _response.forEach((element) {
        urlList.add(element.secure_url);
      });
      _urlList = urlList;
      _isloading = false;
      notifyListeners();
    }
  }
}
