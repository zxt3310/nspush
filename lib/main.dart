import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:nspush/center.dart';
import 'package:nspush/login.dart';
import 'package:nspush/order.dart';
import 'package:nspush/work.dart';
import "user.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  JPush push = new JPush();
  push.setup(
    appKey: "cdcaa3ecb050f675787b3fbe",
    channel: "developer-default",
    production: false,
    debug: true,
  );
  push.applyPushAuthority(
      new NotificationSettingsIOS(sound: true, alert: true, badge: true));

  // Platform messages may fail, so we use a try/catch PlatformException.
  push.getRegistrationID().then((rid) {
    runAppSync(push: push, deviceId: rid);
    print(rid);
  });
}

void runAppSync({JPush push, String deviceId}) async {
  GlobalUser user = GlobalUser.instance;
  await user.load();
  runApp(MyApp(push: push, deviceId: deviceId));
}

class MyApp extends StatelessWidget {
  final JPush push;
  final String deviceId;
  MyApp({this.push, this.deviceId});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalUser curUser = GlobalUser.instance;
    return BotToastInit(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16)),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: (curUser == null || curUser.userid == null)
          ? LoginPage(
              deviceId: deviceId,
              push: push,
            )
          : MyHomePage(
              jpush: push,
              deviceId: deviceId,
            ),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  final JPush jpush;
  final String deviceId;

  MyHomePage({Key key, this.jpush, this.deviceId}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      widget.jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          currentIndex = currentIndex;
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          setState(() {
            currentIndex = currentIndex;
          });
        });
      });
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("农批商城语音助手"),
      ),
      body: IndexedStack(index: currentIndex, children: [
        OrderPage(),
        WorkPage(),
        UserCenter(deviceId: widget.deviceId, push: widget.jpush)
      ]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '订单'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: '工作台'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的')
        ],
        currentIndex: currentIndex,
        onTap: (e) {
          setState(() {
            currentIndex = e;
          });
        },
      ),
    );
  }
}
