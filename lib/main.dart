import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/auth/register.dart';
import 'package:flutter_application_1/screen/layout.dart';
import 'package:flutter_application_1/screen/couple-memory.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:http/http.dart' as http;

import 'utils/const.dart';

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

  void _handleLogin(context) async {
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
      var client = new http.Client();

      try {
        String url = API_SING_IN;
        Map<String, String> headers = {"Content-type": "application/json"};
        var obj = {'username': _username, 'password': _password};

        // tạo POST request
        var loginResp =
            await client.post(url, headers: headers, body: jsonEncode(obj));

        String body = loginResp.body;

        if (loginResp.statusCode == 400) {
          print(loginResp.body.toString());
        } else {
          var loggedUser = jsonDecode(body);

          var loggedUserId = loggedUser['data']['userId'];
          var loggedUserToken = loggedUser['data']['token'];

          UserInfo.getInstance(
              username: _username,
              password: _password,
              userId: loggedUserId,
              token: loggedUserToken);

          scaffold.showSnackBar(
            SnackBar(
              content: Text(
                  "Đăng nhập thành công. Chào mừng: " + _username.toString()),
              action: SnackBarAction(
                  label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Layout()),
          );
        }
      } catch (e) {
        print("error " + e.toString());
      }
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
                )),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage(
                              title: "Register Page",
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Text("Đăng ký"),
                ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
