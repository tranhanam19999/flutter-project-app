import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ChatItem(BuildContext context, bool isCurrentUser, String content) {
  final screenWidth = MediaQuery.of(context).size.width - 48;

  return (Card(
      child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(children: <Widget>[
      Container(
          width: screenWidth,
          child: Container(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                    child: Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          content,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  width: 80,
                  color: Colors.red,
                )
              ],
            ),
          ))
    ]),
  )));
  // return ();
}
