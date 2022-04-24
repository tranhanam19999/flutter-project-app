import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MottoSingle(BuildContext context, String content) {
  final screenWidth = MediaQuery.of(context).size.width - 48;

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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                    child: Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          content,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),
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
