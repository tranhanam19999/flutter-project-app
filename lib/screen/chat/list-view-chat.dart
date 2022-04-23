import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat/chat-item.dart';
import 'package:flutter_application_1/screen/model/chat-conversation.dart';

Widget ListViewChat(BuildContext context,
    List<ChatConversation>? chatConversations, String? userId) {
  final ScrollController _scrollController = ScrollController();

  if (_scrollController.hasClients) {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  return ListView.builder( reverse: true,
    controller: _scrollController,
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
