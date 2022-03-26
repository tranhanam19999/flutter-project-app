import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/layout.dart';
import 'package:flutter_application_1/screen/couple-memory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _username = "";
  String _password = "";

  void _handleLogin(context) {
    final scaffold = ScaffoldMessenger.of(context);

    if (_password.length < 5) {
      scaffold.showSnackBar(
        SnackBar(
          content:
              Text("Độ dài của mật khẩu phải lớn hơn 6" + _username.toString()),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else if (_username.length < 5) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
              "Độ dài của tên đăng nhập phải lớn hơn 6" + _username.toString()),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else {
      scaffold.showSnackBar(
        SnackBar(
          content:
              Text("Đăng nhập thành công. Chào mừng: " + _username.toString()),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Layout()),
      );
    }
  }

  void _handleOnChangeUsername(text) {
    _username = text.toString();
  }

  void _handleOnChangePassword(text) {
    _password = text.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Đăng Nhập',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tên',
                ),
                onChanged: (text) => _handleOnChangeUsername(text),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập mật khẩu',
                  ),
                  onChanged: (text) => _handleOnChangePassword(text),
                  obscureText: true,
                )),
            TextButton(
                onPressed: () => _handleLogin(context),
                child: const Text("Đăng Nhập"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(16)),
                ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
