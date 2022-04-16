import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat/chat-item.dart';
import 'package:flutter_application_1/screen/model/chat-conversation.dart';

Widget ListViewChat(BuildContext context,
    List<ChatConversation>? chatConversations, String? userId) {
  Widget sender = Container(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Nam',
            style: TextStyle(fontSize: 16),
          ),
          Text('1111'),
        ],
      ),
    ),
    width: 80,
    color: Colors.red,
  );

  Widget receiver = Container(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lam',
            style: TextStyle(fontSize: 16),
          ),
          Text('222'),
        ],
      ),
    ),
    width: 80,
    color: Colors.blue,
  );

  return ListView.builder(
    shrinkWrap: true,
    itemCount: chatConversations?.length,
    itemBuilder: (context, index) {
      final screenWidth = MediaQuery.of(context).size.width - 48;

      if (chatConversations![index].senderId == userId) {
        return ChatItem(context, true, chatConversations[index].content);
      }

      return ChatItem(context, false, chatConversations[index].content);
    },
  );
}
