import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat/list-view-chat.dart';
import 'package:flutter_application_1/screen/model/chat-conversation.dart';
import 'package:flutter_application_1/screen/model/conversation.dart';
import 'package:flutter_application_1/store/partner.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:http/http.dart' as http;

import '../utils/const.dart';

class CoupleChat extends StatefulWidget {
  const CoupleChat({Key? key}) : super(key: key);

  @override
  _MyCoupleChatScreenState createState() => _MyCoupleChatScreenState();
}

class _MyCoupleChatScreenState extends State<CoupleChat> {
  late Future<List<ChatConversation>> futureChatConversation;
  TextEditingController _controller = new TextEditingController(text: "");

  String _textContent = "";
  var client = new http.Client();

  @override
  void initState() {
    super.initState();
    findPartner();

    futureChatConversation = fetchChatConversation();
    updateChatConversation();
  }

  void updateChatConversation() {
    const fiveSec = const Duration(seconds: 2);
    Timer.periodic(fiveSec, (Timer t) async {
      var fetchResult = fetchChatConversation();

      setState(() {
        futureChatConversation = fetchResult;
      });
    });
  }

  Future<List<ChatConversation>> fetchChatConversation() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;

    final url = Uri.parse(API_CHAT + "?userId=$userId");
    var getChatConversationResp = await client.get(url);

    if (getChatConversationResp.statusCode == 200) {
      var decodedBody = jsonDecode(getChatConversationResp.body);
      List<dynamic> list = decodedBody['data'];

      List<ChatConversation> chats = List<ChatConversation>.from(
          list.map((model) => ChatConversation.fromJson(model)).toList());

      return chats;
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
    String body = getPartnerResp.body;

    var loggedUser = jsonDecode(body);

    var partnerUserId = loggedUser['data']['userId'];
    var partnerUsername = loggedUser['data']['username'];
    var partnerFullname = loggedUser['data']['fullname'];

    PartnerInfo.getInstance(
        username: partnerUsername,
        password: "",
        userId: partnerUserId,
        token: "",
        fullname: partnerFullname);
  }

  void _handleOnChangeTextContent(text) {
    _textContent = text.toString();
  }

  void _sendMessage(BuildContext context) async {
    String url = API_CHAT;
    Map<String, String> headers = {"Content-type": "application/json"};
    var obj = {
      'senderId': UserInfo.getInstance()?.userId,
      'receiverId': PartnerInfo.getInstance()?.userId,
      'content': _textContent
    };

    await client.post(url, headers: headers, body: jsonEncode(obj));

    var fetchResult = fetchChatConversation();
    setState(() {
      _textContent = "";
      futureChatConversation = fetchResult;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List<ChatConversation>>(
                  future: futureChatConversation,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var user = UserInfo.getInstance();
                      var userId = user?.userId;

                      return SizedBox(
                          height: 200.0,
                          child: ListViewChat(context, snapshot.data!.reversed.toList(), userId));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Nhập nội dung',
                    suffixIcon: IconButton(
                        onPressed: () => _sendMessage(context),
                        icon: const Icon(Icons.message)),
                  ),
                  onChanged: (text) => _handleOnChangeTextContent(text),
                ),
              ),
            ]),
      ),
    );
  }
}
