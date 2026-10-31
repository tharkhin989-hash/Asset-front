import 'dart:convert';

import 'package:flutter_project_exe/model/create_branch_model.dart';
import 'package:http/http.dart' as http;

class GetBranchModel {
  static const String baseUrl =
      'http://10.0.2.2:8000/api/branches/';

  // Get all branches
  static Future<List<Branch>> getBranches() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      // Supports normal lists and Django REST Framework pagination.
      final List<dynamic> results =
          data is List ? data : data['results'] as List<dynamic>;

      return results
          .map((json) => Branch.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load branches: ${response.statusCode} ${response.body}',
      );
    }
  }

  // Get branch by ID
  static Future<Branch> getBranchById(int branchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$branchId/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Branch.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load branch: ${response.statusCode} ${response.body}',
      );
    }
  }
}