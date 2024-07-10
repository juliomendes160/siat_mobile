import 'dart:convert';
import 'package:flutter/services.dart';

class Environment {
  static late Map<String, dynamic> _current;

  static Map<String, dynamic> get current => _current;

  static Future<void> initialize({required String app}) async {
    _current = await _initialize(app: app);
  }

  static Future<Map<String, dynamic>> _initialize({required String app}) async {
    String jsonFile = await rootBundle.loadString('assets/json/$app.json');
    return json.decode(jsonFile);
  }

}