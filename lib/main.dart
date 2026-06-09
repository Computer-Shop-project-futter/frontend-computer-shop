// ─────────────────────────────────────────────
//  G14 Admin — Entry Point
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'admin/home_shell.dart';
import 'data/app_theme.dart';


void main() {
  runApp(const G14AdminApp());
}

class G14AdminApp extends StatelessWidget {
  const G14AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G14 Tech Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeShell(),
    );
  }
}
