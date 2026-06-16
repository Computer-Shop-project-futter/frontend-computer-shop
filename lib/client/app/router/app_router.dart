// App routing configuration (GoRouter).
import 'package:computer_shop/client/app/router/product_route.dart';
import 'package:computer_shop/client/features/compare/presentation/pages/product_compare_page.dart';
import 'package:computer_shop/client/features/favorites/presentation/pages/wishlist_page.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:computer_shop/auth/presentation/pages/splash_page.dart';
import 'package:computer_shop/auth/presentation/pages/login_page.dart';
import 'package:computer_shop/auth/presentation/pages/register_page.dart';
import 'package:computer_shop/auth/presentation/pages/check_email_page.dart';
import 'package:computer_shop/auth/presentation/pages/email_confirmation_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/product_listing_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
// import '../../features/products/presentation/pages/product_builder_page.dart';
// later you will import home page too
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/pc_builder/presentation/pages/my_builds_page.dart';
import '../../features/pc_builder/presentation/pages/build_editor_page.dart';
import 'route_splash.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../features/repair/presentation/pages/repair_page.dart';
import '../../features/coupons/presentation/pages/coupon_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: splashRoute.splash ,

    routes: [
      GoRoute(
        path: splashRoute.splash,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: splashRoute.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: splashRoute.register,
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: '/login/check-email',
        builder: (context, state) => CheckEmailPage(
          email: state.uri.queryParameters['email'],
        ),
      ),

      GoRoute(
        path: '/register/check-email',
        builder: (context, state) => CheckEmailPage(
          email: state.uri.queryParameters['email'],
        ),
      ),

      GoRoute(
        path: '/login/confirm',
        builder: (context, state) => const EmailConfirmationPage(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),

      // Products
      GoRoute(
        path: ProductRoutes.products,
        builder: (_, __) => const ProductListingPage(),
      ),

      GoRoute(
        path: ProductRoutes.productDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),

      // Compare Route
      GoRoute(
        path: ProductRoutes.compare,
        builder: (context, state) {
          final ids = state.uri.queryParameters['ids']?.split(',') ?? [];
          return ProductComparePage(productIds: ids);
        },
      ),

      // Wishlist Route - Add this
      GoRoute(path: '/wishlist', builder: (_, __) => const WishlistPage()),
      GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      // Add more routes as neede
      GoRoute(
        path: '/builder',
        builder: (context, state) => const MyBuildsPage(),
      ),
      GoRoute(
        path: '/builder/edit',
        builder: (context, state) => const BuildEditorPage(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(path: '/repair', builder: (context, state) => const RepairPage()),
      // Coupon route
      GoRoute(
        path: '/coupon',
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return CouponPage(productId: productId);
        },
      ),
    ],
  );

  static GlobalKey<ScaffoldMessengerState>? get scaffoldMessengerKey => null;
}

