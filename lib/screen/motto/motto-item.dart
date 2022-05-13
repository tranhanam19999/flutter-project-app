import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MottoSingle(BuildContext context, String content) {
  final screenWidth = MediaQuery.of(context).size.width - 48;
  final Color color1 = Color(0xffFC5CF0);
  final Color color2 = Color(0xffFE8852);

  return (Card(
      child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(children: <Widget>[
      Container(
          width: screenWidth,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color1, color2],
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                    child: Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          content,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                 ),
                  // width: 300,
                  constraints: BoxConstraints(maxWidth: 300),
                )
              ],
            ),
          ))
    ]),
  )));
  // return ();
}
