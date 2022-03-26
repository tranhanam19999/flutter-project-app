import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/images/list-view-images.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                    onPressed: () => _onOpenCamera(context),
                    child: const Text("Chụp hình"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(16)),
                    )),
              ),
              Expanded(
                child: SizedBox(height: 200.0, child: ListViewImages(context)),
              ),
            ]),
      ),
    );
  }
}
