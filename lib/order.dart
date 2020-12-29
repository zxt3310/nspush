import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nspush/user.dart';

List names = [
  '全部',
  '待付款',
  '待取货',
  '待配送',
  '待收货',
  '退款中',
  '部分退款中',
  '部分退款',
  '已退款',
  '已完成',
  '已取消'
];
List states = ["99", "10", "20", "50", "30", "60", "70", "80", "1", "40", "0"];

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  TabController tabcontroller;
  PageController pageController;
  int curIndex = 0;

  @override
  void initState() {
    // dataSource = _requestData();
    super.initState();
    pageController = PageController();
    tabcontroller = TabController(vsync: this, length: names.length);
  }

  Future _requestData(int index) async {
    Dio dio = Dio();
    var data;
    if (index == 0) {
      data = {
        'openid': GlobalUser.instance.userid,
      };
    } else {
      data = {
        'openid': GlobalUser.instance.userid,
        'order_state': states[index]
      };
    }
    return dio.post('https://shop.huixian.fun/shopOrderlist', data: data);
  }

  _onChangeTab(e) {
    if (e != curIndex)
      setState(() {
        curIndex = e;
        //pageController = PageController(initialPage: e);
      });
    pageController.animateToPage(e,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  _onChangePage(e) {
    tabcontroller.animateTo(e);
    setState(() {
      curIndex = e;
      pageController = PageController(initialPage: e);
    });
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    print('订单');
    return Container(
      color: Colors.white,
      child: Column(children: [
        TabBar(
          controller: tabcontroller,
          isScrollable: true,
          tabs: _getBtns(),
          onTap: _onChangeTab,
          indicatorColor: Colors.green,
          indicatorWeight: 4,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        Expanded(
            child: PageView.builder(
                itemCount: names.length,
                controller: pageController,
                onPageChanged: _onChangePage,
                itemBuilder: (BuildContext ctx, int index) {
                  return FutureBuilder(
                      future: _requestData(curIndex),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Response data = snapshot.requireData;
                          String str = data.data;
                          Map map = jsonDecode(str);
                          //print(map);
                          if (map['status'] != "1") {
                            return Container(
                              child: Center(
                                child: Text(
                                  '订单加载失败',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }
                          Map orderData = map['data'];
                          String imgUrl = orderData['goodsimgurl'];
                          List orders = orderData['list'];
                          return ItemWidget(orders, imgUrl);
                        } else {
                          return Container(
                            child: Center(
                              child: Text(
                                '加载中...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }
                      });
                }))
      ]),
    );
  }

  List<Widget> _getBtns() {
    return List<Widget>.generate(names.length, (index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(names[index],
            style: TextStyle(
                fontSize: 15,
                color: index == curIndex ? Colors.green : Colors.grey)),
      );
    });
  }
}

class ItemWidget extends StatefulWidget {
  final String imgUrl;
  final List datalist;
  ItemWidget(this.datalist, this.imgUrl);
  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff5f5f5),
      child: ListView.builder(
          itemBuilder: (BuildContext ctx, int index) {
            Map order = widget.datalist[index];
            print(order);
            return GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //订单号
                        Text('订单编号：${order['order_sn']}'),
                        //订单状态
                        Text(_getStatusStr(order['order_state'].toString()),
                            style: TextStyle(color: Colors.green))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //订单时间
                    Text('订单时间：${order['add_time']}'),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      children:
                          _getOrderGoods(order['ordergoods'], widget.imgUrl),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //共计1件 合计金额
                    Text(
                        '共${order['goods_num']}件  合计(含运费)：${order['order_amount']}')
                  ],
                ),
              ),
            );
          },
          itemCount: widget.datalist.length),
    );
  }

  String _getStatusStr(String numStr) {
    for (String str in states) {
      if (str == numStr) {
        int idx = states.indexOf(str);
        return names[idx];
      }
    }
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
