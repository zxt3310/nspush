import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nspush/user.dart';

class WorkPage extends StatefulWidget {
  WorkPage({Key key}) : super(key: key);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  Future fetchInfo;
  Future fetchData;

  _fetchInfo() {
    Dio dio = Dio();
    return dio.post('https://shop.huixian.fun/shopuserInfo',
        data: {'openid': GlobalUser.instance.userid});
  }

  _fetchData() {
    Dio dio = Dio();
    return dio.post('https://shop.huixian.fun/operatData',
        data: {'openid': GlobalUser.instance.userid});
  }

  @override
  void initState() {
    super.initState();
    fetchInfo = _fetchInfo();
    fetchData = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print('工作台');
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
                future: fetchInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data.data;
                    data = jsonDecode(data);
                    if (data['status'] != "1") {
                      return Container(
                        child: Center(
                          child: Text('信息获取有误'),
                        ),
                      );
                    } else {
                      return _getInfoWidget();
                    }
                  } else {
                    return Container();
                  }
                }),
            Expanded(
              child: FutureBuilder(
                  future: fetchData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var data = snapshot.data.data;
                      data = jsonDecode(data);
                      if (data['status'] != "1") {
                        return Container(
                          child: Center(
                            child: Text('信息获取有误'),
                          ),
                        );
                      } else {
                        return _getOperatWidget();
                      }
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  //商家信息
  Widget _getInfoWidget() {
    return Container(
      color: Colors.green,
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.all(10),child: 
          ,)
        ],
      ),
    );
  }

  //收益
  Widget _getOperatWidget() {
    return Container();
  }
}
