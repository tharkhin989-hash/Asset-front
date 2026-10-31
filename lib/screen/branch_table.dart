import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_branch_model.dart';
import 'branch_form.dart';

class BranchTable extends StatefulWidget {
  final List<Branch> branches;
  final Function(Branch) onAdd;
  final Function(Branch) onUpdate;
  final Function(int) onDelete;

  const BranchTable({
    super.key,
    required this.branches,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<BranchTable> createState() => _BranchTableState();
}

class _BranchTableState extends State<BranchTable> {
  void openForm({Branch? branch}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BranchForm(
          branch: branch,
          onSubmit: branch == null ? widget.onAdd : widget.onUpdate,
        ),
      ),
    );
  }

  void confirmDelete(Branch branch) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Branch'),
        content: Text(
          'Are you sure you want to delete ${branch.branchName}?',
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
              if (branch.branchId != null) {
                widget.onDelete(branch.branchId!);
              }
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
        title: const Text('Branch Management'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => openForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Add Branch',
          ),
        ],
      ),
      body: widget.branches.isEmpty
          ? const Center(child: Text('No branches found'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Country ID')),
                    DataColumn(label: Text('Branch Code')),
                    DataColumn(label: Text('Branch Name')),
                    DataColumn(label: Text('City')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: widget.branches.map((branch) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${branch.branchId ?? '-'}')),
                        DataCell(Text('${branch.countryId}')),
                        DataCell(Text(branch.branchCode ?? '-')),
                        DataCell(Text(branch.branchName)),
                        DataCell(Text(branch.city ?? '-')),
                        DataCell(Text(branch.phone ?? '-')),
                        DataCell(
                          Icon(
                            branch.isActive
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: branch.isActive
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
                                onPressed: () => openForm(branch: branch),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => confirmDelete(branch),
                                tooltip: 'Delete',
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
}