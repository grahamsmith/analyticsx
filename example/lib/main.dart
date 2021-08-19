import 'package:analyticsx/actions/set_screen.dart';
import 'package:analyticsx/actions/track_event.dart';
import 'package:analyticsx/analytics_x.dart';
import 'package:analyticsx/vendors/firebase.dart';
import 'package:example/MyExampleAnalytics/example_analytics_vendor.dart';
import 'package:example/MyExampleAnalytics/simple_counter_event.dart';
import 'package:flutter/material.dart';

void main() {
  AnalyticsX().init([Firebase(), ExampleAnalyticsVendor()]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analytics X Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key) {
    AnalyticsX().invokeAction(SetScreen('HomePage'));
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      AnalyticsX().invokeAction(SimpleCounterEvent('button-count', _counter));
      AnalyticsX().invokeAction(TrackEvent('test_event', {'test-param': 'yes'}));
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
