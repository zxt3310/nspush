import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GoodInfoPage extends StatefulWidget {
  final String orderId;
  GoodInfoPage(this.orderId);
  @override
  _GoodInfoPageState createState() => _GoodInfoPageState();
}

class _GoodInfoPageState extends State<GoodInfoPage> {
  Future fetchData;

  @override
  void initState() {
    super.initState();
    fetchData = _getOrderInfo();
  }

  Future _getOrderInfo() {
    Dio dio = Dio();
    return dio.post('https://shop.huixian.fun/shopOrderdetail',
        data: {'order_id': int.parse(widget.orderId)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('订单详情')),
      body: FutureBuilder(
          future: fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data.data;
              Map map = jsonDecode(data);
              print(data);
              if (map['status'] != "1") {
                return Container(
                  child: Center(
                    child: Text('订单获取失败'),
                  ),
                );
              } else {
                return _orderLayout(map['data']);
              }
            } else {
              return Container(
                child: Center(
                  child: Text('加载中...'),
                ),
              );
            }
          }),
    );
  }

  Widget _orderLayout(Map data) {
    Map detail = data['detail'];
    List goods = data['ordergoods'];

    return Container(
      padding: const EdgeInsets.all(15),
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('收货人信息'),
          ),
          Divider(
            height: 1,
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('收货人：${detail['reciver_name']}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('收货地址：${detail['address']}'),
          ),
          Divider(
            height: 1,
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('备注：${detail['description']}'),
          ),
          Divider(thickness: 15, color: Colors.black12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('订单信息'),
          ),
          Divider(
            height: 1,
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('订单编号：${detail['order_sn']}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('下单时间：${detail['add_time']}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('订单详情'),
          ),
          Column(children: _getOrderGoods(goods, detail['goodsimgurl'])),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('总价'), Text(detail['order_amount'])],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('总重量'), Text('${detail['total_weight']}斤')],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('折扣'), Text(detail['discount'].toString())],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('手续费'), Text(detail['brokerage'])],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('运费'), Text(detail['deliver'].toString())],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('实付金额：'),
                Text(
                  '￥${detail['order_amount']}',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getOrderGoods(List goods, String imgUrl) {
    return List.generate(goods.length, (index) {
      Map good = goods[index];
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                '$imgUrl${good['goods_image']}',
                width: 80,
                height: 80,
                fit: BoxFit.fitWidth,
              ),
              Column(
                children: [
                  Text(good['goods_name']),
                  SizedBox(
                    height: 10,
                  ),
                  Text(good['goods_price'])
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Text('X${good['goods_num']}')
            ],
          ),
        ),
      );
    });
  }
}
