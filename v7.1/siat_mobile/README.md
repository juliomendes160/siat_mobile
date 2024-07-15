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

## [Criar APP]()

```objectscript
// Logo do APP rotina - CSPWEBMOBILE

;CSPWEBMOBILE: Este código requer a criação das pastas e o armazenamento das imagens no TS correspondentes.

BODY
	DO PATH^EMIPDF
	S LOGOTOPO="",WLOGO=WDIRIMG_"imagens/AppMobile/app_logo_pref.png" IF ##class(%Library.File).Exists(PATH_WLOGO) S LOGOTOPO=WLOGO
	S LOGOAPP="",WLOGO=WDIRIMG_"imagens/AppMobile/app_logo_inicio.png" IF ##class(%Library.File).Exists(PATH_WLOGO) S LOGOAPP=WLOGO
	;
```

```md
<!-- siat_mobile\android\app\src\main\res\mimmap-* -->

Adicionar imagens
```

```json
// siat_mobile\settings\*.json

{
  "id": "com.example.siat_mobile",
  "label": "siat_mobile",
  "icon": "@mipmap/ic_launcher",
  "uri": ""
}
```

```bash
# siat_mobile

flutter run --dart-define=app=default
flutter build apk --dart-define=app=default
```

## [Flutter](https://docs.flutter.dev/get-started/install/windows/mobile)

```bash
# siat_mobile

flutter create siat_mobile
cd siat_mobile
```

```json
// siat_mobile\settings\*.json

{
  "id": "com.example.siat_mobile",
  "label": "siat_mobile",
  "icon": "@mipmap/ic_launcher",
  "uri": ""
}
```

```yaml
# siat_mobile\pubspec.yaml

assets:
  - assets/settings/
```

```gradle
# siat_mobile\android\app\build.gradle

def app = [:]
if (project.hasProperty('dart-defines')) {
    def dartDefines = project.property('dart-defines')

    dartDefines.split(',').each { encodedString ->
        def decodedBytes = Base64.getDecoder().decode(encodedString)
        def decodedString = new String(decodedBytes)

        decodedString.split(',').each { keyValueString ->
            def (key, value) = keyValueString.split('=')
            app[key] = value
        }
    }
    
    // println "app: ${app}"
}

def file = file("../../assets/settings/${app.app}.json")
def environment = new groovy.json.JsonSlurper().parseText(file.text)

defaultConfig {
  // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
  applicationId = environment.id
  manifestPlaceholders += [
      applicationLabel: environment.label,
      applicationIcon: environment.icon,
  ]
  // resValue "string", "applicationIcon", "@mipmap/${environment.icon}"
  // buildConfigField "String", "applicationId", environment.id
}
```

```md
<!-- siat_mobile\android\app\src\main\res\mimmap-* -->

Adicionar imagens
```

```xml
<!-- siat_mobile\android\app\src\main\AndroidManifest.xml -->

<application
  android:label="${applicationLabel}"
  android:icon="${applicationIcon}">
</application>
```

```dart
// siat_mobile\lib\main.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class Environment {
  static late Map<String, dynamic> _current;

  static Map<String, dynamic> get current => _current;

  static Future<void> loadSettings({required String app}) async {
    _current = await _loadSettings(app: app);
  }

  static Future<Map<String, dynamic>> _loadSettings({required String app}) async {
    String environment = await rootBundle.loadString('assets/settings/$app.json');
    return json.decode(environment);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const app = String.fromEnvironment('app');
  await Environment.loadSettings(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Environment.current['title'],
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
      home: MyHomePage(title: Environment.current['title']),
    );
  }
}
```

## [webview_flutter](https://pub.dev/packages/webview_flutter)

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
    controller = webViewController();
  }

  WebViewController webViewController() {
    WebViewController controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse(Environment.current['uri']));
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) async {
      return NavigationDecision.navigate;
      },
    ));
    return controller;
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
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
```

### [permission_handler](https://pub.dev/packages/permission_handler)

```bash
# siat_mobile

flutter pub add permission_handler
```

## [rflutter_alert](https://pub.dev/packages/rflutter_alert)

```bash
# siat_mobile

flutter pub add rflutter_alert
# flutter pub remove rflutter_alert
```

```dart
// siat_mobile\lib\main.dart

import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class _MyHomePageState extends State<MyHomePage> {
  Future<void> permission(String title, String desc) async {
    await Alert(
      context: context,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.blue,
          onPressed: () async {
            await openAppSettings(); 
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: const Text("Configurações", style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ],
    ).show();
  }
}
```

## [path_provider](https://pub.dev/packages/path_provider)

```bash
# siat_mobile

flutter pub add path_provider
```

## [flutter_downloader](https://pub.dev/packages/flutter_downloader)

```bash
# siat_mobile

flutter pub add flutter_downloader
```

```dart
// siat_mobile\lib\main.dart

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();

  const app = String.fromEnvironment('app');
  await Environment.loadSettings(app: app);

  runApp(const MyApp());
}

WebViewController webViewController() {
  WebViewController controller = WebViewController();
  controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  controller.loadRequest(Uri.parse(Environment.current['uri']));
  controller.setNavigationDelegate(NavigationDelegate(
    onNavigationRequest: (NavigationRequest request) async {
      if (request.url.endsWith('.pdf')) {
        await download(request);
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
  ));
  return controller;
}

Future<void> download(NavigationRequest request) async {
    var status = await Permission.notification.status;

    if (!status.isGranted) {
      status = await Permission.notification.request();

      if (!status.isGranted) {
        await permission(
          "Permissão de Notificação",
          "Para executar downloads"
        );
        status = await Permission.notification.request();
      }
    }

    if (status.isGranted) {
      final directory = await getExternalStorageDirectory();
      final savedDir = directory?.path ?? '';

      await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir,
      );
    }
  }
```

```xml
<!-- siat_mobile\android\app\src\main\AndroidManifest.xml -->

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
</manifest>

<application>
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
```

## [file_picker](https://pub.dev/packages/file_picker)

```bash
# siat_mobile

flutter pub add file_picker
```

```dart
// siat_mobile\lib\main.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';

class _MyHomePageState extends State<MyHomePage> {

  WebViewController webViewController() {
    WebViewController controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse(Environment.current['uri']));
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) async {
        if (request.url.endsWith('.pdf')) {
          await download(request);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) async {
        await listenInputFile();
      },
    ));
    controller.addJavaScriptChannel('Print', onMessageReceived: (onMessageReceived) async {
      await upload();
    });
    return controller;
  }

  Future<void> listenInputFile() async {
    controller.runJavaScript('''
      window[0].frameElement.onload = function () {
        if (window[0].document.getElementById('FileStream')){
          window[0].document.getElementById('FileStream').onclick = function() {
            try { Print.postMessage(''); } catch (error) { }
          }
        }
        
        if (window[0].document.getElementById('upload')) {
          window[0].document.getElementById('upload').onload = function () {
            if (window[0][0].document.getElementById('FileStream')) {
              window[0][0].document.getElementById('FileStream').onclick = function() {
                try { Print.postMessage(''); } catch (error) { }
              }
            }
          }
        }
      }
    ''');
  }

  Future<void> upload() async {

    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();

      if (!status.isGranted) {
        await permission(
          context,
          "Permissão de Armazenamento",
          "Para executar uploads"
        );
        status = await Permission.manageExternalStorage.request();
      }
    }

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null) {

        PlatformFile data = result.files.single;

        File file = File(data.path!);
        
        Uint8List bytes = await file.readAsBytes();

        String content =  base64.encode(bytes);

        controller.runJavaScript('''
          var fileInput = window[0].document.getElementById('FileStream') || window[0][0].document.getElementById('FileStream');
          if (fileInput) {
            var base64Data = '$content';
            var byteCharacters = atob(base64Data); // Decodifica Base64 para uma string de bytes
            var byteNumbers = new Array(byteCharacters.length);
            for (var i = 0; i < byteCharacters.length; i++) {
              byteNumbers[i] = byteCharacters.charCodeAt(i);
            }
            var byteArray = new Uint8Array(byteNumbers);
            var file = new File([byteArray], '${data.name}');
            var dataTransfer = new DataTransfer();
            dataTransfer.items.add(file);
            fileInput.files = dataTransfer.files;
          }
        ''');
      }
    }
  }
}
```

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
  <uses-permission android:name="android.permission.BLUETOOTH"/>
  <uses-permission android:name="android.permission.DOWNLOAD_WITHOUT_NOTIFICATION"/>
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <uses-permission android:name="android.permission.READ_APP_BADGE"/>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.READ_PHONE_STATE" />
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.VIBRATE" />
  <uses-permission android:name="android.permission.WAKE_LOCK" />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
</manifest>
```

## [url_launcher](https://pub.dev/packages/url_launcher)

```bash
# siat_mobile

flutter pub add url_launcher
```

```dart
// siat_mobile\lib\main.dart

class _MyHomePageState extends State<MyHomePage> {

  WebViewController webViewController() {
    WebViewController controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) async {
        if (Uri.parse(Environment.current['uri']).host != Uri.parse(request.url).host) {
          await openExternalURL(request);
          return NavigationDecision.prevent;
        }
        if (request.url.endsWith('.pdf')) {
          await download(request);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) async {
        await listenInputFile();
      },
    ));
    controller.addJavaScriptChannel('Print', onMessageReceived: (onMessageReceived) async {
      await upload();
    });
    controller.loadRequest(Uri.parse(Environment.current['uri']));
    return controller;
  }

  Future<void> openExternalURL(NavigationRequest request) async {
    await launchUrl(Uri.parse(request.url));
  }
}
```

## [Firebase](https://firebase.google.com/docs/cli?hl=pt&authuser=0&_gl=1*18fim00*_ga*MTI1OTg4MDA5My4xNzE4MDIzNTg0*_ga_CW55HF8NVT*MTcyMDcxOTU3MS4zMC4xLjE3MjA3MTk2ODEuMTUuMC4w#install_the_firebase_cli)

```bash
# siat_mobile

npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --project=siat-mobile-d2493 # com.example.siat_mobile
flutter pub add firebase_core
```

```dart
// siat_mobile\lib\main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:siat_mobile/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FlutterDownloader.initialize();

  const app = String.fromEnvironment('app');
  await Environment.loadSettings(app: app);

  runApp(const MyApp());
}
```

```json
// siat_mobile\android\app\google-services.json

{
  "package_name": ""
}
```

## [Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/?authuser=0&hl=pt&_gl=1*z5c4rx*_ga*MTI1OTg4MDA5My4xNzE4MDIzNTg0*_ga_CW55HF8NVT*MTcyMDgwNDc4Mi4zNC4xLjE3MjA4MDQ5MDQuNDIuMC4w#implementation_paths)

```
# siat_mobile

flutter pub add firebase_messaging
```

```dart
// siat_mobile\lib\main.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await FlutterDownloader.initialize();

  const app = String.fromEnvironment('app');
  await Environment.loadSettings(app: app);

  runApp(const MyApp());
}
class Environment {
  static late Map<String, dynamic> _current;

  static Map<String, dynamic> get current => _current;

  static Future<void> loadSettings({required String app}) async {
    _current = await _loadSettings(app: app);
  }

  static Future<Map<String, dynamic>> _loadSettings({required String app}) async {
    String environment = await rootBundle.loadString('assets/settings/$app.json');
    
    Map<String, dynamic> settings = json.decode(environment);
    settings['android'] = await FirebaseMessaging.instance.getToken();
    settings['ios'] = await FirebaseMessaging.instance.getAPNSToken();
    environment = json.encode(settings);

    return json.decode(environment);
  }
}

WebViewController webViewController() {

    WebViewController controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) async {
        if (Uri.parse(Environment.current['uri']).host != Uri.parse(request.url).host) {
          await openExternalURL(request);
          return NavigationDecision.prevent;
        }
        if (request.url.endsWith('.pdf')) {
          await download(request);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) async {
        await listenInputFile();
      },
    ));
    controller.addJavaScriptChannel('Print', onMessageReceived: (onMessageReceived) async {
      await upload();
    });
    controller.loadRequest(Uri.parse("${Environment.current['uri']}&WANDROID=${Environment.current['android']}&WIOS=${Environment.current['ios']}"));
    return controller;
  }
```

```xml
<!-- siat_mobile\android\app\src\main\AndroidManifest.xml -->

<meta-data
    android:name="firebase_messaging_auto_init_enabled"
    android:value="false" />
<meta-data
    android:name="firebase_analytics_collection_enabled"
    android:value="false" />
```