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
flutter doctor
flutter create "nome-projeto"
cd caminho/nome-projeto
flutter pub get
flutter pub upgrade
flutter run
flutter build apk
```

## [Flutter Webview](https://pub.dev/packages/webview_flutter)

```bash
# siat_mobile
flutter pub add webview_flutter
```

```dart
// siat_mobile\lib\main.dart
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
  ..loadRequest(Uri.parse("url"))
  return controller;
}
```

## [Flutter Downloader](https://pub.dev/packages/flutter_downloader)

```bash
# siat_mobile
flutter pub add flutter_downloader
```

```xml
<!-- final\siat_mobile\android\app\src\main\AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="siat_mobile"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                the Android process has started. This theme is visible to the user
                while the Flutter UI initializes. After that, this theme continues
                to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
            This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
        <provider
            android:name="vn.hunghd.flutterdownloader.DownloadedFileProvider"
            android:authorities="${applicationId}.flutter_downloader.provider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/provider_paths"/>
        </provider>
    </application>
    <!-- Required to query activities that can process text, see:
        https://developer.android.com/training/package-visibility?hl=en and
        https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

        In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
```

## [Firebase](https://firebase.google.com/?hl=pt-br)

```bash
# siat_mobile
node --version
npm install -g firebase-tools
firebase --version
firebase login
dart pub global activate flutterfire_cli
flutterfire.bat --version
flutterfire.bat configure --project="id-projeto"
flutter pub add firebase_core
```

```gradle
// siat_mobile\android\app\build.gradle
defaultConfig {
  minSdkVersion 21
}
```

## [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/flutter/client?hl=pt&authuser=0)

```bash
# siat_mobile
flutter pub add firebase_messaging
```

```dart
// siat_mobile\lib\main.dart
import 'package:firebase_messaging/firebase_messaging.dart';

WebViewController setWebViewController() {
  WebViewController controller = WebViewController();
  controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  controller.loadRequest(Uri.parse("https://www2.tinus.com.br/csp/testeiga/portal/mobile.csp?478DogU8441dCBXs22449lFtv2289Ma=YJPG13LEl983lnj73092ysqnU194frAEB5430a8099707ruyr979"));
  controller.setNavigationDelegate(
    NavigationDelegate(
      onPageFinished: (String url) async {
        Map<String?, String?> tokens = await getTokens();

        print("fcmToken: ${tokens['fcmToken']}");
        print("apnsToken: $tokens['apnsToken']");

        controller.runJavaScript('''
          alert('fcmToken: $tokens[fcmToken]');
          alert('apnsToken:  $tokens[apnsToken]');
        ''');
      }
    )
  );
  return controller;
}

Future<Map<String?, String?>> getTokens() async {
  String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  
  return {
    'apnsToken': apnsToken,
    'fcmToken': fcmToken,
  };
}
```