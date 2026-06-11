import 'package:flutter/material.dart';
import '../models/recent_repair_model.dart';
import '../app_theme.dart';

class NewRepairPage extends StatefulWidget {
  /// Called with the newly created repair so the caller can update its list
  final void Function(RecentRepairModel repair)? onRepairCreated;

  const NewRepairPage({super.key, this.onRepairCreated});

  @override
  State<NewRepairPage> createState() => _NewRepairPageState();
}

class _NewRepairPageState extends State<NewRepairPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _deviceController = TextEditingController();
  final _issueController = TextEditingController();

  bool _isSubmitting = false;

  // Static device suggestions — replace with API lookup later
  final List<String> _deviceSuggestions = [
    'NexCore Pro X1',
    'NexCore Tab Z',
    'NexCore Hub Lite',
    'NexCore Mini',
    'Custom Build',
  ];

  String? _selectedDevice;

  @override
  void dispose() {
    _customerController.dispose();
    _deviceController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // Simulate API call — replace with real POST later
    await Future.delayed(const Duration(milliseconds: 800));

    final newRepair = RecentRepairModel(
      id: 'RP-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _issueController.text.trim(),
      customerName: _customerController.text.trim(),
      device: _selectedDevice ?? _deviceController.text.trim(),
      status: RepairStatus.pending,
      date: DateTime.now(),
    );

    setState(() => _isSubmitting = false);

    widget.onRepairCreated?.call(newRepair);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('Repair ticket #${newRepair.id} created!',
                style: const TextStyle(color: Colors.white)),
          ]),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, newRepair);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('New Repair Ticket', style: AppTextStyles.headingSmall),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header Card ────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.build_outlined, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create Repair Ticket',
                            style: AppTextStyles.headingSmall.copyWith(color: Colors.white)),
                        Text('Fill in the customer details below',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Customer Name ──────────────────────────────
              _FieldLabel(label: 'Customer Name'),
              const SizedBox(height: 8),
              _InputField(
                controller: _customerController,
                hint: 'e.g. John Doe',
                icon: Icons.person_outline_rounded,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Customer name is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Device ─────────────────────────────────────
              _FieldLabel(label: 'Device'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Quick select chips
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _deviceSuggestions.map((d) {
                          final selected = _selectedDevice == d;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedDevice = selected ? null : d;
                              if (!selected) _deviceController.text = d;
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(d,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                )),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Divider(height: 1, color: AppColors.border),
                    // Or type manually
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: _deviceController,
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary),
                        onChanged: (v) =>
                            setState(() => _selectedDevice = null),
                        decoration: InputDecoration(
                          hintText: 'Or type device name...',
                          hintStyle: AppTextStyles.bodyMedium,
                          border: InputBorder.none,
                          icon: Icon(Icons.computer_outlined,
                              size: 18, color: AppColors.textMuted),
                        ),
                        validator: (v) =>
                            (_selectedDevice == null &&
                                    (v == null || v.trim().isEmpty))
                                ? 'Device is required'
                                : null,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Issue ──────────────────────────────────────
              _FieldLabel(label: 'Issue Description'),
              const SizedBox(height: 8),
              _InputField(
                controller: _issueController,
                hint: 'Describe the problem in detail...',
                icon: Icons.warning_amber_rounded,
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Issue description is required' : null,
              ),

              const SizedBox(height: 32),

              // ── Submit ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Create Repair Ticket',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared form sub-widgets ───────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
      style: AppTextStyles.headingSmall.copyWith(fontSize: 13));
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines > 1 ? 14 : 0,
        ),
      ),
    );
  }
}