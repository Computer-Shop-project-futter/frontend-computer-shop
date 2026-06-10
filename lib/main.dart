<<<<<<< HEAD
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
=======
import 'package:computer_shop/features/dashboard/app_theme.dart';
import 'package:computer_shop/features/dashboard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StaffDashboardApp());
}

class StaffDashboardApp extends StatelessWidget {
  const StaffDashboardApp({super.key});
>>>>>>> origin/sedtha

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'G14 Tech Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeShell(),
    );
  }
}
=======
      title: 'Staff Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DashboardPage(),
    );
  }
}
>>>>>>> origin/sedtha
