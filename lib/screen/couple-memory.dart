import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    findPartner();
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

  @override
  Widget build(BuildContext context) {
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
