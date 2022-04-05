import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat/list-view-chat.dart';
import 'package:flutter_application_1/screen/model/chat-conversation.dart';
import 'package:flutter_application_1/store/partner.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:http/http.dart' as http;

class CoupleChat extends StatefulWidget {
  const CoupleChat({Key? key}) : super(key: key);

  @override
  _MyCoupleChatScreenState createState() => _MyCoupleChatScreenState();
}

class _MyCoupleChatScreenState extends State<CoupleChat> {
  late Future<ChatConversation> futureChatConversation;

  String _textContent = "";
  var client = new http.Client();

  @override
  void initState() {
    super.initState();
    findPartner();
    futureChatConversation = fetchChatConversation();
  }

  Future<ChatConversation> fetchChatConversation() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;

    final url = Uri.parse("http://localhost:5000/chat" + "?senderId=$userId");

    Map<String, String> headers = {"Content-type": "application/json"};

    var getChatConversationResp = await client.get(url, headers: headers);
    ;

    if (getChatConversationResp.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ChatConversation.fromJson(
          jsonDecode(getChatConversationResp.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void findPartner() async {
    var user = UserInfo.getInstance();
    var userId = user?.userId;
    final url =
        Uri.parse("http://localhost:5000/user/partner" + "?userId=$userId");

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

  void _handleOnCHangeTextContent(text) {
    _textContent = text.toString();
  }

  void _sendMessage() async {
    String url = 'http://localhost:5000/chat';
    Map<String, String> headers = {"Content-type": "application/json"};
    var obj = {
      'sender': UserInfo.getInstance()?.userId,
      'receiver': PartnerInfo.getInstance()?.userId,
      'content': _textContent
    };

    var sendMessageResp =
        await client.post(url, headers: headers, body: jsonEncode(obj));

    String body = sendMessageResp.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<ChatConversation>(
                  future: futureChatConversation,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: 200.0,
                          child: ListViewChat(context, snapshot.data));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                // child: SizedBox(height: 200.0, child: ListViewChat(context)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Nhập nội dung',
                    suffixIcon: IconButton(
                        onPressed: () => _sendMessage(),
                        icon: const Icon(Icons.message)),
                  ),
                  onChanged: (text) => _handleOnCHangeTextContent(text),
                ),
              ),
            ]),
      ),
    );
  }
}
