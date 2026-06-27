import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class EmailConfirmationPage extends ConsumerStatefulWidget {
  const EmailConfirmationPage({super.key});

  @override
  ConsumerState<EmailConfirmationPage> createState() => _EmailConfirmationPageState();
}

class _EmailConfirmationPageState extends ConsumerState<EmailConfirmationPage> {
  String _status = 'Processing confirmation...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleConfirmation());
  }

  Future<void> _handleConfirmation() async {
    try {
      // For web redirects Supabase may have populated session automatically.
      // Try to refresh/check auth state.
      final ok = await ref.read(authProvider.notifier).checkAuth();
      if (ok) {
        setState(() => _status = 'Email confirmed — you are signed in. Redirecting...');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) context.go('/home');
        return;
      }

      // If not signed in, show instruction
      setState(() => _status = 'Email confirmed. Please sign in to continue.');
    } catch (e) {
      setState(() => _status = 'Confirmation processing failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email confirmation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 64, color: Colors.green),
              const SizedBox(height: 12),
              Text(_status, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
