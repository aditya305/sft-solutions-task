import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stic_soft_task/models/models.dart';

class ReadJsonSingleton {
  static final ReadJsonSingleton _singleton = ReadJsonSingleton._internal();

  factory ReadJsonSingleton() {
    return _singleton;
  }

  ReadJsonSingleton._internal();

  static Future<List<ProductDataModel>> ReadJsonData() async {
    final jsonData = await rootBundle.loadString("json_file/assignment.json");
    Map<String, dynamic> dataMap = jsonDecode(jsonData);
    final List list = dataMap['products'];
    return list.map((e) {
      // print(ProductDataModel.fromJson(Map<String, dynamic>.from(e)));
      return ProductDataModel.fromJson(Map<String, dynamic>.from(e));
    }).toList();
  }
}
