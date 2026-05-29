import 'package:computer_shop/features/dashboard/app_theme.dart';
import 'package:computer_shop/features/dashboard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StaffDashboardApp());
}

class StaffDashboardApp extends StatelessWidget {
  const StaffDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DashboardPage(),
    );
  }
}