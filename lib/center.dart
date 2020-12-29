import 'package:flutter/material.dart';

class UserCenter extends StatefulWidget {
  UserCenter({Key key}) : super(key: key);

  @override
  _UserCenterState createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    print('个人中心');
    return Container(
      color: Colors.green,
      child: Center(
        child: Text('个人中心'),
      ),
    );
  }
}
