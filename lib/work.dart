import 'package:flutter/material.dart';

class WorkPage extends StatefulWidget {
  WorkPage({Key key}) : super(key: key);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  @override
  Widget build(BuildContext context) {
    print('工作台');
    return Container(
      color: Colors.blue,
      child: Center(child: Text('工作台')),
    );
  }
}
