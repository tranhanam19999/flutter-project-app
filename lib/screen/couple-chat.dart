import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat/list-view-chat.dart';

class CoupleChat extends StatelessWidget {
  const CoupleChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SizedBox(height: 200.0, child: ListViewChat(context)),
              ),
            ]),
      ),
    );
  }
}
