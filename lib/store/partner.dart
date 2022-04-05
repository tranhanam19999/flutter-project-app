class PartnerInfo {
  // variables
  late String? username = "";
  late String? password = "";
  late String? userId = "";
  late String? token = "";
  late String? fullname = "";

  PartnerInfo(
      {this.username, this.password, this.userId, this.token, this.fullname});

  static PartnerInfo? _instance;

  static PartnerInfo? getInstance(
      {username, password, userId, token, fullname}) {
    if (_instance == null) {
      _instance = PartnerInfo(
          username: username,
          password: password,
          userId: userId,
          token: token,
          fullname: fullname);
      return _instance;
    }
    return _instance;
  }
}
