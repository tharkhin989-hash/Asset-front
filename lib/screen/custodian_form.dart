import 'package:flutter/material.dart';
//import 'package:flutter_project_exe/model/create_custodain_model.dart';
import 'package:flutter_project_exe/model/create_custodian_model.dart';
class CustodianForm extends StatefulWidget {
  final Custodian? custodian;
  final Function(Custodian) onSubmit;

  const CustodianForm({
    super.key,
    this.custodian,
    required this.onSubmit,
  });

  @override
  State<CustodianForm> createState() => _CustodianFormState();
}

class _CustodianFormState extends State<CustodianForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController branchController;
  late TextEditingController deptController;
  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  String custodianType = 'SUPPLIER';
  bool canHoldAssets = false;
  bool isActive = true;

  @override
  void initState() {
    super.initState();

    final c = widget.custodian;

    branchController =
        TextEditingController(text: c?.branchId?.toString() ?? '');
    deptController =
        TextEditingController(text: c?.deptId?.toString() ?? '');
    codeController =
        TextEditingController(text: c?.custodianCode ?? '');
    nameController =
        TextEditingController(text: c?.custodianName ?? '');
    phoneController =
        TextEditingController(text: c?.phone ?? '');
    emailController =
        TextEditingController(text: c?.email ?? '');

    custodianType = c?.custodianType ?? 'SUPPLIER';
    canHoldAssets = c?.canHoldAssets ?? false;
    isActive = c?.isActive ?? true;
  }

  @override
  void dispose() {
    branchController.dispose();
    deptController.dispose();
    codeController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget textField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (required &&
              (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  int? parseOptionalId(String value) {
    if (value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }

  void saveCustodian() {
    if (!_formKey.currentState!.validate()) return;

    final branchText = branchController.text.trim();
    final deptText = deptController.text.trim();

    final branchId = parseOptionalId(branchText);
    final deptId = parseOptionalId(deptText);

    if ((branchText.isNotEmpty && branchId == null) ||
        (deptText.isNotEmpty && deptId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Branch ID and Department ID must be numbers'),
        ),
      );
      return;
    }

    final custodian = Custodian(
      custodianId: widget.custodian?.custodianId,
      branchId: branchId,
      deptId: deptId,
      custodianCode: codeController.text.trim().isEmpty
          ? null
          : codeController.text.trim(),
      custodianName: nameController.text.trim(),
      custodianType: custodianType,
      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      email: emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim(),
      canHoldAssets: canHoldAssets,
      isActive: isActive,
      createdAt: widget.custodian?.createdAt,
      updatedAt: widget.custodian?.updatedAt,
    );

    widget.onSubmit(custodian);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.custodian != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Custodian' : 'Add Custodian'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            textField(
              'Branch ID (optional)',
              branchController,
              keyboardType: TextInputType.number,
            ),
            textField(
              'Department ID (optional)',
              deptController,
              keyboardType: TextInputType.number,
            ),
            textField('Custodian Code', codeController),
            textField(
              'Custodian Name',
              nameController,
              required: true,
            ),
            DropdownButtonFormField<String>(
              value: custodianType,
              decoration: const InputDecoration(
                labelText: 'Custodian Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'SUPPLIER',
                  child: Text('SUPPLIER'),
                ),
                DropdownMenuItem(
                  value: 'EMPLOYEE',
                  child: Text('EMPLOYEE'),
                ),
                DropdownMenuItem(
                  value: 'EXTERNAL',
                  child: Text('EXTERNAL'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => custodianType = value);
                }
              },
            ),
            const SizedBox(height: 12),
            textField(
              'Phone',
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            textField(
              'Email',
              emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SwitchListTile(
              title: const Text('Can Hold Assets'),
              value: canHoldAssets,
              onChanged: (value) {
                setState(() => canHoldAssets = value);
              },
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: isActive,
              onChanged: (value) {
                setState(() => isActive = value);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: saveCustodian,
              icon: const Icon(Icons.save),
              label: Text(editing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}