# siat_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Flutter

```bash 
# siat_mobile

flutter --version
# Flutter 3.19.6 • channel stable • https://github.com/flutter/flutter.git
# Framework • revision 54e66469a9 (2 months ago) • 2024-04-17 13:08:03 -0700
# Engine • revision c4cd48e186
# Tools • Dart 3.3.4 • DevTools 2.31.1

flutter doctor
# Doctor summary (to see all details, run flutter doctor -v):
# [√] Flutter (Channel stable, 3.19.6, on Microsoft Windows [versao 10.0.22631.3737], locale pt-BR)
# [√] Windows Version (Installed version of Windows is version 10 or higher)
# [√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
# [√] Chrome - develop for the web
# [√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.9.6)
# [√] Android Studio (version 2023.2)
# [√] VS Code, 64-bit edition (version 1.87.2)
# [√] Connected device (3 available)
# [√] Network resources

flutter create "nome-projeto"
# Creating project v\siat_mobile...
# Resolving dependencies in v\siat_mobile... 
# Got dependencies in v\siat_mobile.
# Wrote 129 files.

# All done!
# You can find general documentation for Flutter at: https://docs.flutter.dev/
# Detailed API documentation is available at: https://api.flutter.dev/
# If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

# In order to run your application, type:

#   $ cd v\siat_mobile
#   $ flutter run

# Your application code is in v\siat_mobile\lib\main.dart.

cd caminho/nome-projeto
```

## [Flutter Webview](https://pub.dev/packages/webview_flutter)

```bash
# siat_mobile

flutter pub add webview_flutter
# Resolving dependencies... 
#   collection 1.18.0 (1.19.0 available)
#   flutter_lints 3.0.2 (4.0.0 available)
#   leak_tracker 10.0.0 (10.0.5 available)
#   leak_tracker_flutter_testing 2.0.1 (3.0.5 available)
#   leak_tracker_testing 2.0.1 (3.0.1 available)
#   lints 3.0.0 (4.0.0 available)
#   material_color_utilities 0.8.0 (0.12.0 available)
#   meta 1.11.0 (1.15.0 available)
# + plugin_platform_interface 2.1.8
#   test_api 0.6.1 (0.7.2 available)
#   vm_service 13.0.0 (14.2.4 available)
# + webview_flutter 4.8.0
# + webview_flutter_android 3.16.3 (3.16.4 available)
# + webview_flutter_platform_interface 2.10.0
# + webview_flutter_wkwebview 3.13.1
# Changed 5 dependencies!
# 11 packages have newer versions incompatible with dependency constraints.
# Try `flutter pub outdated` for more information.
```

```dart
// siat_mobile\lib\main.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  */

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = createWebViewController();
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
      /*
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      */
      body: WebViewWidget(controller: controller),
    );
  }
}

WebViewController createWebViewController() {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse("url"));
  return controller;
}
```

```dart
// siat_mobile\lib\environment.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class Environment {
  static late Map<String, dynamic> _current;

  static Map<String, dynamic> get current => _current;

  static Future<void> initialize({required String app}) async {
    _current = await _initialize(app: app);
  }

  static Future<Map<String, dynamic>> _initialize({required String app}) async {
    String jsonFile = await rootBundle.loadString('json/$app.json');
    return json.decode(jsonFile);
  }
}
```

```yaml
# siat_mobile\pubspec.lock
assets:
  - assets/
```

```properties
# siat_mobile\assets\.properties

applicationId=
label=
icon=
uri=
```
