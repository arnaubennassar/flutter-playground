import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'iden3 mobile lib'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // set callback handler
  String _message = "press button";
  int _counter = 0;
  static const platform = const MethodChannel('iden3.com/callinggo');

  void initState() {
    super.initState();
    // CHANNEL (flutter <== android)
    platform.setMethodCallHandler(goAsyncHandler);
  }
  // ASYNC TEST
  Future<void> _asyncTest() async {
    String newHash;
    try {
      var arguments = Map();
      arguments["secs"] = 5;
      setState(() {
        _message = "waiting";
      });
      await platform.invokeMethod("asyncTest", arguments);
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
    }

    if (newHash != null) {
      setState(() {
        _message = newHash;
      });
    }
  }

  Future<void> _incr() async {
    setState(() {
        ++_counter;
    });
  }

  Future<void> goAsyncHandler(MethodCall methodCall) async {
    print("someone just called goAsyncHandler");
    print(methodCall);
    print("_________________________________________________________");
    switch (methodCall.method) {
      case 'asyncTestCallback':
        setState(() {
          _message = methodCall.arguments;
        });
        return;
      default:
        print("UNIMPLEMENTED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              _message,
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: _incr,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _asyncTest,
                tooltip: 'Wait',
                child: Icon(Icons.alarm),
              ),
            ),
          ],
        ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
