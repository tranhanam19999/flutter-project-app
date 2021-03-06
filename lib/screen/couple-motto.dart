import 'dart:async';
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
  TextEditingController _controller = new TextEditingController(text: "");

  late Future<List<MottoItem>> futureMotto;
  var client = new http.Client();

  @override
  void initState() {
    super.initState();
    futureMotto = fetchMottos();

    updateChatConversation();
  }

  void updateChatConversation() {
    const fiveSec = const Duration(seconds: 2);
    Timer.periodic(fiveSec, (Timer t) async {
      var fetchResult = fetchMottos();
      if (mounted) {
        setState(() {
          futureMotto = fetchResult;
        });
      }
    });
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

  void createMotto(context) async {
    // TODO: Create motto then close dialog
    Map<String, String> headers = {"Content-type": "application/json"};
    var obj = {
      'content': _controller.text,
      'creatorId': UserInfo.getInstance()?.userId
    };

    // t???o POST request
    var signUpResp = await client.post(API_DOMAIN + "/motto",
        headers: headers, body: jsonEncode(obj));

    int statusCode = signUpResp.statusCode;
    String body = signUpResp.body;

    if (signUpResp.statusCode == 200) {
      futureMotto = fetchMottos();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "T???o ch??m ng??n",
                        style: TextStyle(color: Colors.red),
                      ),
                      content: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              focusColor: Colors.red,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Nh???p ch??m ng??n',
                            ),
                            controller: _controller,
                          )),
                      actions: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Color(0xffff3a5a)),
                          child: FlatButton(
                              child: Text(
                                "T???o",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                              ),
                              onPressed: () => createMotto(context)),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "H???y",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  });
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.add_circle_outlined)),
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
                          child: ListMotto(context, snapshot.data));
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
