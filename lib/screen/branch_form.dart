
import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_branch_model.dart';

class BranchForm extends StatefulWidget {
  final Branch? branch;
  final Function(Branch) onSubmit;

  const BranchForm({
    super.key,
    this.branch,
    required this.onSubmit,
  });

  @override
  State<BranchForm> createState() => _BranchFormState();
}

class _BranchFormState extends State<BranchForm> {
  final _formKey = GlobalKey<FormState>();

  final branchCodeController = TextEditingController();
  final branchNameController = TextEditingController();
  final countryIdController = TextEditingController();
  final regionController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  int? selectedCountryId;
  bool isActive = true;

  final Color purple = const Color(0xFF7960C8);

  @override
  void initState() {
    super.initState();

    final branch = widget.branch;

    if (branch != null) {
      branchCodeController.text = branch.branchCode ?? '';
      branchNameController.text = branch.branchName;
      selectedCountryId = branch.countryId;
      regionController.text = branch.region ?? '';
      cityController.text = branch.city ?? '';
      addressController.text = branch.address ?? '';
      postalCodeController.text = branch.postalCode?.toString() ?? '';
      phoneController.text = branch.phone ?? '';
      emailController.text = branch.email ?? '';
      isActive = branch.isActive;
    }
  }

  @override
  void dispose() {
    branchCodeController.dispose();
    branchNameController.dispose();
    countryIdController.dispose();
    regionController.dispose();
    cityController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: purple, width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 11),
    );
  }

  Widget field({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool requiredField = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Color(0xFF292929),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            children: [
              if (requiredField)
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (value) {
            if (requiredField && (value == null || value.trim().isEmpty)) {
              return 'Required';
            }
            return null;
          },
          decoration: decoration(hint),
        ),
      ],
    );
  }

  void saveBranch() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCountryId == null || selectedCountryId! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a country')),
      );
      return;
    }

    final now = DateTime.now();

    final branch = Branch(
      branchId: widget.branch?.branchId,
      countryId: selectedCountryId!,
      branchCode: branchCodeController.text.trim(),
      branchName: branchNameController.text.trim(),
      region: regionController.text.trim(),
      city: cityController.text.trim(),
      address: addressController.text.trim(),
      postalCode: int.tryParse(postalCodeController.text.trim()),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      isActive: isActive,
      createdAt: widget.branch?.createdAt ?? now,
      updatedAt: now,
      createdBy: widget.branch?.createdBy,
      updatedBy: widget.branch?.updatedBy,
    );

    widget.onSubmit(branch);
    Navigator.pop(context);
  }

  void clearForm() {
    _formKey.currentState?.reset();

    branchCodeController.clear();
    branchNameController.clear();
    regionController.clear();
    cityController.clear();
    addressController.clear();
    postalCodeController.clear();
    phoneController.clear();
    emailController.clear();

    setState(() {
      selectedCountryId = null;
      isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.branch != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Branch Form' : 'Add Branch Form'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Add Branch Form',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Branch Code and Branch Name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: field(
                          label: 'Branch Code',
                          controller: branchCodeController,
                          hint: 'Enter branch code',
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: field(
                          label: 'Branch Name',
                          controller: branchNameController,
                          hint: 'Enter branch name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Country, Region and City
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Country*',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 7),
                            DropdownButtonFormField<int>(
                              value: selectedCountryId,
                              decoration: decoration('Select country'),
                              items: List.generate(
                                10,
                                (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('Country ${index + 1}'),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedCountryId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: field(
                          label: 'Region/State',
                          controller: regionController,
                          hint: 'Enter Region/State',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: field(
                          label: 'City / Township',
                          controller: cityController,
                          hint: 'Enter city / Township',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Address and Postal Code
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: field(
                          label: 'Address',
                          controller: addressController,
                          hint: 'Enter address',
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: field(
                          label: 'Postal Code',
                          controller: postalCodeController,
                          hint: 'Enter postal code',
                          keyboardType: TextInputType.number,
                          requiredField: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Phone and Email
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: field(
                          label: 'Phone Number',
                          controller: phoneController,
                          hint: 'Enter phone number',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: field(
                          label: 'Email Address',
                          controller: emailController,
                          hint: 'Enter branch email address',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Active status
                  Row(
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: isActive,
                        activeThumbColor: purple,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                      Text(isActive ? 'Active' : 'Inactive'),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Save and Clear buttons
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 115,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: saveBranch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 42,
                        child: OutlinedButton(
                          onPressed: clearForm,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
