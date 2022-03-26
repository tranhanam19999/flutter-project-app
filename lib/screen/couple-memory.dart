import 'package:flutter/material.dart';

class CoupleMemory extends StatelessWidget {
  const CoupleMemory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                  child: Text(
                    'Đã ở bên nhau được 100 ngày',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              'images/bear.png',
                              width: 600.0,
                              height: 240.0,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            'images/bear.png',
                            width: 600.0,
                            height: 240.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                    child: Text(
                      'Cảm ơn gì gì đó, chúc kỷ niệm,...',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ])
            ]),
      ),
    );
  }
}
