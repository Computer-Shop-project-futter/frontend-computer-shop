import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_theme.dart';
import '../models/staff_profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _store = StaffProfileStore();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _branchController = TextEditingController();
  bool _isEditing = false;
  Uint8List? _pendingAvatarBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _syncFromStore();
    _store.addListener(_syncFromStore);
  }

  @override
  void dispose() {
    _store.removeListener(_syncFromStore);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  void _syncFromStore() {
    final p = _store.profile;
    _nameController.text = p.name;
    _emailController.text = p.email;
    _phoneController.text = p.phone;
    _branchController.text = p.branch;
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveProfile() {
    _store.updateFields(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      branch: _branchController.text.trim(),
    );
    if (_pendingAvatarBytes != null) {
      _store.updateAvatar(_pendingAvatarBytes!);
      _pendingAvatarBytes = null;
    }
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Profile updated successfully!',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickImage() async {
    _showAvatarOptions();
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pendingAvatarBytes = bytes;
      });
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pendingAvatarBytes = bytes;
      });
      if (mounted) Navigator.pop(context);
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Profile Picture',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // ── Upload from Gallery ──
            _AvatarOptionTile(
              icon: Icons.photo_library_outlined,
              iconColor: AppColors.primary,
              bgColor: AppColors.primarySoft,
              title: 'Gallery',
              subtitle: 'Choose from your photo library',
              onTap: _pickFromGallery,
            ),
            const SizedBox(height: 12),
            // ── Take Photo ──
            _AvatarOptionTile(
              icon: Icons.camera_alt_outlined,
              iconColor: AppColors.success,
              bgColor: AppColors.successSoft,
              title: 'Camera',
              subtitle: 'Take a photo right now',
              onTap: _pickFromCamera,
            ),
            const SizedBox(height: 12),
            // ── Use Initials ──
            _AvatarOptionTile(
              icon: Icons.person_pin_rounded,
              iconColor: AppColors.warning,
              bgColor: AppColors.warningSoft,
              title: 'Use Initials',
              subtitle: 'Display your name initials',
              onTap: () {
                _store.updateProfile(
                  _store.profile.copyWith(
                    avatarBase64: null,
                    avatarInitials: null,
                  ),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: const Text(
                      'Avatar updated from your name initials',
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _store.profile;
    final hasAvatar = _pendingAvatarBytes != null || profile.avatarBase64 != null;
    ImageProvider? avatarImage;
    if (_pendingAvatarBytes != null) {
      avatarImage = MemoryImage(_pendingAvatarBytes!);
    } else if (profile.avatarBase64 != null) {
      avatarImage = MemoryImage(
        base64Decode(profile.avatarBase64!),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile', style: AppTextStyles.headingSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _isEditing ? _saveProfile : _toggleEdit,
              icon: Icon(
                _isEditing ? Icons.save_rounded : Icons.edit_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              label: Text(
                _isEditing ? 'Save' : 'Edit',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar (tappable for upload) ──────────────────────
            GestureDetector(
              onTap: _isEditing ? _pickImage : null,
              child: Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: hasAvatar
                          ? null
                          : const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: hasAvatar
                          ? DecorationImage(
                              image: avatarImage!,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: hasAvatar
                        ? null
                        : Center(
                            child: Text(
                              profile.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Staff Member',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 28),

            // ── Profile Fields ──────────────────────────────────
            _ProfileField(
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
              controller: _nameController,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Email Address',
              icon: Icons.email_outlined,
              controller: _emailController,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Branch',
              icon: Icons.store_outlined,
              controller: _branchController,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AvatarOptionTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;

  const _ProfileField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.enabled,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: enabled
                    ? TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        controller.text,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
              ),
              if (!enabled)
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ],
      ),
    );
  }
}