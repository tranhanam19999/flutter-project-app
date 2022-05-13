import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/couple-chat.dart';
import 'package:flutter_application_1/screen/couple-images.dart';
import 'package:flutter_application_1/screen/couple-memory.dart';
import 'package:flutter_application_1/screen/couple-motto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { red, green, blue }

const Map<TabItem, String> tabName = {
  TabItem.red: 'red',
  TabItem.green: 'green',
  TabItem.blue: 'blue',
};

const Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.red: Colors.red,
  TabItem.green: Colors.green,
  TabItem.blue: Colors.blue,
};

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedIndex = 0;
  void _selectTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Color.fromARGB(179, 255, 250, 250),
        onTap: (int index) {
          _selectTab(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.image),
            label: "Images",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Moto",
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return CoupleMemory();
    } else if (selectedIndex == 1) {
      return const CoupleImages();
    } else if (selectedIndex == 2) {
      return const CoupleChat();
    } else {
      return const CoupleMotto();
    }
  }
}
