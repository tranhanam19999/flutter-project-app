import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cloudinary.dart';
import 'images_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    final _files = Provider.of<FetchImage>(context);
    final _response = Provider.of<CloudImage>(context);
    return Scaffold(
        body: _response.isloading
            ? Center(child: Text("Click to pick images"))
            : Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 12),
                child: GridView.builder(
                    itemCount: _quantity,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(_response.urlList[index]);
                    })),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.image),
            onPressed: () async {
              await _files.init();
              await _response.upload(_files.list);
              setState(() {
                _quantity = _response.urlList.length;
              });
            }));
  }
}
