
class Department {
  final int? departmentId;
  final int? parentDeptId;
  final String? deptCode;
  final String deptName;
  final String deptShortName;
  final String deptType;
  final bool allowAssignment;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Department({
    this.departmentId,
    this.parentDeptId,
    this.deptCode,
    required this.deptName,
    required this.deptShortName,
    this.deptType = 'OPERATIONS',
    this.allowAssignment = true,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['department_id'] == null
          ? null
          : int.tryParse(json['department_id'].toString()),
      parentDeptId: json['parent_dept'] != null
          ? int.tryParse(json['parent_dept'].toString())
          : json['parent_dept_id'] == null
              ? null
              : int.tryParse(json['parent_dept_id'].toString()),
      deptCode: json['dept_code']?.toString(),
      deptName: json['dept_name']?.toString() ?? '',
      deptShortName: json['dept_short_name']?.toString() ?? '',
      deptType: json['dept_type']?.toString() ?? 'OPERATIONS',
      allowAssignment: json['allow_assignment'] != false,
      isActive: json['is_active'] != false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (departmentId != null) 'department_id': departmentId,
      'parent_dept': parentDeptId,
      'dept_code': deptCode,
      'dept_name': deptName,
      'dept_short_name': deptShortName,
      'dept_type': deptType,
      'allow_assignment': allowAssignment,
      'is_active': isActive,
    };
  }
}
