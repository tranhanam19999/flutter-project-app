import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/layout.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<RegisterPage> {
  String _fullname = "";
  String _username = "";
  String _password = "";
  String _validatePassword = "";

  bool _validateFields(scaffold) {
    if (_password.length < 5) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text("Độ dài của mật khẩu phải lớn hơn 6"),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else if (_username.length < 5) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text("Độ dài của tên đăng nhập phải lớn hơn 6"),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else if (_fullname.length < 5) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text("Độ dài tên của bạn phải lớn hơn 6"),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else if (_password != _validatePassword) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text("Mật khẩu nhập lại không trùng khớp"),
          action: SnackBarAction(
              label: 'Ẩn', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else {
      return true;
    }

    return false;
  }

  void _handleLogin(context) async {
    final scaffold = ScaffoldMessenger.of(context);

    bool isOk = _validateFields(scaffold);

    if (isOk) {
      var client = new http.Client();

      try {
        String url = 'http://localhost:5000/auth/sign-up';
        Map<String, String> headers = {"Content-type": "application/json"};
        var obj = {'fullname': _fullname, 'username': _username, 'password': _password};

        // tạo POST request
        var signUpResp =
            await client.post(url, headers: headers, body: jsonEncode(obj));

        int statusCode = signUpResp.statusCode;
        String body = signUpResp.body;

        if (signUpResp.statusCode == 400) {
          print(signUpResp.body.toString());
        } else {
          var loggedUser = jsonDecode(body);

          var loggedUserId = loggedUser['data']['userId'];
          var loggedUserToken = loggedUser['data']['token'];
          UserInfo.getInstance(username: _username, password: _password, userId: loggedUserId, token: loggedUserToken);

          scaffold.showSnackBar(
            SnackBar(
              content: Text(
                  "Đăng ký thành công. Chào mừng: " + _username.toString()),
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

  void _handleOnChangeFullname(text) {
    _fullname = text.toString();
  }

  void _handleOnChangeUsername(text) {
    _username = text.toString();
  }

  void _handleOnChangePassword(text) {
    _password = text.toString();
  }

  void _handleOnChangeValidatedPassword(text) {
    _validatePassword = text.toString();
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
              'Đăng Ký',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tên của bạn',
                ),
                onChanged: (text) => _handleOnChangeFullname(text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tên đăng nhập',
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
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập lại mật khẩu',
                  ),
                  onChanged: (text) => _handleOnChangeValidatedPassword(text),
                  obscureText: true,
                )),
            TextButton(
                onPressed: () => _handleLogin(context),
                child: const Text("Đăng ký"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(16)),
                )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
