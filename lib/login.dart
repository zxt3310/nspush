import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:nspush/customRoute.dart';
import 'package:nspush/user.dart';
import 'main.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  final String deviceId;
  final JPush push;
  LoginPage({this.deviceId, this.push});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String account;
  String password;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text('登录'),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '农批商城语音助手',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextField(
                    onChanged: (e) {
                      account = e;
                    },
                    decoration: InputDecoration(
                        hintText: "账号",
                        labelStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.phone_android),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.green)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.green))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: true,
                    onChanged: (e) {
                      password = e;
                    },
                    decoration: InputDecoration(
                        hintText: "密码",
                        labelStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.lock_open),
                        fillColor: Color(0x9e9e9e),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.green)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.green))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                      onPressed: () {
                        _loginRequest();
                      },
                      color: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        '登   录',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ))),
    );
  }

  _loginRequest() {
    if (account == null || account.length == 0) {
      BotToast.showText(text: '请输入账号');
      return;
    }
    if (password == null || password.length == 0) {
      BotToast.showText(text: '请输入密码');
      return;
    }
    BotToast.showLoading();
    Dio dio = Dio();
    dio.post('https://shop.huixian.fun/applogin', data: {
      'phone': account,
      'password': password,
      'ios_regid': widget.deviceId
    }).then((value) {
      BotToast.closeAllLoading();
      if (value.statusCode != 200) {
        BotToast.showText(text: '登录失败，请重试');
        return;
      }
      var data = value.data;
      Map map;
      try {
        map = jsonDecode(data);
      } catch (e) {
        BotToast.showText(text: '解析出错');
        return;
      }
      if (map['status'] == "0") {
        BotToast.showText(text: map['msg']);
      } else {
        print(map);
        Map userData = map['data'];
        if (map != null) {
          GlobalUser cur = GlobalUser.instance;
          cur.mobile = userData['member_mobile'];
          cur.userid = userData['mopenid'];
          cur.save();

          Navigator.of(context).pushReplacement(CustomRoute.fade(
              MyHomePage(jpush: widget.push, deviceId: widget.deviceId),
              RouteSettings(name: '登录')));
        }
      }
    });
  }
}
