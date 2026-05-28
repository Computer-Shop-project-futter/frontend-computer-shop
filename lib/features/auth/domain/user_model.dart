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
}
