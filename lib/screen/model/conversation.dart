import 'package:flutter_application_1/screen/model/chat-conversation.dart';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chat with ChangeNotifier {
  List<ChatConversation> chats = [];

  void addToCart(ChatConversation chat) => chats.add(chat);
  void removeFromCart(ChatConversation chat) {
    chats.remove(chat);
    notifyListeners();
  }
}
