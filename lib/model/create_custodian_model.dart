class Custodian {
  final int? custodianId;
  final int? branchId;
  final int? deptId;
  final String? custodianCode;
  final String custodianName;
  final String custodianType;
  final String? phone;
  final String? email;
  final bool canHoldAssets;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Custodian({
    this.custodianId,
    this.branchId,
    this.deptId,
    this.custodianCode,
    required this.custodianName,
    this.custodianType = 'SUPPLIER',
    this.phone,
    this.email,
    this.canHoldAssets = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Custodian.fromJson(Map<String, dynamic> json) {
    return Custodian(
      custodianId: json['custodian_id'] == null
          ? null
          : int.tryParse(json['custodian_id'].toString()),
      branchId: json['branch'] == null
          ? (json['branch_id'] == null
              ? null
              : int.tryParse(json['branch_id'].toString()))
          : int.tryParse(json['branch'].toString()),
      deptId: json['dept'] == null
          ? (json['dept_id'] == null
              ? null
              : int.tryParse(json['dept_id'].toString()))
          : int.tryParse(json['dept'].toString()),
      custodianCode: json['custodian_code'] as String?,
      custodianName: json['custodian_name'] as String? ?? '',
      custodianType: json['custodian_type'] as String? ?? 'SUPPLIER',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      canHoldAssets: json['can_hold_assets'] == true,
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
      if (custodianId != null) 'custodian_id': custodianId,
      'branch': branchId,
      'dept': deptId,
      'custodian_code': custodianCode,
      'custodian_name': custodianName,
      'custodian_type': custodianType,
      'phone': phone,
      'email': email,
      'can_hold_assets': canHoldAssets,
      'is_active': isActive,
    };
  }
}