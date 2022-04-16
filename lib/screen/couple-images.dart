import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/images/list-view-images.dart';
import 'package:provider/provider.dart';

import '../uploadImage/cloudinary.dart';
import '../uploadImage/images_picker.dart';
import '../uploadImage/upload_images.dart';

class CoupleImages extends StatelessWidget {
  const CoupleImages({Key? key}) : super(key: key);

  void _onOpenCamera(context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        content: Text("Chụp hình thành công"),
        action: SnackBarAction(
            label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => CloudImage(),
      ),
      ChangeNotifierProvider(
        create: (_) => FetchImage(),
      )
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        home: MyHomePage());
  }
}
