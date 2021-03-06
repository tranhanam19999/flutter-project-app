import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/layout.dart';
import 'package:flutter_application_1/store/user.dart';
import 'package:http/http.dart' as http;

import '../../utils/const.dart';

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
        String url = API_SING_UP;
        Map<String, String> headers = {"Content-type": "application/json"};
        var obj = {
          'fullname': _fullname,
          'username': _username,
          'password': _password
        };

        // tạo POST request
        var signUpResp =
            await client.post(url, headers: headers, body: jsonEncode(obj));

        int statusCode = signUpResp.statusCode;
        String body = signUpResp.body;

        if (signUpResp.statusCode == 400) {
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
        backgroundColor: Color(0xffff3a5a),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Đăng Ký',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextField(
                  onChanged: (text) => _handleOnChangeFullname(text),
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: 'Nhập tên của bạn',
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextField(
                  onChanged: (text) => _handleOnChangeUsername(text),
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: 'Nhập tên đăng nhập',
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextField(
                  obscureText: true,
                  onChanged: (text) => _handleOnChangePassword(text),
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu',
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextField(
                  obscureText: true,
                  onChanged: (text) => _handleOnChangeValidatedPassword(text),
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: 'Nhập lại mật khẩu',
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () => _handleLogin(context),
                child: const Text("Đăng ký"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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
