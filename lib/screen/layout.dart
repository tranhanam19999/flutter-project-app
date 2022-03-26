import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/couple-chat.dart';
import 'package:flutter_application_1/screen/couple-images.dart';
import 'package:flutter_application_1/screen/couple-memory.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.health_and_safety_rounded)),
                Tab(icon: Icon(Icons.image)),
                Tab(icon: Icon(Icons.chat)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              CoupleMemory(),
              CoupleImages(),
              CoupleChat(),
            ],
          ),
        ),
      ),
    );
  }
}
