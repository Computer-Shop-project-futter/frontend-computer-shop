// App routing configuration (GoRouter).
import 'package:computer_shop/client/app/router/product_route.dart';
import 'package:computer_shop/client/features/cart/presentation/pages/order_confirmation_page.dart';
import 'package:computer_shop/client/features/cart/presentation/pages/payment_details_page.dart';
import 'package:computer_shop/client/features/compare/presentation/pages/product_compare_page.dart';
import 'package:computer_shop/client/features/favorites/presentation/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:computer_shop/auth/presentation/pages/splash_page.dart';
import 'package:computer_shop/auth/presentation/pages/login_page.dart';
import 'package:computer_shop/auth/presentation/pages/register_page.dart';
import 'package:computer_shop/auth/presentation/pages/check_email_page.dart';
import 'package:computer_shop/auth/presentation/pages/email_confirmation_page.dart';
import 'package:computer_shop/admin/home_shell.dart';
import 'package:computer_shop/satf/features/dashboard/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/product_listing_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/pc_builder/presentation/pages/my_builds_page.dart';
import '../../features/pc_builder/presentation/pages/build_editor_page.dart';
import 'route_splash.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../features/repair/presentation/pages/repair_page.dart';
import '../../features/coupons/presentation/pages/coupon_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/staff_list_page.dart';
import '../../features/chat/domain/staff/staff_model.dart';
import 'main_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: splashRoute.splash,

    routes: [
      // --- Auth / splash routes (full-screen, no shell) ---
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

      // --- Admin routes ---
      GoRoute(
        path: '/admin',
        builder: (context, state) => const HomeShell(),
      ),

      // --- Staff routes ---
      GoRoute(
        path: '/staff',
        builder: (context, state) => const DashboardPage(),
      ),

      // --- Full-screen routes (no shell/persistent header+footer) ---
      // Coupon page - full screen with its own layout
      GoRoute(
        path: '/coupon',
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return CouponPage(productId: productId);
        },
      ),

      // Chat support: staff selection list (full screen with AppBar)
      GoRoute(
        path: '/chat',
        builder: (context, state) => const StaffListPage(),
      ),

      // Chat with a specific staff member (full screen with AppBar)
      GoRoute(
        path: '/chat/:staffUserId',
        builder: (context, state) {
          final staffUserId = state.pathParameters['staffUserId']!;
          final staff = state.extra as StaffModel?;
          return ChatPage(
            staff: staff,
            staffUserId: staffUserId,
          );
        },
      ),

       GoRoute(
        path: '/checkout/payment',
        builder: (context, state) => const PaymentDetailsPage(),
      ),

      // Checkout: order confirmation (full screen, no persistent header/footer)
      GoRoute(
        path: '/checkout/confirmation',
        builder: (context, state) => const OrderConfirmationPage(),
      ),

      // --- Main app shell (persistent header + footer + drawer) ---
      ShellRoute(
        builder: (context, state, child) {
          // Determine current bottom nav index based on the matched location
          final int currentIndex = MainShell.indexForRoute(state.matchedLocation);
          final bool isCompareRoute = state.matchedLocation.startsWith(ProductRoutes.compare);
          return MainShell(
            currentIndex: currentIndex,
            showBack: isCompareRoute,
            onBackPressed: isCompareRoute ? () => context.go(ProductRoutes.products) : null,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),

          // Products listing
          GoRoute(
            path: ProductRoutes.products,
            builder: (context, state) => ProductListingPage(
              initialSearchQuery: state.uri.queryParameters['search'],
            ),
          ),

          // Product Detail (inside shell with persistent header/footer)
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

          // Wishlist Route
          GoRoute(path: '/wishlist', builder: (_, __) => const WishlistPage()),
          GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
          GoRoute(
            path: '/checkout',
            builder: (context, state) => const CheckoutPage(),
          ),
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
          GoRoute(
            path: '/repair',
            builder: (context, state) => const RepairPage(),
          ),
        ],
      ),
    ],
  );

  static GlobalKey<ScaffoldMessengerState>? get scaffoldMessengerKey => null;
}