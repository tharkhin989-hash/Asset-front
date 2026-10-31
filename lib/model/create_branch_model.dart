class Branch {
  final int? branchId;
  final int countryId;
  final String? branchCode;
  final String branchName;
  final String? region;
  final String? city;
  final String? address;
  final String? phone;
  final String? email;
  final int? postalCode;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;

  Branch({
    this.branchId,
    required this.countryId,
    this.branchCode,
    required this.branchName,
    this.region,
    this.city,
    this.address,
    this.phone,
    this.email,
    this.postalCode,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  // JSON to Dart Object
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchId: json['branch_id'] as int?,
      countryId: json['country'] is Map
          ? json['country']['country_id'] as int
          : (json['country'] ?? json['country_id']) as int,
      branchCode: json['branch_code'] as String?,
      branchName: json['branch_name'] as String,
      region: json['region'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      postalCode: json['postal_code'] == null
          ? null
          : int.tryParse(json['postal_code'].toString()),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
    );
  }

  // Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      if (branchId != null) 'branch_id': branchId,
      'country': countryId,
      'branch_code': branchCode,
      'branch_name': branchName,
      'region': region,
      'city': city,
      'address': address,
      'phone': phone,
      'email': email,
      'postal_code': postalCode,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}