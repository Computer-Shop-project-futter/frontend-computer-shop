import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';

/// Staff profile data shared across dashboard pages
class StaffProfile {
  final String staffId;
  final String name;
  final String email;
  final String phone;
  final String branch;
  final String? avatarBase64; // Base64 encoded image bytes
  final String? avatarInitials;

  const StaffProfile({
    this.staffId = 'STF-001',
    this.name = 'Alex Rivers',
    this.email = 'alex.rivers@nexcore.com',
    this.phone = '+1 (555) 123-4567',
    this.branch = 'Downtown Flagship',
    this.avatarBase64,
    this.avatarInitials,
  });

  StaffProfile copyWith({
    String? staffId,
    String? name,
    String? email,
    String? phone,
    String? branch,
    String? avatarBase64,
    String? avatarInitials,
  }) {
    return StaffProfile(
      staffId: staffId ?? this.staffId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      branch: branch ?? this.branch,
      avatarBase64: avatarBase64 ?? this.avatarBase64,
      avatarInitials: avatarInitials ?? this.avatarInitials,
    );
  }

  String get initials {
    if (avatarInitials != null) return avatarInitials!;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'S';
  }
}

/// Singleton store for staff profile data.
/// Notifies listeners when profile changes so UI updates reactively.
class StaffProfileStore extends ChangeNotifier {
  static final StaffProfileStore _instance = StaffProfileStore._();
  factory StaffProfileStore() => _instance;
  StaffProfileStore._();

  StaffProfile _profile = const StaffProfile();

  StaffProfile get profile => _profile;

  String get staffName => _profile.name;
  String get branchName => _profile.branch;
  String get initials => _profile.initials;

  /// Update the full profile
  void updateProfile(StaffProfile newProfile) {
    _profile = newProfile;
    notifyListeners();
  }

  /// Update avatar with base64 encoded image bytes
  void updateAvatar(Uint8List imageBytes) {
    final base64 = base64Encode(imageBytes);
    _profile = _profile.copyWith(avatarBase64: base64);
    notifyListeners();
  }

  /// Update profile fields
  void updateFields({
    String? name,
    String? email,
    String? phone,
    String? branch,
  }) {
    _profile = _profile.copyWith(
      name: name,
      email: email,
      phone: phone,
      branch: branch,
    );
    notifyListeners();
  }
}