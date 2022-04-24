import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/model/motto-item.dart';
import 'package:flutter_application_1/screen/motto/list-motto.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:http/http.dart' as http;

class CoupleMotto extends StatefulWidget {
  const CoupleMotto({Key? key}) : super(key: key);

  @override
  _MyCoupleMottoScreenState createState() => _MyCoupleMottoScreenState();
}

class _MyCoupleMottoScreenState extends State<CoupleMotto> {
  late Future<List<MottoItem>> futureMotto;
  var client = new http.Client();

  @override
  void initState() {
    super.initState();
    futureMotto = fetchMottos();
  }

  Future<List<MottoItem>> fetchMottos() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;

    final url = Uri.parse(API_DOMAIN + "/motto/list" + "?creatorId=$userId");
    var getChatConversationResp = await client.get(url);

    if (getChatConversationResp.statusCode == 200) {
      var decodedBody = jsonDecode(getChatConversationResp.body);
      List<dynamic> list = decodedBody['data'];

      List<MottoItem> mottos = List<MottoItem>.from(
          list.map((model) => MottoItem.fromJson(model)).toList());

      return mottos;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
          Expanded(
            child: FutureBuilder<List<MottoItem>>(
              future: futureMotto,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                      height: 200.0,
                      child:
                          ListMotto(context, snapshot.data));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          )
        ])));
  }
}
