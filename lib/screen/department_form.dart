
import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_department_model.dart';
import 'package:flutter_project_exe/service/api_service.dart';

class DepartmentForm extends StatefulWidget {
  const DepartmentForm({super.key});

  @override
  State<DepartmentForm> createState() => _DepartmentFormState();
}

class _DepartmentFormState extends State<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController =
      TextEditingController();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _shortNameController =
      TextEditingController();

  final ApiService _apiService = ApiService();

  String? _departmentType;
  int? _parentDepartmentId;

  bool _allowAssetAssignment = true;
  bool _isActive = true;
  bool _isSaving = false;
  bool _isLoadingParents = false;

  List<Map<String, dynamic>> _parentDepartments = [];

  final List<String> _departmentTypes = [
    'HR',
    'IT',
    'FINANCE',
    'SALES',
    'MARKETING',
    'OPERATIONS',
  ];

  static const Color primaryColor = Color(0xFF7661D5);
  static const Color backgroundColor = Color(0xFFF3F1FF);

  @override
  void initState() {
    super.initState();
    _loadParentDepartments();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  // GET Parent Departments
  Future<void> _loadParentDepartments() async {
    setState(() {
      _isLoadingParents = true;
    });

    try {
      final data = await _apiService.fetchDepartments();

      if (!mounted) return;

      setState(() {
        _parentDepartments = data;
        _isLoadingParents = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingParents = false;
      });

      _showMessage('Failed to load parent departments: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // GET Department ID
  int? _getId(Map<String, dynamic> item) {
    final value = item['department_id'] ?? item['id'];

    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  // POST Department
  Future<void> _saveDepartment() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_departmentType == null) {
      _showMessage('Please select Department Type');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final newDepartment = CreateDepartmentModel(
        departmentCode: _codeController.text.trim(),
        departmentName: _nameController.text.trim(),
        departmentShortName: _shortNameController.text.trim(),
        parentDepartmentId: _parentDepartmentId,
        departmentType: _departmentType!,
        allowAssetAssignment: _allowAssetAssignment,
        isActive: _isActive,
      );

      final success =
          await _apiService.createDepartment(newDepartment);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        _showMessage('Failed to save Department');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Save Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Clear Form
  void _clearForm() {
    _formKey.currentState?.reset();

    _codeController.clear();
    _nameController.clear();
    _shortNameController.clear();

    setState(() {
      _departmentType = null;
      _parentDepartmentId = null;
      _allowAssetAssignment = true;
      _isActive = true;
    });
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(text: text),
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: required),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(hint),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: primaryColor),
      ),
    );
  }

  Widget _buildParentDropdown() {
    final validIds = _parentDepartments
        .map((item) => _getId(item))
        .whereType<int>()
        .toSet();

    final selectedValue =
        validIds.contains(_parentDepartmentId)
            ? _parentDepartmentId
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Parent Department'),
        DropdownButtonFormField<int>(
          value: selectedValue,
          isExpanded: true,
          decoration: _inputDecoration('Select parent department'),
          hint: Text(
            _isLoadingParents
                ? 'Loading departments...'
                : 'Select parent department',
            style: const TextStyle(fontSize: 12),
          ),
          items: _parentDepartments.map((item) {
            final id = _getId(item);

            if (id == null) return null;

            final name =
                item['dept_name']?.toString() ?? '';

            return DropdownMenuItem<int>(
              value: id,
              child: Text(name),
            );
          }).whereType<DropdownMenuItem<int>>().toList(),
          onChanged: _isLoadingParents
              ? null
              : (value) {
                  setState(() {
                    _parentDepartmentId = value;
                  });
                },
        ),
      ],
    );
  }

  Widget _buildDepartmentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Department Type', required: true),
        DropdownButtonFormField<String>(
          value: _departmentType,
          isExpanded: true,
          decoration: _inputDecoration('Select department type'),
          items: _departmentTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _departmentType = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select Department Type';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStatusSection(bool isWide) {
    return isWide
        ? Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity:
                      ListTileControlAffinity.leading,
                  title: const Text(
                    'Allow Asset Assignment',
                    style: TextStyle(fontSize: 13),
                  ),
                  value: _allowAssetAssignment,
                  onChanged: (value) {
                    setState(() {
                      _allowAssetAssignment = value ?? false;
                    });
                  },
                ),
              ),
              Expanded(child: _buildStatusSwitch()),
            ],
          )
        : Column(
            children: [
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity:
                    ListTileControlAffinity.leading,
                title: const Text(
                  'Allow Asset Assignment',
                  style: TextStyle(fontSize: 13),
                ),
                value: _allowAssetAssignment,
                onChanged: (value) {
                  setState(() {
                    _allowAssetAssignment = value ?? false;
                  });
                },
              ),
              _buildStatusSwitch(),
            ],
          );
  }

  Widget _buildStatusSwitch() {
    return Row(
      children: [
        const Text('Status'),
        const SizedBox(width: 10),
        Switch(
          value: _isActive,
          activeColor: primaryColor,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
        Text(_isActive ? 'Active' : 'Inactive'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Department Form'),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;

              return Container(
                width: 900,
                padding: EdgeInsets.all(isWide ? 40 : 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.12),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Add Department Form',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      _buildTextField(
                        label: 'Department Code',
                        controller: _codeController,
                        hint: 'Enter department code',
                        required: true,
                      ),

                      const SizedBox(height: 22),

                      if (isWide)
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'Department Name',
                                controller: _nameController,
                                hint: 'Enter department name',
                                required: true,
                              ),
                            ),
                            const SizedBox(width: 26),
                            Expanded(
                              child: _buildTextField(
                                label: 'Department Short Name',
                                controller:
                                    _shortNameController,
                                hint: 'Enter short name',
                                required: true,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildTextField(
                              label: 'Department Name',
                              controller: _nameController,
                              hint: 'Enter department name',
                              required: true,
                            ),
                            const SizedBox(height: 18),
                            _buildTextField(
                              label: 'Department Short Name',
                              controller:
                                  _shortNameController,
                              hint: 'Enter short name',
                              required: true,
                            ),
                          ],
                        ),

                      const SizedBox(height: 22),

                      if (isWide)
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildParentDropdown(),
                            ),
                            const SizedBox(width: 26),
                            Expanded(
                              child:
                                  _buildDepartmentTypeDropdown(),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildParentDropdown(),
                            const SizedBox(height: 18),
                            _buildDepartmentTypeDropdown(),
                          ],
                        ),

                      const SizedBox(height: 20),

                      _buildStatusSection(isWide),

                      const SizedBox(height: 28),

                      Center(
                        child: Wrap(
                          spacing: 18,
                          children: [
                            SizedBox(
                              width: 115,
                              height: 42,
                              child: ElevatedButton(
                                onPressed:
                                    _isSaving ? null : _saveDepartment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(5),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Save'),
                              ),
                            ),
                            SizedBox(
                              width: 105,
                              height: 42,
                              child: OutlinedButton(
                                onPressed:
                                    _isSaving ? null : _clearForm,
                                child: const Text('Clear'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
