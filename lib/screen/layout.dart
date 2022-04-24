import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/couple-chat.dart';
import 'package:flutter_application_1/screen/couple-images.dart';
import 'package:flutter_application_1/screen/couple-memory.dart';
import 'package:flutter_application_1/screen/couple-motto.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.health_and_safety_rounded)),
                Tab(icon: Icon(Icons.image)),
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.format_list_bulleted))
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              CoupleMemory(),
              CoupleImages(),
              CoupleChat(),
              // Châm ngôn
              CoupleMotto()
            ],
          ),
        ),
      ),
    );
  }
}
