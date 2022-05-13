import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/store/user.dart';
import '../store/partner.dart';
import '../utils/const.dart';
import 'cloudinary.dart';
import 'images_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _quantity = 0;
  List _images = [];
  String _memoryID = "";
  var client = new http.Client();
  @override
  void initState() {
    super.initState();
    createMemory();
    getMemory();
  }

  void createMemory() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;
    var partner = PartnerInfo.getInstance();
    var partnerId = partner?.userId;

    final url = Uri.parse(API_MEMORY + "/create-memory");
    Map<String, String> headers = {"Content-type": "application/json"};
    var createMemory = await client.post(url,
        headers: headers,
        body: json.encode(
            {"user_id": userId, "partner_id": partnerId, "images": []}));
  }

  void getMemory() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;
    final url = Uri.parse(API_MEMORY + "/$userId");
    Map<String, String> headers = {"Content-type": "application/json"};

    EasyLoading.showProgress(0, status: 'Waitting...');
    var getMemory = await client.get(url, headers: headers);
    EasyLoading.dismiss();
    var data = jsonDecode(getMemory.body);
    // var images = data['images'];
    if (mounted) {
      setState(() {
        _memoryID = data['_id'];
        _quantity = data['images'].length;
        _images = data['images'];
      });
    }
  }

  void updateMemory() async {
    final url = Uri.parse(API_MEMORY + "/$_memoryID");
    Map<String, String> headers = {"Content-type": "application/json"};
    var updateMemory = await client.patch(url,
        headers: headers, body: json.encode({"images": _images}));
    EasyLoading.dismiss();
    var data = jsonDecode(updateMemory.body);
  }

  @override
  Widget build(BuildContext context) {
    final _files = Provider.of<FetchImage>(context);
    final _response = Provider.of<CloudImage>(context);
    return Scaffold(
        body: _quantity == 0
            ? const Center(child: Text("Click to pick images"))
            : Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 12),
                child: GridView.builder(
                    itemCount: _quantity,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    })),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
            child: Icon(Icons.image),
            onPressed: () async {
              EasyLoading.showProgress(0, status: 'Waitting...');
              await _files.init();
              await _response.upload(_files.list);
              setState(() {
                _images.addAll(_response.urlList);
                _quantity = _images.length;
                updateMemory();
              });
            }));
  }
}
