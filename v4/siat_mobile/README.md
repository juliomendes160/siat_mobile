# siat_mobile

Um novo projeto Flutter.

## Começando

Este projeto é um ponto de partida para uma aplicação Flutter.

Alguns recursos para começar se este é o seu primeiro projeto Flutter:

- [Laboratório: Escreva seu primeiro aplicativo Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Exemplos úteis do Flutter](https://docs.flutter.dev/cookbook)

Para obter ajuda para começar a desenvolver com Flutter, consulte a
[documentação online](https://docs.flutter.dev/), que oferece tutoriais,
exemplos, orientações sobre desenvolvimento móvel e uma referência completa da API.

## [Flutter](https://docs.flutter.dev/get-started/install/windows/mobile)

```bash 
# siat_mobile

flutter --version
flutter doctor
flutter create siat_mobile
cd siat_mobile
```

```gradle
// siat_mobile\android\app\build.gradle

def environment = [:]
if (project.hasProperty('dart-defines')) {
    def dartDefines = project.property('dart-defines')
    def decodedBytes = Base64.getDecoder().decode(dartDefines)
    def decodedString = new String(decodedBytes)
    decodedString
    .split(',')
    .each { keyValueString ->
        def (key, value) = keyValueString.split('=')
        environment[key] = value
    }
}

def file = file("../../settings/json/${environment.app}.json")
def json = new JsonSlurper().parse(file)

// applicationId "com.example.siat_mobile"
applicationId settings.applicationId

manifestPlaceholders += [applicationLabel: settings.label]
resValue "string", "applicationIcon", "@mipmap/${settings.icon}"
```

```xml
<!-- siat_mobile\android\app\src\main\AndroidManifest.xml -->

<application
    android:label="${applicationLabel}"
    android:icon="@string/applicationIcon">
```

```yaml
# siat_mobile\pubspec.yaml

assets:
- settings/
```

```json
// siat_mobile\settings\json\*.json

{
    "applicationId":"",
    "label":"",
    "icon":"",
    "uri":""
}
```

```properties
# siat_mobile\assets\config\*.properties

applicationId=
label=
icon=
uri=
```

```c
// siat_mobile\android\app\src\main\res\mipmap-*

// Adicionar imagens
```

```dart
// siat_mobile\lib\environment.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class Environment {
  static late Map<String, String> _current;

  static Map<String, String> get current => _current;

  static Future<void> initialize({required String app}) async {
    _current = await _initialize(app: app);
  }

  static Future<Map<String, String>> _initialize({required String app}) async {
    String settings = await rootBundle.loadString('settings/json/$app.json');
    return json.decode(settings);
  }
}
```

```dart
// siat_mobile\lib\main.dart

Future<void> main() async {
  const app = String.fromEnvironment('app');
  await Environment.initialize(app: app);
  runApp(const MyApp());
}
```

## [Flutter Webview](https://pub.dev/packages/webview_flutter)

```bash
# siat_mobile

flutter pub add webview_flutter
```

```dart
// siat_mobile\lib\main.dart

import 'package:webview_flutter/webview_flutter.dart';

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

WebViewController createWebViewController() {
  WebViewController controller = WebViewController();
  controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  controller.loadRequest(Uri.parse(Environment.current['uri']!));
  return controller;
}
```

```xml
<!-- siat_mobile\android\app\src\main\AndroidManifest.xml -->

<uses-permission android:name="android.permission.INTERNET"/>
```