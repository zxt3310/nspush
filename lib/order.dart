import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TabController tabcontroller;
  PageController pageController;

  _onChangeTab(e) {
    pageController.animateToPage(e,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  _onChangePage(e) {
    tabcontroller.index = e;
  }
  @override
  Widget build(BuildContext context) {
    print('订单');
    return Container(
      child: Column(children: [
        TabBar(tabs: [Text('全部'),Text('代付款'),Text('待取货'),Text('代配送'),Text('待收货'),Text('退款中'),Text('部分退款中'),])
      ],),
    )；
  }
}
