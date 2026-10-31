
import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/get_custodian_model.dart';
import 'package:flutter_project_exe/screen/custodian_form.dart';
import 'package:flutter_project_exe/service/api_service.dart';

class CustodianLimport 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_custodain_model.dart';
import 'custodian_form.dart';

class CustodianTable extends StatefulWidget {
  final List<Custodian> custodians;
  final Function(Custodian) onAdd;
  final Function(Custodian) onUpdate;
  final Function(int) onDelete;

  const CustodianTable({
    super.key,
    required this.custodians,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<CustodianTable> createState() => _CustodianTableState();
}

class _CustodianTableState extends State<CustodianTable> {
  void openForm({Custodian? custodian}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustodianForm(
          custodian: custodian,
          onSubmit: custodian == null
              ? widget.onAdd
              : widget.onUpdate,
        ),
      ),
    );
  }

  void deleteCustodian(Custodian custodian) {
    if (custodian.custodianId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete: Custodian ID is missing'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Custodian'),
        content: Text(
          'Delete ${custodian.custodianName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              widget.onDelete(custodian.custodianId!);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custodian Management'),
        actions: [
          IconButton(
            onPressed: () => openForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Add Custodian',
          ),
        ],
      ),
      body: widget.custodians.isEmpty
          ? const Center(child: Text('No custodians found'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Branch ID')),
                    DataColumn(label: Text('Dept ID')),
                    DataColumn(label: Text('Code')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Hold Assets')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: widget.custodians.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${c.custodianId ?? '-'}')),
                        DataCell(Text('${c.branchId ?? '-'}')),
                        DataCell(Text('${c.deptId ?? '-'}')),
                        DataCell(Text(c.custodianCode ?? '-')),
                        DataCell(Text(c.custodianName)),
                        DataCell(Text(c.custodianType)),
                        DataCell(Text(c.phone ?? '-')),
                        DataCell(Text(c.email ?? '-')),
                        DataCell(
                          Icon(
                            c.canHoldAssets
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: c.canHoldAssets
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        DataCell(
                          Icon(
                            c.isActive
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: c.isActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Edit',
                                onPressed: () =>
                                    openForm(custodian: c),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Delete',
                                onPressed: () => deleteCustodian(c),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}ist extends StatefulWidget {
  final VoidCallback? onDownloadPdf;

  const CustodianList({
    super.key,
    this.onDownloadPdf,
  });

  @override
  State<CustodianList> createState() => _CustodianListState();
}

class _CustodianListState extends State<CustodianList> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController =
      TextEditingController();

  List<Custodian> custodians = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedStatus = 'All';
  int currentPage = 0;
  final int rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    loadCustodians();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadCustodians() async {
    setState(() => isLoading = true);

    try {
      final data = await _apiService.fetchCustodians();

      if (!mounted) return;

      setState(() {
        custodians = data;
        isLoading = false;
        currentPage = 0;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load custodians: $e')),
      );
    }
  }

  List<Custodian> get filteredCustodians {
    return custodians.where((item) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          (item.custodianCode ?? '').toLowerCase().contains(query) ||
          item.custodianName.toLowerCase().contains(query) ||
          (item.email ?? '').toLowerCase().contains(query);

      final matchesStatus = selectedStatus == 'All' ||
          (selectedStatus == 'Active' && item.isActive) ||
          (selectedStatus == 'Inactive' && !item.isActive);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> deleteCustodian(Custodian item) async {
    if (item.custodianId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custodian'),
        content: const Text('Are you sure you want to delete this custodian?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _apiService.deleteCustodian(item.custodianId!);
      await loadCustodians();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custodian deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  Future<void> updateStatus(Custodian item, bool value) async {
    if (item.custodianId == null) return;

    try {
      await _apiService.updateCustodianStatus(
        item.custodianId!,
        value,
      );

      await loadCustodians();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status update failed: $e')),
      );
    }
  }

  Future<void> openAddForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustodianFormScreen(),
      ),
    );

    if (result == true) {
      await loadCustodians();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredCustodians;
    final totalPages = (data.length / rowsPerPage).ceil();

    final safePage = totalPages == 0
        ? 0
        : currentPage.clamp(0, totalPages - 1);

    final start = safePage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);

    final pageData = data.sublist(start, end);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custodian List'),
        actions: [
          IconButton(
            onPressed: loadCustodians,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Custodian',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        currentPage = 0;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All'),
                      ),
                      DropdownMenuItem(
                        value: 'Active',
                        child: Text('Active'),
                      ),
                      DropdownMenuItem(
                        value: 'Inactive',
                        child: Text('Inactive'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value ?? 'All';
                        currentPage = 0;
                      });
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: openAddForm,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'),
                ),
                OutlinedButton.icon(
                  onPressed: widget.onDownloadPdf,
                  icon: const Icon(Icons.download),
                  label: const Text('Download PDF'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : data.isEmpty
                      ? const Center(
                          child: Text('No custodian data found'),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Code')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Phone')),
                                DataColumn(label: Text('Branch ID')),
                                DataColumn(label: Text('Department ID')),
                                DataColumn(label: Text('Can Hold Assets')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: pageData.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item.custodianCode ?? '')),
                                    DataCell(Text(item.custodianName)),
                                    DataCell(Text(item.custodianType)),
                                    DataCell(Text(item.email ?? '')),
                                    DataCell(Text(item.phone ?? '')),
                                    DataCell(Text(item.branch?.toString() ?? '-')),
                                    DataCell(Text(item.dept?.toString() ?? '-')),
                                    DataCell(
                                      Text(item.canHoldAssets ? 'Yes' : 'No'),
                                    ),
                                    DataCell(
                                      Switch(
                                        value: item.isActive,
                                        onChanged: (value) {
                                          updateStatus(item, value);
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteCustodian(item);
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
            if (!isLoading && data.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Page ${safePage + 1} of $totalPages',
                  ),
                  IconButton(
                    onPressed: safePage > 0
                        ? () => setState(() => currentPage--)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: safePage < totalPages - 1
                        ? () => setState(() => currentPage++)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
