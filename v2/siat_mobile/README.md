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

> siat_mobile

```bash
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
    cd caminho/projeto
    flutter pub get
    flutter pub upgrade
    flutter run
    flutter build apk
```

## [webview_flutter](https://pub.dev/packages/webview_flutter)

> siat_mobile

```bash
flutter pub add webview_flutter
```

```dart
import 'package:webview_flutter/webview_flutter.dart';

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
  ..loadRequest(Uri.parse("https://www2.tinus.com.br/csp/testeiga/portal/mobile.csp?478DogU8441dCBXs22449lFtv2289Ma=YJPG13LEl983lnj73092ysqnU194frAEB5430a8099707ruyr979"))
  ..setNavigationDelegate(
    NavigationDelegate()
  );
  return controller;
}
```

siat_mobile\android\app\src\main\AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Firebase

> siat_mobile

```bash
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --project="id-projeto"
flutter pub add firebase_core
flutter pub add firebase_messaging
```

> siat_mobile\android\app\build.gradle

```gradle
minSdkVersion 21
```

> siat_mobile\android\app\src\main\AndroidManifest.xml

```xml 
<meta-data 
    android:name="firebase_messaging_auto'_init_enabled" 
    android:value="false"/>
<meta-data 
    android:name="firebase_analytics_collection_enabled" 
    android:value="false"/>
```