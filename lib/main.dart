import 'package:cas/cas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    Cas.initialize(
      isTestBuild: true,
      userId: '????',
      onInitializationListener: (bool success, String? error) {
        if (success) {
          print('CAS Initialize success');
        } else {
          print('CAS Initialize error: $error');
        }
      },
      logger: (String eventName) {
        print('CAS -> $eventName');
      },
    );
    super.initState();
  }

  void _incrementCounter() async {
    for (var i = 0; i < 30; i++) {
      if (await Cas.isAdReadyRewarded()) {
        break;
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    await Cas.showRewardedVideoAd(
      'testplacement',
      onShown: (CasAdType type, String network, CasPriceAccuracy priceAccuracy, double cpm, String status, String error, String versionInfo, String identifier) {
        if (error != '') {
          print('Ads. CAS onShown Error: $error');
        }
        print('cas_ad_impression');
      },
      onShowFailed: (String error) {
        print('Ads. CAS ShowFailed $error');
      },
      onClicked: () {
        print('onClicked');
      },
      onComplete: () {
        print('Ads. Reward');
      },
      onClosed: () {
        print( 'Ads. onClosed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
