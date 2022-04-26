import 'package:flutter/material.dart';

Widget ListViewImages(BuildContext context) {
  AssetImage pizzaAsset = AssetImage('images/couple.png');
  Widget column = Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
          ),
          child: Image(
            image: pizzaAsset,
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );

  return ListView.builder(
    shrinkWrap: true,
    itemCount: 8,
    itemBuilder: (context, index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              column,
              column,
            ],
          ),
        ),
      );
    },
  );
}
