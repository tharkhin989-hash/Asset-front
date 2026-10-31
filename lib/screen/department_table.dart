
import 'package:flutter/material.dart';
import 'package:flutter_project_exe/screen/department_form.dart';
import 'package:flutter_project_exe/service/api_service.dart';

class DepartmentModel {
  DepartmentModel({
    required this.id,
    required this.deptCode,
    required this.deptName,
    required this.shortName,
    required this.parentDept,
    required this.isActive,
  });

  final int id;
  final String deptCode;
  final String deptName;
  final String shortName;
  final String parentDept;
  bool isActive;
}

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() =>
      _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final ApiService _apiService = ApiService();

  final TextEditingController _searchController =
      TextEditingController();

  List<DepartmentModel> _allDepartments = [];

  bool _isLoading = true;
  String? _selectedStatus = 'All';
  String _searchQuery = '';

  int _currentPage = 0;
  int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getDepartmentId(Map<String, dynamic> item) {
    final value = item['department_id'] ?? item['id'];

    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _getParentDepartment(dynamic value) {
    if (value == null) return '';

    if (value is Map) {
      return (value['dept_name'] ??
              value['department_name'] ??
              value['name'] ??
              value['department_id'] ??
              '')
          .toString();
    }

    return value.toString();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // GET Department List
  Future<void> _fetchData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _apiService.fetchDepartments();

      final departments = data.map((item) {
        return DepartmentModel(
          id: _getDepartmentId(item),
          deptCode: item['dept_code']?.toString() ?? '',
          deptName: item['dept_name']?.toString() ?? '',
          shortName:
              item['dept_short_name']?.toString() ?? '',
          parentDept:
              _getParentDepartment(item['parent_dept']),
          isActive: item['is_active'] == true ||
              item['is_active'] == 1 ||
              item['is_active'] == 'true',
        );
      }).where((dept) => dept.id != 0).toList();

      if (!mounted) return;

      setState(() {
        _allDepartments = departments;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSnackBar('Failed to load departments: $e');
    }
  }

  // Search and Status Filter
  List<DepartmentModel> get _filteredDepartments {
    return _allDepartments.where((dept) {
      bool statusMatch = true;

      if (_selectedStatus == 'Active') {
        statusMatch = dept.isActive;
      } else if (_selectedStatus == 'Inactive') {
        statusMatch = !dept.isActive;
      }

      final query = _searchQuery.toLowerCase();

      final searchMatch =
          dept.deptName.toLowerCase().contains(query) ||
          dept.deptCode.toLowerCase().contains(query) ||
          dept.shortName.toLowerCase().contains(query);

      return statusMatch && searchMatch;
    }).toList();
  }

  // ADD NEW Department
  Future<void> _addNewDepartment() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const DepartmentForm(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _selectedStatus = 'All';
        _currentPage = 0;
        _searchQuery = '';
        _searchController.clear();
      });

      await _fetchData();

      if (!mounted) return;

      _showSnackBar('Department Added Successfully');
    }
  }

  // DELETE Department
  Future<void> _deleteDepartment(
    DepartmentModel dept,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete ${dept.deptName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success =
          await _apiService.deleteDepartment(dept.id);

      if (!mounted) return;

      if (success) {
        _showSnackBar('Department Deleted');
        await _fetchData();
      } else {
        _showSnackBar('Failed to delete department');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Delete Error: $e');
    }
  }

  // UPDATE Department Status
  Future<void> _updateDepartmentStatus(
    DepartmentModel dept,
    bool value,
  ) async {
    final oldValue = dept.isActive;

    setState(() {
      dept.isActive = value;
    });

    try {
      final success =
          await _apiService.updateDepartmentStatus(
        dept.id,
        value,
      );

      if (!mounted) return;

      if (!success) {
        setState(() {
          dept.isActive = oldValue;
        });
        _showSnackBar('Failed to update status');
      } else {
        _showSnackBar('Status updated successfully');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        dept.isActive = oldValue;
      });

      _showSnackBar('Update Error: $e');
    }
  }

  void _downloadPdf() {
    _showSnackBar('PDF download is not connected yet');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDepartments;

    final totalPages =
        (filtered.length / _rowsPerPage).ceil();

    final safePage = totalPages == 0
        ? 0
        : _currentPage.clamp(0, totalPages - 1);

    final start = safePage * _rowsPerPage;

    final end = (start + _rowsPerPage)
        .clamp(0, filtered.length);

    final pageDepartments =
        filtered.sublist(start, end);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Department List',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Status and Search
                Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Status'),
                        const SizedBox(width: 10),
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedStatus,
                              isDense: true,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Active',
                                  child: Text('Active'),
                                ),
                                DropdownMenuItem(
                                  value: 'Inactive',
                                  child: Text('Inactive'),
                                ),
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text('All'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value;
                                  _currentPage = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      width: 250,
                      height: 36,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _currentPage = 0;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          suffixIcon:
                              const Icon(Icons.search),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addNewDepartment,
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add New'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _downloadPdf,
                      icon: const Icon(Icons.download, size: 14),
                      label: const Text('Download PDF'),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Department Table
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(50),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('No departments found'),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1000,
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(
                            const Color(0xFFF1F3F5),
                          ),
                          dataRowMinHeight: 45,
                          dataRowMaxHeight: 50,
                          headingRowHeight: 45,
                          horizontalMargin: 15,
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(
                              label: Text('Dept Code'),
                            ),
                            DataColumn(
                              label: Text('Dept Name'),
                            ),
                            DataColumn(
                              label: Text('Short Name'),
                            ),
                            DataColumn(
                              label: Text('Parent Dept'),
                            ),
                            DataColumn(
                              label: Text('Status'),
                            ),
                            DataColumn(
                              label: Text('Action'),
                            ),
                          ],
                          rows: pageDepartments.map((dept) {
                            return DataRow(
                              cells: [
                                DataCell(Text(dept.deptCode)),
                                DataCell(Text(dept.deptName)),
                                DataCell(Text(dept.shortName)),
                                DataCell(
                                  dept.parentDept.isNotEmpty
                                      ? Text(dept.parentDept)
                                      : const Text('-'),
                                ),
                                DataCell(
                                  Switch(
                                    value: dept.isActive,
                                    activeColor:
                                        const Color(0xFF2563EB),
                                    onChanged: (value) {
                                      _updateDepartmentStatus(
                                        dept,
                                        value,
                                      );
                                    },
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Color(0xFFDC3545),
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _deleteDepartment(dept);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                // Pagination
                if (!_isLoading && filtered.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            IconButton(
                              onPressed: safePage > 0
                                  ? () {
                                      setState(() {
                                        _currentPage--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            Text(
                              'Page ${safePage + 1} of $totalPages',
                            ),
                            IconButton(
                              onPressed: safePage < totalPages - 1
                                  ? () {
                                      setState(() {
                                        _currentPage++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                        DropdownButton<int>(
                          value: _rowsPerPage,
                          items: const [
                            DropdownMenuItem(
                              value: 5,
                              child: Text('5 rows'),
                            ),
                            DropdownMenuItem(
                              value: 10,
                              child: Text('10 rows'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _rowsPerPage = value;
                              _currentPage = 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
