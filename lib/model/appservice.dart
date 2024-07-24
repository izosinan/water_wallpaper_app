import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:water_wallpaper/model/appmodel.dart';

class AppService {
  final String apiUrl;

  AppService(this.apiUrl);

  Future<List<AppModel>> getApps() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData.containsKey("apps") && jsonData["apps"] is List) {
        final List<dynamic> appsData = jsonData["apps"];
        return appsData.map((json) => AppModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Invalid JSON structure - "apps" key not found or not a list.');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
