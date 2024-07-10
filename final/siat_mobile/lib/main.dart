// Comandos Flutter
// flutter doctor
// flutter pub get
// flutter run --dart-define=app=default
// flutter build apk --dart-define=app=

// Criar Projeto
// flutter create nome-do-projeto && \
// cd nome-do-projeto && \
// flutter pub add file_picker && \
// flutter pub add flutter_downloader && \
// flutter pub add path_provider && \
// flutter pub add permission_handler && \
// flutter pub add rflutter_alert && \
// flutter pub add url_launcher && \
// flutter pub add webview_flutter

// Modificar Pastas
// siat_mobile\lib
// siat_mobile\json
// siat_mobile\pubspec.yaml
// siat_mobile\android\app\src\main\res
// siat_mobile\android\app\src\main\AndroidManifest.xml
// siat_mobile\android\app\build.gradle
// siat_mobile\android\app\src\main\res\drawable\launch_background.xml
// siat_mobile\android\app\src\main\res\drawable-v21\launch_background.xml

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();

  const app = String.fromEnvironment('app');
  await Environment.loadSettings(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Environment.current['title'],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: Environment.current['title']),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _controller;
  final Uri domain = Uri.parse(Environment.current['uri']);
  
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) async {
        
        Uri url = Uri.parse(request.url);
        if (domain.host != url.host){
          await launchUrl(url);
          return NavigationDecision.prevent;
        }

        if (request.url.endsWith('.pdf')) {
          await download(request.url);
          return NavigationDecision.prevent;
        }
        
        return NavigationDecision.navigate;
      },

      onPageFinished: (String url) async {
        _controller.runJavaScript('''
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
      },
      
    ))
    ..addJavaScriptChannel('Print', onMessageReceived: (onMessageReceived) async{await upload();})
    ..loadRequest(Uri.parse(Environment.current['uri']));
    
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

        _controller.runJavaScript ('''
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
  
  Future<void> download(String url) async {
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
            if(mounted){
              Navigator.pop(context);
            }
          },
          child: const Text("Configurações", style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}