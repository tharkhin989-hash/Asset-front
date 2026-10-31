
import 'dart:convert';
import 'package:flutter_project_exe/model/create_department_model.dart';
import 'package:http/http.dart' as http;

class GetDepartmentModel {
  static const String baseUrl =
      'http://10.0.2.2:8000/api/departments/';

  static Future<List<Department>> getDepartments() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> results =
          data is List ? data : data['results'] as List<dynamic>;

      return results
          .map((item) => Department.fromJson(
              item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load departments: ${response.statusCode}',
    );
  }

  static Future<Department> getDepartmentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl$id/'));

    if (response.statusCode == 200) {
      return Department.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Failed to load department: ${response.statusCode}',
    );
  }
}
