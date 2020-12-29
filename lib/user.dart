import 'package:shared_preferences/shared_preferences.dart';

class GlobalUser {
  factory GlobalUser() => _getInstance();
  static GlobalUser get instance => _getInstance();
  static GlobalUser _instance;

  GlobalUser._internal() {}

  static GlobalUser _getInstance() {
    if (_instance == null) {
      _instance = new GlobalUser._internal();
    }
    return _instance;
  }

  String mobile;
  String userid;

  save() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    share.setString("userid", this.userid);
    share.setString("mobile", this.mobile);
  }

  load() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    this.userid = share.getString("userid");
    this.mobile = share.getString("mobile");
  }

  del() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    share.remove("userid");
    share.remove("mobile");
  }
}
