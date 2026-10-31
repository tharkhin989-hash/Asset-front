import 'package:flutter/material.dart';

void main() => runApp(const AssetManagementApp());

const Color appBlue = Color(0xFF2854D7);
const Color appPurple = Color(0xFF7654D8);
const Color appInk = Color(0xFF252A39);
const Color appBorder = Color(0xFFD8D9E0);

class AssetManagementApp extends StatelessWidget {
  const AssetManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asset Management',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: appBlue),
      ),
      home: const BranchFormPage(),
    );
  }
}

// Shared in-memory data. These records remain available while the app is open.
class Branch {
  String code;
  String name;
  String country;
  String region;
  String city;
  String address;
  String postalCode;
  String phone;
  String email;
  bool active;

  Branch({
    required this.code,
    required this.name,
    this.country = 'Myanmar',
    this.region = '',
    this.city = '',
    this.address = '',
    this.postalCode = '',
    this.phone = '',
    this.email = '',
    this.active = true,
  });
}

class Department {
  String code;
  String name;
  String shortName;
  String parent;
  String type;
  bool allowAsset;
  bool active;

  Department({
    required this.code,
    required this.name,
    this.shortName = '',
    this.parent = '-',
    this.type = 'Main Department',
    this.allowAsset = true,
    this.active = true,
  });
}

class Custodian {
  String code;
  String type;
  String name;
  String branch;
  String department;
  String phone;
  String email;
  bool canHoldAssets;
  bool active;

  Custodian({
    required this.code,
    required this.type,
    required this.name,
    required this.branch,
    required this.department,
    required this.phone,
    required this.email,
    required this.canHoldAssets,
    required this.active,
  });
}

final List<Branch> branchRecords = [
  Branch(code: 'B-001', name: 'Yangon Branch', region: 'Yangon Region', city: 'Yangon', address: 'Downtown Yangon', phone: '09-778240355', email: 'yangon@gmail.com'),
  Branch(code: 'B-002', name: 'Mandalay Branch', region: 'Mandalay Region', city: 'Mandalay', address: 'Mandalay Downtown', phone: '09-778240355', email: 'mandalay@gmail.com'),
  Branch(code: 'B-003', name: 'Naypyidaw Branch', region: 'Naypyidaw', city: 'Naypyidaw', address: 'Naypyidaw', phone: '09-778240355', email: 'naypyidaw@gmail.com'),
  Branch(code: 'B-004', name: 'Bago Branch', region: 'Bago Region', city: 'Bago', address: 'Bago Main Road', active: false),
];

final List<Department> departmentRecords = [
  Department(code: 'Dept-001', name: 'Administration', shortName: 'Admin'),
  Department(code: 'Dept-002', name: 'Human Resources', shortName: 'HR'),
  Department(code: 'Dept-003', name: 'Finance', shortName: 'Finance'),
  Department(code: 'Dept-004', name: 'IT Department', shortName: 'IT'),
  Department(code: 'Dept-005', name: 'Operations', shortName: 'Ops'),
];

final List<Custodian> custodianRecords = [];

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

InputDecoration appDecoration(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: Color(0xFF9999A3), fontSize: 12),
  contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
  isDense: true,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: appBorder)),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: appBorder)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: appBlue, width: 1.4)),
);

Widget appLabel(String label, {bool required = true}) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 12, color: appInk, fontWeight: FontWeight.w600),
      children: [
        TextSpan(text: label),
        if (required) const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
      ],
    ),
  ),
);

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppHeader({super.key, this.title = 'Asset Management'});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Colors.white,
    foregroundColor: const Color(0xFF263654),
    elevation: 1,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: appBlue, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 9),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ],
    ),
    actions: [
      _navButton(context, 'Departments', Icons.account_tree_outlined, const DepartmentListPage()),
      _navButton(context, 'Branches', Icons.business_outlined, const BranchListPage()),
      _navButton(context, 'Custodians', Icons.person_outline, const CustodianListPage()),
      const SizedBox(width: 8),
    ],
  );
}

Widget _navButton(BuildContext context, String label, IconData icon, Widget page) => TextButton.icon(
  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
  icon: Icon(icon, size: 17),
  label: Text(label, style: const TextStyle(fontSize: 12)),
);

Widget _field({
  required String label,
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    appLabel(label),
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: appDecoration(hint),
      validator: validator ?? (v) => v == null || v.trim().isEmpty ? 'Please enter $label' : null,
    ),
  ],
);

Widget _dropdown({
  required String label,
  required String hint,
  required List<String> items,
  required String? value,
  required ValueChanged<String?> onChanged,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    appLabel(label),
    DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: appDecoration(hint),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Please select $label' : null,
    ),
  ],
);

class CustodianListPage extends StatefulWidget {
  const CustodianListPage({super.key});

  @override
  State<CustodianListPage> createState() => _CustodianListPageState();
}

class _CustodianListPageState extends State<CustodianListPage> {
  final searchController = TextEditingController();
  String status = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _addCustodian() async {
    final result = await Navigator.push<Custodian>(
      context,
      MaterialPageRoute(builder: (_) => const CustodianFormPage()),
    );
    if (!mounted || result == null) return;
    setState(() => custodianRecords.add(result));
    showAppMessage(context, 'Custodian saved successfully.');
  }


  Future<void> _editCustodian(Custodian item) async {
    final result = await Navigator.push<Custodian>(
      context,
      MaterialPageRoute(
        builder: (_) => CustodianFormPage(initialCustodian: item),
      ),
    );
    if (!mounted || result == null) return;

    setState(() {
      item.code = result.code;
      item.type = result.type;
      item.name = result.name;
      item.branch = result.branch;
      item.department = result.department;
      item.phone = result.phone;
      item.email = result.email;
      item.canHoldAssets = result.canHoldAssets;
      item.active = result.active;
    });
    showAppMessage(context, 'Custodian updated successfully.');
  }

  Future<void> _delete(Custodian item) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete custodian?'),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (yes == true && mounted) setState(() => custodianRecords.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    final q = searchController.text.trim().toLowerCase();
    final items = custodianRecords.where((c) {
      final matches = [c.code, c.name, c.type, c.branch, c.department, c.email].any((s) => s.toLowerCase().contains(q));
      return matches && (status == 'All' || (status == 'Active' && c.active) || (status == 'Inactive' && !c.active));
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text('Custodian List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                SizedBox(width: 150, child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: appDecoration('Status'),
                  items: const ['All', 'Active', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => status = v ?? 'All'),
                )),
                SizedBox(width: 250, child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: appDecoration('Search custodians').copyWith(prefixIcon: const Icon(Icons.search)),
                )),
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              FilledButton.icon(onPressed: _addCustodian, icon: const Icon(Icons.add), label: const Text('Add Custodian')),
              const Spacer(),
              Text('${items.length} record(s)', style: const TextStyle(color: Colors.black54)),
            ]),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: appBorder), borderRadius: BorderRadius.circular(8)),
                child: items.isEmpty
                    ? const Center(child: Text('No custodians found. Press Add Custodian to create one.'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Code')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Ph No')),
                              DataColumn(label: Text('Dept Name')),
                              DataColumn(label: Text('Branch')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: items.map((c) => DataRow(cells: [
                              DataCell(Text(c.code)),
                              DataCell(Text(c.name)),
                              DataCell(Text(c.type)),
                              DataCell(Text(c.phone.isEmpty ? '-' : c.phone)),
                              DataCell(Text(c.department)),
                              DataCell(Text(c.branch)),
                              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                Switch(
                                  value: c.active,
                                  activeTrackColor: Colors.green,
                                  onChanged: (value) => setState(() => c.active = value),
                                ),
                                Text(c.active ? 'On' : 'Off', style: TextStyle(
                                  color: c.active ? Colors.green.shade700 : Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                )),
                              ])),
                              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                TextButton.icon(
                                  onPressed: () => _editCustodian(c),
                                  icon: const Icon(Icons.edit_outlined, size: 17),
                                  label: const Text('Edit'),
                                ),
                                TextButton.icon(
                                  onPressed: () => _delete(c),
                                  icon: const Icon(Icons.delete_outline, size: 17),
                                  label: const Text('Delete'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                ),
                              ])),
                            ])).toList(),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustodianFormPage extends StatefulWidget {
  final Custodian? initialCustodian;
  const CustodianFormPage({super.key, this.initialCustodian});

  @override
  State<CustodianFormPage> createState() => _CustodianFormPageState();
}

class _CustodianFormPageState extends State<CustodianFormPage> {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String? type;
  String? branch;
  String? department;
  bool canHoldAssets = true;
  bool active = true;

  final types = const ['Employee', 'Department', 'External Custodian', 'Other'];

  @override
  void initState() {
    super.initState();
    final item = widget.initialCustodian;
    if (item != null) {
      codeController.text = item.code;
      nameController.text = item.name;
      phoneController.text = item.phone;
      emailController.text = item.email;
      type = item.type;
      branch = item.branch;
      department = item.department;
      canHoldAssets = item.canHoldAssets;
      active = item.active;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _selectBranch() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BranchListPage(selectionMode: true)),
    );
    if (!mounted || result == null) return;
    setState(() => branch = result);
  }

  Future<void> _selectDepartment() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const DepartmentListPage(selectionMode: true)),
    );
    if (!mounted || result == null) return;
    setState(() => department = result);
  }

  Widget _selectField(String label, String? value, VoidCallback onTap) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      appLabel(label),
      InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: appDecoration('Select $label').copyWith(
            suffixIcon: const Icon(Icons.search, size: 19),
            errorText: null,
          ),
          child: Text(value ?? 'Select $label', style: TextStyle(fontSize: 12, color: value == null ? const Color(0xFF9999A3) : appInk)),
        ),
      ),
      if ((label == 'Branch' && branch == null) || (label == 'Department' && department == null))
        const SizedBox.shrink(),
    ],
  );

  void _save() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (branch == null || department == null) {
      showAppMessage(context, 'Please select both a branch and a department.');
      return;
    }
    final record = Custodian(
      code: codeController.text.trim(),
      type: type!,
      name: nameController.text.trim(),
      branch: branch!,
      department: department!,
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      canHoldAssets: canHoldAssets,
      active: active,
    );
    Navigator.pop<Custodian>(context, record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: const AppHeader(title: 'Asset Management'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(widget.initialCustodian == null ? 'Custodian Register Form' : 'Edit Custodian', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF19366F))),
                      const SizedBox(height: 8),
                      Text(widget.initialCustodian == null ? 'Enter custodian information below' : 'Update custodian information below', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      const SizedBox(height: 28),
                      LayoutBuilder(builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 600;
                        final first = _field(label: 'Custodian Code', hint: 'Enter custodian code', controller: codeController);
                        final second = _dropdown(label: 'Custodian Type', hint: 'Select custodian type', items: types, value: type, onChanged: (v) => setState(() => type = v));
                        return wide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: first), const SizedBox(width: 24), Expanded(child: second)]) : Column(children: [first, const SizedBox(height: 18), second]);
                      }),
                      const SizedBox(height: 18),
                      _field(label: 'Custodian Name', hint: 'Enter custodian name', controller: nameController),
                      const SizedBox(height: 18),
                      LayoutBuilder(builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 600;
                        final first = _selectField('Branch', branch, _selectBranch);
                        final second = _selectField('Department', department, _selectDepartment);
                        return wide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: first), const SizedBox(width: 24), Expanded(child: second)]) : Column(children: [first, const SizedBox(height: 18), second]);
                      }),
                      const SizedBox(height: 18),
                      LayoutBuilder(builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 600;
                        final first = _field(label: 'Phone Number', hint: 'Enter phone number', controller: phoneController, keyboardType: TextInputType.phone);
                        final second = _field(
                          label: 'Email Address',
                          hint: 'Enter email address',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            final email = v?.trim() ?? '';
                            if (email.isEmpty) return 'Please enter Email Address';
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) return 'Enter a valid email address';
                            return null;
                          },
                        );
                        return wide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: first), const SizedBox(width: 24), Expanded(child: second)]) : Column(children: [first, const SizedBox(height: 18), second]);
                      }),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Checkbox(value: canHoldAssets, onChanged: (v) => setState(() => canHoldAssets = v ?? false), activeColor: appBlue),
                            const Text('Can Hold Assets'),
                          ]),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            const Text('Status'),
                            Switch(value: active, onChanged: (v) => setState(() => active = v), activeTrackColor: appBlue),
                            Text(active ? 'Active' : 'Inactive'),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(alignment: WrapAlignment.center, spacing: 14, children: [
                        SizedBox(width: 160, child: FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined, size: 18), label: Text(widget.initialCustodian == null ? 'Save Custodian' : 'Update Custodian'))),
                        SizedBox(width: 140, child: OutlinedButton.icon(
                          onPressed: () => setState(() {
                            formKey.currentState?.reset();
                            codeController.clear();
                            nameController.clear();
                            phoneController.clear();
                            emailController.clear();
                            type = null;
                            branch = null;
                            department = null;
                            canHoldAssets = true;
                            active = true;
                          }),
                          icon: const Icon(Icons.clear, size: 17),
                          label: const Text('Clear Form'),
                        )),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BranchFormPage extends StatefulWidget {
  final bool returnResult;
  final Branch? initialBranch;
  const BranchFormPage({super.key, this.returnResult = false, this.initialBranch});

  @override
  State<BranchFormPage> createState() => _BranchFormPageState();
}

class _BranchFormPageState extends State<BranchFormPage> {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final countryController = TextEditingController(text: 'Myanmar');
  final regionController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool active = true;

  @override
  void initState() {
    super.initState();
    final branch = widget.initialBranch;
    if (branch != null) {
      codeController.text = branch.code;
      nameController.text = branch.name;
      countryController.text = branch.country;
      regionController.text = branch.region;
      cityController.text = branch.city;
      addressController.text = branch.address;
      postalCodeController.text = branch.postalCode;
      phoneController.text = branch.phone;
      emailController.text = branch.email;
      active = branch.active;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    countryController.dispose();
    regionController.dispose();
    cityController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget _branchField(String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool required = false,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appLabel(label, required: required),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: appDecoration(hint),
          validator: validator ?? (required
              ? (value) => value == null || value.trim().isEmpty
                  ? 'Please enter $label'
                  : null
              : null),
        ),
      ],
    );
  }

  Widget _twoColumns(Widget first, Widget second) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Column(children: [first, const SizedBox(height: 16), second]);
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: first),
        const SizedBox(width: 20),
        Expanded(child: second),
      ]);
    });
  }

  void _saveBranch() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final code = codeController.text.trim();
    if (branchRecords.any((branch) => branch.code.toLowerCase() == code.toLowerCase() && !identical(branch, widget.initialBranch))) {
      showAppMessage(context, 'This branch code already exists.');
      return;
    }

    final branch = Branch(
      code: code,
      name: nameController.text.trim(),
      country: countryController.text.trim(),
      region: regionController.text.trim(),
      city: cityController.text.trim(),
      address: addressController.text.trim(),
      postalCode: postalCodeController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      active: active,
    );

    if (widget.returnResult) {
      Navigator.pop<Branch>(context, branch);
      return;
    }

    setState(() => branchRecords.add(branch));
    showAppMessage(context, 'Branch saved successfully.');
    _clearForm();
  }

  void _clearForm() {
    formKey.currentState?.reset();
    codeController.clear();
    nameController.clear();
    countryController.text = 'Myanmar';
    regionController.clear();
    cityController.clear();
    addressController.clear();
    postalCodeController.clear();
    phoneController.clear();
    emailController.clear();
    setState(() => active = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: const AppHeader(title: 'Asset Management'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.initialBranch == null ? 'Branch Register Form' : 'Edit Branch',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF19366F)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Enter branch information below', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 13)),
                      const SizedBox(height: 28),
                      // Follow the Custodian form's field layout: paired fields,
                      // full-width name/address fields, and consistent spacing.
                      _twoColumns(
                        _branchField('Branch Code', 'Enter branch code', codeController, required: true),
                        _branchField('Country', 'Enter country', countryController, required: true),
                      ),
                      const SizedBox(height: 18),
                      _branchField('Branch Name', 'Enter branch name', nameController, required: true),
                      const SizedBox(height: 18),
                      _twoColumns(
                        _branchField('Region / State', 'Enter region or state', regionController),
                        _branchField('City / Township', 'Enter city or township', cityController),
                      ),
                      const SizedBox(height: 18),
                      _twoColumns(
                        _branchField('Postal Code', 'Enter postal code', postalCodeController, keyboardType: TextInputType.number),
                        _branchField('Phone Number', 'Enter phone number', phoneController, keyboardType: TextInputType.phone),
                      ),
                      const SizedBox(height: 18),
                      _branchField('Address', 'Enter branch address', addressController),
                      const SizedBox(height: 18),
                      _branchField(
                        'Email Address', 'Enter email address', emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'Please enter Email Address';
                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Branch Status', style: TextStyle(fontWeight: FontWeight.w600)),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(active ? 'Active' : 'Inactive'),
                            Switch(value: active, onChanged: (value) => setState(() => active = value), activeTrackColor: appBlue),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 10,
                        children: [
                          SizedBox(width: 140, child: FilledButton.icon(onPressed: _saveBranch, icon: const Icon(Icons.save_outlined, size: 18), label: const Text('Save Branch'))),
                          SizedBox(width: 140, child: OutlinedButton.icon(onPressed: _clearForm, icon: const Icon(Icons.clear, size: 18), label: const Text('Clear Form'))),
                          SizedBox(width: 140, child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BranchListPage())), icon: const Icon(Icons.list_alt, size: 18), label: const Text('View Branches'))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BranchListPage extends StatefulWidget {
  final bool selectionMode;
  const BranchListPage({super.key, this.selectionMode = false});

  @override
  State<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  final searchController = TextEditingController();
  String status = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _addBranch() async {
    final result = await Navigator.push<Branch>(
      context,
      MaterialPageRoute(builder: (_) => const BranchFormPage(returnResult: true)),
    );
    if (!mounted || result == null) return;
    if (branchRecords.any((b) => b.code.toLowerCase() == result.code.toLowerCase())) {
      showAppMessage(context, 'This branch code already exists.');
      return;
    }
    setState(() => branchRecords.add(result));
    showAppMessage(context, 'Branch saved successfully.');
  }


  Future<void> _editBranch(Branch item) async {
    final result = await Navigator.push<Branch>(
      context,
      MaterialPageRoute(
        builder: (_) => BranchFormPage(
          returnResult: true,
          initialBranch: item,
        ),
      ),
    );
    if (!mounted || result == null) return;

    if (branchRecords.any((b) =>
        !identical(b, item) &&
        b.code.toLowerCase() == result.code.toLowerCase())) {
      showAppMessage(context, 'This branch code already exists.');
      return;
    }

    setState(() {
      item.code = result.code;
      item.name = result.name;
      item.country = result.country;
      item.region = result.region;
      item.city = result.city;
      item.address = result.address;
      item.postalCode = result.postalCode;
      item.phone = result.phone;
      item.email = result.email;
      item.active = result.active;
    });
    showAppMessage(context, 'Branch updated successfully.');
  }

  @override
  Widget build(BuildContext context) {
    final q = searchController.text.trim().toLowerCase();
    final items = branchRecords.where((b) =>
      [b.code, b.name, b.region, b.city].any((v) => v.toLowerCase().contains(q)) &&
      (status == 'All' || (status == 'Active' && b.active) || (status == 'Inactive' && !b.active))
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          Text(widget.selectionMode ? 'Select Branch' : 'Branch List', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 10, children: [
            SizedBox(width: 150, child: DropdownButtonFormField<String>(
              value: status,
              decoration: appDecoration('Status'),
              items: const ['All', 'Active', 'Inactive'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => status = v ?? 'All'),
            )),
            SizedBox(width: 250, child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: appDecoration('Search branches').copyWith(prefixIcon: const Icon(Icons.search)),
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            if (!widget.selectionMode)
              FilledButton.icon(onPressed: _addBranch, icon: const Icon(Icons.add), label: const Text('Add Branch')),
            const Spacer(),
            Text('${items.length} record(s)', style: const TextStyle(color: Colors.black54)),
          ]),
          const SizedBox(height: 12),
          Expanded(child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: appBorder), borderRadius: BorderRadius.circular(8)),
            child: items.isEmpty
              ? const Center(child: Text('No branches found.'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Branch Code')),
                      DataColumn(label: Text('Branch Name')),
                      DataColumn(label: Text('Phone No')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('Country')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: items.map((b) => DataRow(
                      onSelectChanged: widget.selectionMode ? (selected) {
                        if (selected != true) return;
                        if (b.active) {
                          Navigator.pop<String>(context, b.name);
                        } else {
                          showAppMessage(context, 'Please choose an active branch.');
                        }
                      } : null,
                      cells: [
                        DataCell(Text(b.code)),
                        DataCell(Text(b.name)),
                        DataCell(Text(b.phone.isEmpty ? '-' : b.phone)),
                        DataCell(Text(b.email.isEmpty ? '-' : b.email)),
                        DataCell(Text(b.address.isEmpty ? '-' : b.address)),
                        DataCell(Text(b.city.isEmpty ? '-' : b.city)),
                        DataCell(Text(b.country.isEmpty ? '-' : b.country)),
                        DataCell(widget.selectionMode
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: b.active ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(b.active ? 'Active' : 'Inactive', style: TextStyle(
                                color: b.active ? Colors.green.shade700 : Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              )),
                            )
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              Switch(
                                value: b.active,
                                activeTrackColor: Colors.green,
                                onChanged: (value) => setState(() => b.active = value),
                              ),
                              Text(b.active ? 'On' : 'Off', style: TextStyle(
                                color: b.active ? Colors.green.shade700 : Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              )),
                            ])),
                        DataCell(widget.selectionMode
                          ? const Icon(Icons.chevron_right)
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              TextButton.icon(
                                onPressed: () => _editBranch(b),
                                icon: const Icon(Icons.edit_outlined, size: 17),
                                label: const Text('Edit'),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.delete_outline, size: 17),
                                label: const Text('Delete'),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Text('Delete Branch'),
                                      content: Text('Delete ${b.name}?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
                                        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true && mounted) {
                                    setState(() => branchRecords.remove(b));
                                    showAppMessage(context, 'Branch deleted successfully.');
                                  }
                                },
                              ),
                            ])),
                      ],
                    )).toList(),
                  )),
                ),
          )),
        ]),
      ),
    );
  }
}

class BranchEditDialog extends StatefulWidget {
  const BranchEditDialog({super.key});

  @override
  State<BranchEditDialog> createState() => _BranchEditDialogState();
}

class _BranchEditDialogState extends State<BranchEditDialog> {
  final keyForm = GlobalKey<FormState>();
  final code = TextEditingController();
  final name = TextEditingController();
  final city = TextEditingController();
  bool active = true;

  @override
  void dispose() {
    code.dispose();
    name.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add Branch'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: keyForm,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: code, decoration: appDecoration('Branch Code'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter branch code' : null),
          const SizedBox(height: 12),
          TextFormField(controller: name, decoration: appDecoration('Branch Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter branch name' : null),
          const SizedBox(height: 12),
          TextFormField(controller: city, decoration: appDecoration('City / Township')),
          SwitchListTile(title: const Text('Active'), value: active, onChanged: (v) => setState(() => active = v)),
        ]),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (!(keyForm.currentState?.validate() ?? false)) return;
        Navigator.pop(context, Branch(code: code.text.trim(), name: name.text.trim(), city: city.text.trim(), active: active));
      }, child: const Text('Save')),
    ],
  );
}

class DepartmentListPage extends StatefulWidget {
  final bool selectionMode;
  const DepartmentListPage({super.key, this.selectionMode = false});

  @override
  State<DepartmentListPage> createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  final searchController = TextEditingController();
  String status = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _addDepartment() async {
    final result = await Navigator.push<Department>(
      context,
      MaterialPageRoute(builder: (_) => const DepartmentFormPage()),
    );
    if (!mounted || result == null) return;
    setState(() => departmentRecords.add(result));
    showAppMessage(context, 'Department added successfully.');
  }


  Future<void> _editDepartment(Department item) async {
    final result = await Navigator.push<Department>(
      context,
      MaterialPageRoute(
        builder: (_) => DepartmentFormPage(initialDepartment: item),
      ),
    );
    if (!mounted || result == null) return;

    if (departmentRecords.any((d) =>
        !identical(d, item) &&
        d.code.toLowerCase() == result.code.toLowerCase())) {
      showAppMessage(context, 'This department code already exists.');
      return;
    }

    setState(() {
      item.code = result.code;
      item.name = result.name;
      item.shortName = result.shortName;
      item.parent = result.parent;
      item.type = result.type;
      item.allowAsset = result.allowAsset;
      item.active = result.active;
    });
    showAppMessage(context, 'Department updated successfully.');
  }

  Future<void> _deleteDepartment(Department item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Department?'),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => departmentRecords.remove(item));
      showAppMessage(context, 'Department deleted successfully.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = searchController.text.trim().toLowerCase();
    final items = departmentRecords.where((d) =>
      [d.code, d.name, d.shortName, d.parent].any((v) => v.toLowerCase().contains(q)) &&
      (status == 'All' || (status == 'Active' && d.active) || (status == 'Inactive' && !d.active))
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          Text(widget.selectionMode ? 'Select Department' : 'Department List', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 10, children: [
            SizedBox(width: 150, child: DropdownButtonFormField<String>(
              value: status,
              decoration: appDecoration('Status'),
              items: const ['All', 'Active', 'Inactive'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => status = v ?? 'All'),
            )),
            SizedBox(width: 250, child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: appDecoration('Search departments').copyWith(prefixIcon: const Icon(Icons.search)),
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            if (!widget.selectionMode)
              FilledButton.icon(onPressed: _addDepartment, icon: const Icon(Icons.add), label: const Text('Add Department')),
            const Spacer(),
            Text('${items.length} record(s)', style: const TextStyle(color: Colors.black54)),
          ]),
          const SizedBox(height: 12),
          Expanded(child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: appBorder), borderRadius: BorderRadius.circular(8)),
            child: items.isEmpty
              ? const Center(child: Text('No departments found.'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Dept Code')),
                      DataColumn(label: Text('Dept Name')),
                      DataColumn(label: Text('Short Name')),
                      DataColumn(label: Text('Parent Dept')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: items.map((d) => DataRow(
                      onSelectChanged: widget.selectionMode ? (selected) {
                        if (selected != true) return;
                        if (d.active) {
                          Navigator.pop<String>(context, d.name);
                        } else {
                          showAppMessage(context, 'Please choose an active department.');
                        }
                      } : null,
                      cells: [
                        DataCell(Text(d.code)),
                        DataCell(Text(d.name)),
                        DataCell(Text(d.shortName.isEmpty ? '-' : d.shortName)),
                        DataCell(Text(d.parent)),
                        DataCell(widget.selectionMode
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: d.active ? const Color(0xFFE4F7EA) : const Color(0xFFFDE8E7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(d.active ? 'Active' : 'Inactive', style: TextStyle(
                                color: d.active ? const Color(0xFF187744) : const Color(0xFFB42318),
                                fontWeight: FontWeight.w600,
                              )),
                            )
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              Switch(
                                value: d.active,
                                activeTrackColor: Colors.green,
                                onChanged: (value) => setState(() => d.active = value),
                              ),
                              Text(d.active ? 'On' : 'Off', style: TextStyle(
                                color: d.active ? const Color(0xFF187744) : const Color(0xFFB42318),
                                fontWeight: FontWeight.w600,
                              )),
                            ])),
                        DataCell(widget.selectionMode
                          ? const Icon(Icons.chevron_right)
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              TextButton.icon(
                                onPressed: () => _editDepartment(d),
                                icon: const Icon(Icons.edit_outlined, size: 17),
                                label: const Text('Edit'),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.delete_outline, size: 17),
                                label: const Text('Delete'),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () => _deleteDepartment(d),
                              ),
                            ])),
                      ],
                    )).toList(),
                  )),
                ),
          )),
        ]),
      ),
    );
  }
}

class DepartmentFormPage extends StatefulWidget {
  final Department? initialDepartment;
  const DepartmentFormPage({super.key, this.initialDepartment});

  @override
  State<DepartmentFormPage> createState() => _DepartmentFormPageState();
}

class _DepartmentFormPageState extends State<DepartmentFormPage> {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final shortNameController = TextEditingController();
  String parent = '-';
  String type = 'Main Department';
  bool allowAsset = true;
  bool active = true;

  final departmentTypes = const ['Main Department', 'Sub Department', 'Section', 'Unit'];

  @override
  void initState() {
    super.initState();
    final item = widget.initialDepartment;
    if (item != null) {
      codeController.text = item.code;
      nameController.text = item.name;
      shortNameController.text = item.shortName;
      parent = item.parent;
      type = item.type;
      allowAsset = item.allowAsset;
      active = item.active;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    shortNameController.dispose();
    super.dispose();
  }

  Widget _twoColumns(Widget first, Widget second) => LayoutBuilder(
    builder: (context, constraints) => constraints.maxWidth < 600
      ? Column(children: [first, const SizedBox(height: 18), second])
      : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: first), const SizedBox(width: 20), Expanded(child: second),
        ]),
  );

  void _save() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final code = codeController.text.trim();
    if (departmentRecords.any((d) =>
        d.code.toLowerCase() == code.toLowerCase() &&
        !identical(d, widget.initialDepartment))) {
      showAppMessage(context, 'This department code already exists.');
      return;
    }
    Navigator.pop<Department>(context, Department(
      code: code,
      name: nameController.text.trim(),
      shortName: shortNameController.text.trim(),
      parent: parent,
      type: type,
      allowAsset: allowAsset,
      active: active,
    ));
  }

  void _clear() {
    formKey.currentState?.reset();
    codeController.clear();
    nameController.clear();
    shortNameController.clear();
    setState(() { parent = '-'; type = 'Main Department'; allowAsset = true; active = true; });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F8FC),
    appBar: const AppHeader(title: 'Asset Management'),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(
                    widget.initialDepartment == null ? 'Department Register Form' : 'Edit Department',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF19366F)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Enter department information below', textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 28),
                  _twoColumns(
                    _field(label: 'Department Code', hint: 'Enter department code', controller: codeController),
                    _field(label: 'Department Name', hint: 'Enter department name', controller: nameController),
                  ),
                  const SizedBox(height: 18),
                  _twoColumns(
                    _field(label: 'Short Name', hint: 'Enter short name', controller: shortNameController, validator: (_) => null),
                    _dropdown(label: 'Department Type', hint: 'Select department type', items: departmentTypes, value: type, onChanged: (v) => setState(() => type = v ?? 'Main Department')),
                  ),
                  const SizedBox(height: 18),
                  _dropdown(label: 'Parent Department', hint: 'Select parent department',
                    items: ['-', ...departmentRecords.map((d) => d.name).where((n) => n != nameController.text.trim())],
                    value: parent, onChanged: (v) => setState(() => parent = v ?? '-')),
                  const SizedBox(height: 18),
                  Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Checkbox(value: allowAsset, onChanged: (v) => setState(() => allowAsset = v ?? false), activeColor: appBlue),
                      const Text('Allow Asset'),
                    ]),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Status'),
                      Switch(value: active, onChanged: (v) => setState(() => active = v), activeTrackColor: appBlue),
                      Text(active ? 'Active' : 'Inactive'),
                    ]),
                  ]),
                  const SizedBox(height: 20),
                  Wrap(alignment: WrapAlignment.center, spacing: 14, runSpacing: 10, children: [
                    SizedBox(width: 150, child: FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined, size: 18), label: const Text('Save Department'))),
                    SizedBox(width: 140, child: OutlinedButton.icon(onPressed: _clear, icon: const Icon(Icons.clear, size: 18), label: const Text('Clear Form'))),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class DepartmentEditDialog extends StatefulWidget {
  const DepartmentEditDialog({super.key});

  @override
  State<DepartmentEditDialog> createState() => _DepartmentEditDialogState();
}

class _DepartmentEditDialogState extends State<DepartmentEditDialog> {
  final keyForm = GlobalKey<FormState>();
  final code = TextEditingController();
  final name = TextEditingController();
  final shortName = TextEditingController();
  bool active = true;

  @override
  void dispose() {
    code.dispose();
    name.dispose();
    shortName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add Department'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: keyForm,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: code, decoration: appDecoration('Department Code'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter department code' : null),
          const SizedBox(height: 12),
          TextFormField(controller: name, decoration: appDecoration('Department Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter department name' : null),
          const SizedBox(height: 12),
          TextFormField(controller: shortName, decoration: appDecoration('Short Name')),
          SwitchListTile(title: const Text('Active'), value: active, onChanged: (v) => setState(() => active = v)),
        ]),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (!(keyForm.currentState?.validate() ?? false)) return;
        Navigator.pop(context, Department(code: code.text.trim(), name: name.text.trim(), shortName: shortName.text.trim(), active: active));
      }, child: const Text('Save')),
    ],
  );
}
