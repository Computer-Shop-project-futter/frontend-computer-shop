import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'home/presentation/pages/home_page.dart';
import 'products/presentation/pages/product_detail_page.dart';
import 'products/presentation/pages/product_listing_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Computer Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListingPage(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) => ProductDetailPage(
        productId: state.pathParameters['id'] ?? '',
      ),
    ),
  ],
);

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light().textTheme;
    final display = base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontFamily: 'Syne'),
      displayMedium: base.displayMedium?.copyWith(fontFamily: 'Syne'),
      displaySmall: base.displaySmall?.copyWith(fontFamily: 'Syne'),
      headlineLarge: base.headlineLarge?.copyWith(fontFamily: 'Syne'),
      headlineMedium: base.headlineMedium?.copyWith(fontFamily: 'Syne'),
      headlineSmall: base.headlineSmall?.copyWith(fontFamily: 'Syne'),
      titleLarge: base.titleLarge?.copyWith(fontFamily: 'Syne'),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFAF9F7),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1A1917),
        brightness: Brightness.light,
      ),
      fontFamily: 'DMSans',
      textTheme: display.apply(
        bodyColor: const Color(0xFF1A1917),
        displayColor: const Color(0xFF1A1917),
      ),
    );
  }
}
