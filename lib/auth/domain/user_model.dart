class UserModel {
  final String userId;
  final String roleId;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String createdAt;
  final bool isActive;

  const UserModel({
    required this.userId,
    required this.roleId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.createdAt,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    
    return UserModel(
      userId: json['userId']?.toString() ?? '',
      roleId: json['roleId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      isActive: json['isActive'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roleId': roleId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  static UserModel? fromDbJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        userId: json['user_id']?.toString() ?? '',
        roleId: json['role_id']?.toString() ?? 'customer',
        fullName: json['full_name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        avatarUrl: json['avatar_url']?.toString(),
        createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
        isActive: (json['is_active'] as int?) == 1,
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toDbJson() {
    return {
      'user_id': userId,
      'role_id': roleId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'created_at': createdAt,
      'is_active': isActive ? 1 : 0,
    };
  }
}
