import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Motto with ChangeNotifier {
  List<Motto> mottos = [];

  void addToList(Motto motto) => mottos.add(motto);
  void removeFromCart(Motto motto) {
    mottos.remove(motto);
    notifyListeners();
  }
}
