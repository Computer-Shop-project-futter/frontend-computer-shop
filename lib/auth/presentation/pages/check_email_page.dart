import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class CheckEmailPage extends ConsumerStatefulWidget {
  final String? email;

  const CheckEmailPage({super.key, this.email});

  @override
  ConsumerState<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends ConsumerState<CheckEmailPage>
    with SingleTickerProviderStateMixin {
  static const int _codeLength = 5;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  final List<TextEditingController> _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_codeLength, (_) => FocusNode());

  bool _isLoading = false;
  bool _hasError = false;
  Timer? _resendTimer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationCode();
      _startResendCountdown();
    });
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _canResend = true;
        });
        return;
      }

      setState(() {
        _secondsRemaining -= 1;
      });
    });
  }

  Future<void> _sendVerificationCode() async {
    final email = widget.email?.trim();
    if (email == null || email.isEmpty) {
      return;
    }

    try {
      await ref.read(authProvider.notifier).resendSignupVerification(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent to your address.'),
            backgroundColor: Color(0xFF2A66FF),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending verification email: $e')),
        );
      }
    }
  }

  Future<void> _confirmLinkUsed() async {
    setState(() => _isLoading = true);
    final confirmed = await ref.read(authProvider.notifier).checkAuth();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (confirmed) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not yet confirmed. Please click the link in your email.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _controller.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullCode =>
      _controllers.map((c) => c.text).join();

  bool get _isComplete => _fullCode.length == _codeLength;

  void _onDigitChanged(String value, int index) {
    setState(() => _hasError = false);

    if (value.length == 1 && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_isComplete) _verify();
  }

  Future<void> _verify() async {
    setState(() => _isLoading = true);
    final email = widget.email?.trim();
    if (email == null || email.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is missing for verification.')),
      );
      return;
    }

    final code = _fullCode;
    try {
      final success = await ref.read(authProvider.notifier).verifySignupCode(email, code);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (success) {
        if (mounted) {
          context.go('/home');
        }
      } else {
        setState(() => _hasError = true);
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _clearCode() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() => _hasError = false);
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF4F46E5);
    const indigoLight = Color(0xFFEEF2FF);
    const errorColor = Color(0xFFEF4444);
    const errorLight = Color(0xFFFEF2F2);
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF6B7280);
    const dividerColor = Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: textSecondary),
          onPressed: () => context.go('/login'),
          tooltip: 'Back to Login',
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // Icon badge
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: indigoLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_rounded,
                        size: 40,
                        color: indigo,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Headline + subtitle
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Confirm your email',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'A confirmation email has been sent to ${widget.email ?? 'your email'}.\nOpen the message and click the link to confirm your account.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.email != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.email!,
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 8),
                      const Text(
                        'If you received a 5-digit code instead of a link, enter it below. Otherwise click the link in your email and then tap "I have confirmed".',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // OTP boxes
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_codeLength, (i) {
                          final isFocused = _focusNodes[i].hasFocus;
                          final isFilled = _controllers[i].text.isNotEmpty;

                          return SizedBox(
                            width: 56,
                            height: 64,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: _hasError
                                    ? errorLight
                                    : isFilled
                                        ? indigoLight
                                        : const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _hasError
                                      ? errorColor
                                      : isFocused
                                          ? indigo
                                          : isFilled
                                              ? indigo.withOpacity(0.4)
                                              : const Color(0xFFE5E7EB),
                                  width: isFocused ? 2 : 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: _controllers[i],
                                focusNode: _focusNodes[i],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: _hasError ? errorColor : textPrimary,
                                  height: 1,
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (v) => _onDigitChanged(v, i),
                                onTap: () => setState(() {}),
                              ),
                            ),
                          );
                        }),
                      ),

                      // Error message
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _hasError
                            ? Padding(
                                key: const ValueKey('error'),
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.error_outline_rounded,
                                        size: 14, color: errorColor),
                                    SizedBox(width: 6),
                                    Text(
                                      'Incorrect code. Please try again.',
                                      style: TextStyle(
                                          fontSize: 13, color: errorColor),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(key: ValueKey('no-error')),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // CTA area
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        onPressed: _isComplete && !_isLoading ? _verify : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: indigo,
                          disabledBackgroundColor:
                              indigo.withOpacity(0.35),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Verify'),
                      ),
                      if (_hasError) ...[
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: _clearCode,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textSecondary,
                            minimumSize: const Size.fromHeight(48),
                            side: const BorderSide(color: dividerColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Clear & try again'),
                        ),
                      ],
                      const SizedBox(height: 4),
                      const Divider(color: dividerColor, height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _canResend
                                ? "Didn't get it? "
                                : 'Resend available in $_secondsRemaining s',
                            style:
                                TextStyle(fontSize: 14, color: textSecondary),
                          ),
                          if (_canResend) ...[
                            GestureDetector(
                              onTap: () async {
                                final email = widget.email?.trim();
                                if (email == null || email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Email is missing.')),
                                  );
                                  return;
                                }
                                try {
                                  await _sendVerificationCode();
                                  if (!mounted) return;
                                  _startResendCountdown();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Verification email resent. Check your inbox.')),
                                  );
                                } catch (error) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error is Exception ? error.toString().replaceFirst('Exception: ', '') : error.toString())),
                                  );
                                }
                              },
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: indigo,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _isLoading ? null : _confirmLinkUsed,
                        style: FilledButton.styleFrom(
                          backgroundColor: indigo,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('I have confirmed'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}