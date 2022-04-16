class UserInfo {
  // variables
  late String? username = "";
  late String? password = "";
  late String? userId = "";
  late String? token = "";

  UserInfo({this.username, this.password, this.userId, this.token});

  static UserInfo? _instance;

  static UserInfo? getInstance({username, password, userId, token}) {
    if (_instance == null) {
      _instance =
          UserInfo(username: username, password: password, userId: userId, token: token);
      return _instance;
    }
    return _instance;
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      userId: json['userId'],
    );
  }
}
