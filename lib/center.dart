import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:nspush/customRoute.dart';
import 'package:nspush/login.dart';
import 'package:nspush/user.dart';

class UserCenter extends StatefulWidget {
  UserCenter({Key key, this.deviceId, this.push}) : super(key: key);
  final deviceId;
  final JPush push;
  @override
  _UserCenterState createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    print('个人中心');
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(30),
          child: Stack(
            children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '账号：${GlobalUser.instance.mobile}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                      onPressed: () {
                        _logOut();
                      },
                      child: Text(
                        '注销',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ))
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text('版本：v1.1.0'),
              )
            ],
          )),
    );
  }

  _logOut() {
    GlobalUser.instance.del();
    Navigator.of(context).pushReplacement(CustomRoute.fade(
        LoginPage(
          deviceId: widget.deviceId,
          push: widget.push,
        ),
        RouteSettings(name: 'login')));
  }
}
