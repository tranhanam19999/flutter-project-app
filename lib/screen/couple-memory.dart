import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_application_1/screen/couple-chat.dart';
import 'package:flutter_application_1/screen/layout.dart';
import 'package:flutter_application_1/store/partner.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_application_1/screen/create-event.dart';
import 'package:flutter_application_1/screen/create-event.dart';
import '../utils/const.dart';

class CoupleMemory extends StatefulWidget {
  const CoupleMemory({Key? key}) : super(key: key);

  @override
  _MyCoupleMemoryScreenState createState() => _MyCoupleMemoryScreenState();
}

class _MyCoupleMemoryScreenState extends State<CoupleMemory> {
  static final String path = "lib/screen/couple-memory.dart";
  final Color primaryColor = Color(0xffFD6592);
  final Color bgColor = Color(0xffF9E0E3);
  final Color secondaryColor = Color(0xff324558);
  final Color color1 = Color(0xffFC5CF0);
  final Color color2 = Color(0xffFE8852);
  final String image =
      "https://www.vivosmartphone.vn/uploads/MANGOADS/c%E1%BA%B7p%20%C4%91%C3%B4i/cho%20couple/1.jpg";
  var client = new http.Client();
  PartnerInfo? partner = PartnerInfo.getInstance();
  String selectedUsername = "Chưa có";
  late Future<List<String>> usernames;
  var partnerId = PartnerInfo.getInstance()?.userId;
  var daysInLove = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    usernames = getAllUsers();
    findPartner();
    getAllEvent();
  }

  Future<List<String>> getAllUsers() async {
    final url = Uri.parse(API_DOMAIN + "/user/user-without-partner");
    var getAllUsersResp = await client.get(url);

    if (getAllUsersResp.statusCode == 200) {
      var decodedBody = jsonDecode(getAllUsersResp.body);
      List<dynamic> list = decodedBody['data'];

      List<String> tempUsernames =
          List<String>.from(list.map((model) => model['username']));

      tempUsernames.add("Chưa có");
      return tempUsernames;
    } else {
      throw Exception('Failed to load album');
    }
  }

  void findPartner() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;
    final url = Uri.parse(API_PARTNER + "?userId=$userId");

    Map<String, String> headers = {"Content-type": "application/json"};

    var getPartnerResp = await client.get(url, headers: headers);
    var loggedUser = jsonDecode(getPartnerResp.body);

    var data = loggedUser['data'];

    var matchTime = data['matchTime'];
    DateTime date1 = DateTime.parse(matchTime);
    DateTime date2 = DateTime.now();

    var partnerUserId = data['userId'];
    var partnerUsername = data['username'];
    var partnerFullname = data['fullname'];

    PartnerInfo.getInstance(
        username: partnerUsername,
        password: "",
        userId: partnerUserId,
        token: "");

    setState(() {
      daysInLove = daysBetween(date1, date2);
      partner!.userId = partnerUserId;
    });
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void validateSelectedPartner(context) async {
    final scaffold = ScaffoldMessenger.of(context);

    var user = UserInfo.getInstance();
    var userId = user?.userId;

    final url = Uri.parse(API_DOMAIN +
        "/user/verify-partner" +
        "?userId=$userId&partnerUsername=$selectedUsername");

    Map<String, String> headers = {"Content-type": "application/json"};

    var getPartnerResp = await client.put(url, headers: headers);
    String body = getPartnerResp.body;

    var loggedUser = jsonDecode(body);

    if (getPartnerResp.statusCode == 200) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text("Kết nối thành công"),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );

      DefaultTabController.of(context)?.animateTo(2);
    }
  }

  late List _events;
  getAllEvent() async {
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
        _events = data['events'];
      });
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
  Future<void> _openGallary() async {
    files.clear();
    List<Asset> assets = await selectImagesFromGallery();
    for (Asset asset in assets) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }
    setState(() {});
  }

  _createEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateEvent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (partner?.userId == "" || partner?.userId == null) {
      return Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AlertDialog(
            title: Text("Chọn bạn"),
            content: FutureBuilder<List<String>>(
              future: usernames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var user = UserInfo.getInstance();
                  var userId = user?.userId;

                  return Expanded(
                      child: DropdownButton<String>(
                    value: selectedUsername,
                    items: snapshot.data?.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedUsername = value!;
                      });
                    },
                  ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (selectedUsername != "Chưa có") {
                    validateSelectedPartner(context);
                  }
                },
                child: Text("Xác nhận"),
              ),
            ],
          ),
        ],
      )));
    }
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Theme(
        data: ThemeData(
          primaryColor: primaryColor,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: TextTheme(
              headline6: TextStyle(
                color: secondaryColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: secondaryColor),
            actionsIconTheme: IconThemeData(
              color: secondaryColor,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).buttonColor,
          appBar: AppBar(
            title: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              indicatorColor: primaryColor,
              unselectedLabelColor: secondaryColor,
              onTap: (index) {
                if (index == 1) {
                  setState(() async {
                    await getAllEvent();
                  });
                }
              },
              tabs: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Been together",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Event in love",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: <Widget>[_Tab2(), _Tab1()],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleItem(int index) {
    Map event = _events[index];
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            width: 90,
            height: 90,
            color: bgColor,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  color: Colors.blue,
                  width: 80.0,
                  child: PNetworkImage(
                    event['image'],
                    height: 120,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        event['name'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: primaryColor,
                              ),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 5.0),
                            ),
                            TextSpan(
                                text: event['user_created'],
                                style: TextStyle(fontSize: 16.0)),
                            const WidgetSpan(
                              child: SizedBox(width: 20.0),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 5.0),
                            ),
                            TextSpan(
                              text: event["date"],
                            ),
                          ],
                        ),
                        style: const TextStyle(height: 2.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _Tab1() {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return _buildArticleItem(index);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      ),
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.add), onPressed: _createEvent),
    );
  }

  Widget _Tab2() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [color1, color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                const Text(
                  "Been together",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 10.0),
                          child: GestureDetector(
                            onTap: _openGallary,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: files.isEmpty
                                  ? PNetworkImage(
                                      image,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      files[0],
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text(
                            daysInLove.toString() + " days",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                const Text(
                  "Minh Tiền - Mai Thương",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "\"Life is great when we have each other\"",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 16.0),
                        margin: const EdgeInsets.only(
                            top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color1, color2],
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              color: Colors.white,
                              icon: Icon(FontAwesomeIcons.user),
                              onPressed: () {},
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.location_on),
                              onPressed: () {},
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.message),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 30,
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
