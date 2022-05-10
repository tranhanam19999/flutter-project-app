import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_application_1/screen/couple-memory.dart';
import 'package:flutter_application_1/screen/layout.dart';
import 'package:flutter_application_1/uploadImage/cloudinary.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../store/user.dart';
import '../uploadImage/images_picker.dart';
import 'package:flutter_application_1/uploadImage/cloudinary.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);
  @override
  State<CreateEvent> createState() => _CreateEvent();
}

class Tech {
  String label;
  Color color;
  Tech(this.label, this.color);
}

class _CreateEvent extends State<CreateEvent> {
  int selectedIndex = 0;
  final _controller = TextEditingController();
  String name = "";
  String date = DateFormat('MM/dd/yyyy').format(DateTime.now());
  String image = "";
  String description = "";
  String motion = "";
  final List<Tech> _chipsList = [
    Tech("Vui", Colors.green),
    Tech("Hạnh phúc", Colors.blueAccent),
    Tech("Buồn", Color.fromARGB(255, 220, 64, 64)),
    Tech("Thất vọng", Color.fromARGB(255, 87, 13, 26)),
  ];

  @override
  void initState() {
    super.initState();
    getAllEvent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleOnChangeName(text) {
    name = text.toString();
  }

  void _handleOnChangeDate(text) {
    date = DateFormat('yyyy-MM-dd').format(text);
  }

  void _handleOnChangeDescription(text) {
    description = text.toString();
  }

  dynamic _response;
  late List<String> _urlList;

  Future<void> upload(List<String> imagesList) async {
    CloudinaryClient client = new CloudinaryClient(
      "332425848898674",
      "TlbFs2cpNa6QdnLN2kJH-kVMUlc",
      "fresh-shop",
    );
    List<CloudinaryResponse> response = await client.uploadImages(imagesList,
        filename: "image_", folder: "Flutter");
    _response = response;
    if (_response == null) {
      return;
    } else {
      List<String> urlList = [];
      _response.forEach((element) {
        urlList.add(element.secure_url);
      });
      _urlList = urlList;
      image = _urlList[0];
    }
  }

  Future<List<Asset>> selectImagesFromGallery() async {
    return await MultiImagePicker.pickImages(
      maxImages: 1,
      enableCamera: true,
      materialOptions: const MaterialOptions(
        actionBarColor: "#FF147cfa",
        statusBarColor: "#FF147cfa",
      ),
    );
  }

  List<File> files = [];
  late List<File> _files;
  late List<String> _list;
  Future<void> _openGallary() async {
    files.clear();
    List<Asset> assets = await selectImagesFromGallery();
    for (Asset asset in assets) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }
    setState(() {});
    List<String> data = [];
    _files = files;
    if (files == null) {
      return;
    } else {
      files.forEach((element) {
        data.add(element.path);
      });
    }
    _list = data;
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: files.isEmpty
                        ? Image.network(
                            "https://dep.com.vn/wp-content/themes/dep/assets/img/no_image.jpg",
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            files[0],
                            fit: BoxFit.cover,
                          ),
                  ),
                  Align(
                    alignment: Alignment(0, 1),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0.5,
                      color: Colors.white,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.pink,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: _openGallary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Event name",
                      errorText: _errorText,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    onChanged: (text) {
                      setState(() {});
                      return _handleOnChangeName(text);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  InputDatePickerFormField(
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: DateTime(DateTime.now().year + 5),
                    initialDate: DateTime.now(),
                    fieldLabelText: "Date of event",
                    onDateSubmitted: (text) => _handleOnChangeDate(text),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Description",
                      errorText: _errorText,
                    ),
                    onChanged: (text) => _handleOnChangeDescription(text),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Emotion",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 15.0),
                  Wrap(
                      spacing: 6,
                      direction: Axis.horizontal,
                      children: techChips()),
                  const SizedBox(height: 30.0),
                  MaterialButton(
                    child: Text("Create"),
                    color: Colors.pink,
                    onPressed:
                        _controller.value.text.isNotEmpty ? _submit : null,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    EasyLoading.showProgress(0, status: 'Waitting...');
    // if there is no error text
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      print('error');
    }
    var user = UserInfo.getInstance();
    var username = user?.username;
    await upload(_list);
    await updateEvent(
        name, date, image, description, selectedIndex.toString(), username);

    EasyLoading.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Layout()),
    );
  }

  Future<void> updateEvent(
      name, date, image, description, motion, user_created) async {
    final url = Uri.parse(API_EVENT + "/$_eventID");
    Map<String, String> headers = {"Content-type": "application/json"};
    var updateMemory = await client.patch(url,
        headers: headers,
        body: json.encode({
          "name": name,
          "date": date,
          "image": image,
          "description": description,
          "motion": motion,
          "user_created": user_created
        }));
    EasyLoading.dismiss();
    var data = jsonDecode(updateMemory.body);
    print(data);
  }

  var client = new http.Client();
  String? _eventID;
  void getAllEvent() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;
    final url = Uri.parse(API_EVENT + "/$userId");
    Map<String, String> headers = {"Content-type": "application/json"};

    EasyLoading.showProgress(0, status: 'Waitting...');
    var getMemory = await client.get(url, headers: headers);
    EasyLoading.dismiss();
    var data = jsonDecode(getMemory.body);
    // var images = data['images'];
    if (mounted) {
      setState(() {
        _eventID = data['_id'];
      });
    }
  }

  List<Widget> techChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(_chipsList[i].label),
          labelStyle: TextStyle(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 153, 149, 149),
          selectedColor: _chipsList[i].color,
          selected: selectedIndex == i,
          elevation: 10,
          labelPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
          onSelected: (bool value) {
            setState(() {
              selectedIndex = i;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
