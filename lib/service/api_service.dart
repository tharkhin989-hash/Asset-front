
import 'dart:convert';

import 'package:flutter_project_exe/config/api_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ==================== BRANCH ====================

  Future<List<dynamic>> fetchBranches() async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/branches/',
    );

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> data =
          decoded is List ? decoded : decoded['results'];

      return data;
    }

    throw Exception(
      'Failed to load branches: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> createBranch(Map<String, dynamic> branch) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/branches/',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(branch),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      'Failed to create branch: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> updateBranch(
    int branchId,
    Map<String, dynamic> branch,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/branches/$branchId/',
    );

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(branch),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Failed to update branch: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> deleteBranch(int branchId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/branches/$branchId/',
    );

    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Failed to delete branch: '
      '${response.statusCode} ${response.body}',
    );
  }

  // ==================== DEPARTMENT ====================

  Future<List<dynamic>> fetchDepartments() async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/departments/',
    );

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> data =
          decoded is List ? decoded : decoded['results'];

      return data;
    }

    throw Exception(
      'Failed to load departments: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> createDepartment(
    Map<String, dynamic> department,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/departments/',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(department),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      'Failed to create department: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> updateDepartment(
    int departmentId,
    Map<String, dynamic> department,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/departments/$departmentId/',
    );

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(department),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Failed to update department: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> deleteDepartment(int departmentId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/departments/$departmentId/',
    );

    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Failed to delete department: '
      '${response.statusCode} ${response.body}',
    );
  }

  // ==================== CUSTODIAN ====================

  Future<List<dynamic>> fetchCustodians() async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/custodians/',
    );

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> data =
          decoded is List ? decoded : decoded['results'];

      return data;
    }

    throw Exception(
      'Failed to load custodians: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> createCustodian(
    Map<String, dynamic> custodian,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/custodians/',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(custodian),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      'Failed to create custodian: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> updateCustodian(
    int custodianId,
    Map<String, dynamic> custodian,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/custodians/$custodianId/',
    );

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(custodian),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Failed to update custodian: '
      '${response.statusCode} ${response.body}',
    );
  }

  Future<void> deleteCustodian(int custodianId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/custodians/$custodianId/',
    );

    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Failed to delete custodian: '
      '${response.statusCode} ${response.body}',
    );
  }
}
