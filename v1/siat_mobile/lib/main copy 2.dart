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

// Configurações Firebase
// flutter pub add firebase_core && \
// flutter pub add firebase_messaging && \

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:siat_mobile/environment.dart';
import 'package:siat_mobile/firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// toke: c9UwUTDHR_GqFpaHEiBntO:APA91bG_qmWMWHxEDKERJ4GqQOaw7Hh7bu0UqX5y5uR3CLukLyw1ce4ajfj0K4lWJRodQopELxBnm88vPofNI9dfLx6N0BoNZwtLw87lihvIjUcOSA-sT6C8omhAhL8_MtXzSeSCHPlm

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  await notification();
  
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  messageForeground();

  await FlutterDownloader.initialize();

  const app = "default";
  // const app = String.fromEnvironment('app');
  await Environment.initialize(app: app);

  final token = await FirebaseMessaging.instance.getToken();
  print("token: ${token}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
        if (domain.host != url.host) {
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
        
        var token2 = await FirebaseMessaging.instance.getToken();

        _controller.runJavaScript('''
          alert($token2);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
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
  
}

Future<void> notification () async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

Future<void> messageForeground  () async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}