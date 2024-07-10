import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Environment {
  static late Map<String, dynamic> _current;

  static Map<String, dynamic> get current => _current;

  static Future<void> loadSettings({required String app}) async {
    _current = await _loadSettings(app: app);
  }

  static Future<Map<String, dynamic>> _loadSettings({required String app}) async {
    // print("defaultTargetPlatform:${defaultTargetPlatform.name}");
    String environment = await rootBundle.loadString('assets/settings/$app.json');
    return json.decode(environment);
  }

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();

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
    controller = webViewController();
  }

  WebViewController webViewController() {
    WebViewController controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) async {
        if (request.url.endsWith('.pdf')) {
          await download(request);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) async {
        await inputFile();
      },
    ));
    controller.addJavaScriptChannel('Print', onMessageReceived: (onMessageReceived) async {
      await upload();
    });
    controller.loadRequest(Uri.parse(Environment.current['uri']));
    return controller;
  }

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
        url: request.url,
        savedDir: savedDir,
      );
    }
  }
  
  Future<void> inputFile() async {
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
