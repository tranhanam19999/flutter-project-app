import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/partner.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:http/http.dart' as http;

import '../utils/const.dart';

class CoupleMemory extends StatefulWidget {
  const CoupleMemory({Key? key}) : super(key: key);

  @override
  _MyCoupleMemoryScreenState createState() => _MyCoupleMemoryScreenState();
}

class _MyCoupleMemoryScreenState extends State<CoupleMemory> {
  var client = new http.Client();
  String selectedUsername = "Chưa có";
  late Future<List<String>> usernames;
  var partnerId = PartnerInfo.getInstance()?.userId;

  @override
  void initState() {
    super.initState();

    usernames = getAllUsers();
    findPartner();
  }

  Future<List<String>> getAllUsers() async {
    final url = Uri.parse(API_DOMAIN + "/user/list");
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

    var partnerUserId = data['userId'];
    var partnerUsername = data['username'];
    var partnerFullname = data['fullname'];

    PartnerInfo.getInstance(
        username: partnerUsername,
        password: "",
        userId: partnerUserId,
        token: "");
  }


  void validateSelectedPartner(context) async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;

    final url = Uri.parse(API_DOMAIN + "/user/verify-partner" + "?userId=$userId&?partnerUsername=$selectedUsername");

    Map<String, String> headers = {"Content-type": "application/json"};

    var getPartnerResp = await client.get(url, headers: headers);
    String body = getPartnerResp.body;

    var loggedUser = jsonDecode(body);

    if (getPartnerResp.statusCode == 200) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (PartnerInfo.getInstance()?.userId == "" ||
        PartnerInfo.getInstance()?.userId == null) {
      return Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AlertDialog(
            title: Text("Alert Dialog Box"),
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
                child: Text("okay"),
              ),
            ],
          ),
        ],
      )));
    }

    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                  child: Text(
                    'Đã ở bên nhau được 100 ngày',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              // AlertDialog(
              //   title: Text("Success"),
              //   actions: [
              //     CupertinoDialogAction(onPressed: () {}, child: Text("Back")),
              //     CupertinoDialogAction(onPressed: () {}, child: Text("Next")),
              //   ],
              //   content: Text("Saved successfully"),
              // ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              'images/bear.png',
                              width: 600.0,
                              height: 240.0,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            'images/bear.png',
                            width: 600.0,
                            height: 240.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                    child: Text(
                      'Cảm ơn gì gì đó, chúc kỷ niệm,...',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ])
            ]),
      ),
    );
  }
}
