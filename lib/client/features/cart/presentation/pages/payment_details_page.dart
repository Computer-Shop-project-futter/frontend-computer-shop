// lib/features/checkout/presentation/pages/payment_details_page.dart
//
// New payment step shown after the existing checkout (details/shipping/
// payment-method) form. Collects card details and hands off to the
// order confirmation page. This page is full-screen (outside MainShell)
// to match the dedicated step-by-step checkout flow design.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/checkout_provider.dart';

class PaymentDetailsPage extends ConsumerStatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  ConsumerState<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends ConsumerState<PaymentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _cardholderCtrl = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _cardholderCtrl.dispose();
    super.dispose();
  }

  String get _maskedDigits {
    final digits = _cardNumberCtrl.text.replaceAll(' ', '');
    if (digits.isEmpty) return '•••• •••• •••• ••••';
    final last4 = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
    return '•••• •••• •••• $last4';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final notifier = ref.read(checkoutProvider.notifier);
    await notifier.processOrder();

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final error = ref.read(checkoutProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    if (mounted) {
      context.go('/checkout/confirmation');
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _PaymentTopBar(onBack: () => context.pop()),
            const _StepIndicator(activeStep: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10213B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Complete your order securely',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7891),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _CardPreview(
                        maskedNumber: _maskedDigits,
                        cardholder: _cardholderCtrl.text.trim().isEmpty
                            ? 'YOUR NAME'
                            : _cardholderCtrl.text.trim().toUpperCase(),
                        expiry: _expiryCtrl.text.isEmpty ? 'MM/YY' : _expiryCtrl.text,
                      ),
                      const SizedBox(height: 24),

                      _FieldLabel('Cardholder Name'),
                      const SizedBox(height: 6),
                      _PaymentTextField(
                        controller: _cardholderCtrl,
                        hint: 'Name on card',
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),

                      _FieldLabel('Card Number'),
                      const SizedBox(height: 6),
                      _PaymentTextField(
                        controller: _cardNumberCtrl,
                        hint: '0000 0000 0000 0000',
                        keyboardType: TextInputType.number,
                        suffixIcon: Icons.lock_outline,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _CardNumberFormatter(),
                        ],
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          final digits = (v ?? '').replaceAll(' ', '');
                          if (digits.length < 16) return 'Enter a valid card number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel('Expiry'),
                                const SizedBox(height: 6),
                                _PaymentTextField(
                                  controller: _expiryCtrl,
                                  hint: 'MM/YY',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    _ExpiryDateFormatter(),
                                  ],
                                  onChanged: (_) => setState(() {}),
                                  validator: (v) {
                                    if (v == null || v.length < 5) return 'Invalid';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel('CVV'),
                                const SizedBox(height: 6),
                                _PaymentTextField(
                                  controller: _cvvCtrl,
                                  hint: '•••',
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  suffixIcon: Icons.help_outline,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: (v) {
                                    if (v == null || v.length < 3) return 'Invalid';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_outlined, size: 18, color: Color(0xFF2A66FF)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This is a secure checkout environment. Your data is encrypted with enterprise-grade protection protocols by NexCore Gateway.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF3E5C99),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky footer: order total + place order button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ORDER TOTAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Color(0xFF6B7891),
                        ),
                      ),
                      Text(
                        '\$${checkoutState.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10213B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A66FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar: back arrow + brand pill ───────────────
class _PaymentTopBar extends StatelessWidget {
  final VoidCallback onBack;
  const _PaymentTopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8ECF3))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF10213B)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2A66FF), width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10213B),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'G',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'G14-TECH',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Color(0xFF10213B),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ── Step indicator: CART — DETAILS — CONFIRM ───────
class _StepIndicator extends StatelessWidget {
  final int activeStep; // 0 = cart, 1 = details, 2 = confirm
  const _StepIndicator({required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(
        children: [
          _Step(label: 'CART', isActive: activeStep == 0, isDone: activeStep > 0),
          _StepConnector(isDone: activeStep > 0),
          _Step(label: 'DETAILS', isActive: activeStep == 1, isDone: activeStep > 1),
          _StepConnector(isDone: activeStep > 1),
          _Step(label: 'CONFIRM', isActive: activeStep == 2, isDone: false),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDone;
  const _Step({required this.label, required this.isActive, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final color = (isActive || isDone) ? const Color(0xFF2A66FF) : const Color(0xFFC4CCDA);
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.white,
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isDone;
  const _StepConnector({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 2,
          color: isDone ? const Color(0xFF2A66FF) : const Color(0xFFE5E9F0),
        ),
      ),
    );
  }
}

// ── Card preview ────────────────────────────────────
class _CardPreview extends StatelessWidget {
  final String maskedNumber;
  final String cardholder;
  final String expiry;

  const _CardPreview({
    required this.maskedNumber,
    required this.cardholder,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10213B), Color(0xFF0B1830)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10213B).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TITANIUM CARD',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.white70,
                ),
              ),
              Container(
                width: 30,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.wifi, size: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Text(
            maskedNumber,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARDHOLDER',
                    style: TextStyle(fontSize: 8, color: Colors.white54, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cardholder,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(fontSize: 8, color: Colors.white54, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expiry,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared field label ───────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: Color(0xFF6B7891),
      ),
    );
  }
}

// ── Payment text field ───────────────────────────────
class _PaymentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const _PaymentTextField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF10213B)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFC4CCDA)),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, size: 18, color: const Color(0xFF6B7891)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A66FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}

// ── Formatters ───────────────────────────────────────

/// Inserts a space every 4 digits: "4242424242424242" -> "4242 4242 4242 4242"
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Inserts a slash after 2 digits: "1228" -> "12/28"
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}