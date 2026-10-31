import 'dart:convert';
//import 'package:flutter_project_exe/model/create_custodain_model.dart';
import 'package:flutter_project_exe/model/create_custodian_model.dart';
import 'package:http/http.dart' as http;

class GetCustodianModel {
  // Android Emulator အတွက်
  static const String baseUrl =
      'http://127.0.0.1:8000/api/v1/intern/custodians/';

  // Get all custodians
  static Future<List<Custodian>> getCustodians() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> results =
          data is List ? data : data['results'] as List<dynamic>;

      return results
          .map((item) =>
              Custodian.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load custodians: ${response.statusCode}',
      );
    }
  }

  // Get custodian by ID
  static Future<Custodian> getCustodianById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$id/'),
    );

    if (response.statusCode == 200) {
      return Custodian.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load custodian: ${response.statusCode}',
      );
    }
  }
}