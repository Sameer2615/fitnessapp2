import 'dart:convert';
import 'package:flutter/services.dart';

class LabelLoader {
  static Future<List<String>> loadLabels(String path) async {
    final data = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(data);
    final sortedKeys = jsonMap.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return sortedKeys.map((k) => jsonMap[k] as String).toList();
  }
}
