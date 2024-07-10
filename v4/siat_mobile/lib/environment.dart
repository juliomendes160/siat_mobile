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