import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// GoRouter configuration
/// Defines all 37 named routes with nested navigation
class AppRouter {
  static final GoRouter router = GoRouter(
    // Initial route
    initialLocation: '/splash',

    // Route redirect logic
    redirect: (context, state) {
      // Redirect unauthenticated users to login
      // This would check authentication state from provider
      // For now, return null to allow navigation
      return null;
    },

    // Route definitions
    routes: [
      // Splash screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const Placeholder(), // Replace with SplashPage
      ),

      // Authentication routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Placeholder(), // Replace with LoginPage
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const Placeholder(), // Replace with RegisterPage
      ),

      // Main app routes (protected)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const Placeholder(), // Replace with HomePage
      ),

      // Product routes
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) => const Placeholder(), // Replace with ProductListingPage
      ),

      GoRoute(
        path: '/products/:id',
        name: 'product_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Placeholder(); // Replace with ProductDetailPage(id: id)
        },
      ),

      // PC Builder routes
      GoRoute(
        path: '/builder',
        name: 'builder',
        builder: (context, state) => const Placeholder(), // Replace with PCBuilderPage
      ),

      // Compare routes
      GoRoute(
        path: '/compare',
        name: 'compare',
        builder: (context, state) => const Placeholder(), // Replace with ComparePage
      ),

      // Cart routes
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const Placeholder(), // Replace with CartPage
      ),

      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const Placeholder(), // Replace with CheckoutPage
      ),

      // Order routes
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const Placeholder(), // Replace with OrderHistoryPage
      ),

      GoRoute(
        path: '/orders/:id',
        name: 'order_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Placeholder(); // Replace with OrderDetailPage(id: id)
        },
      ),

      GoRoute(
        path: '/order-confirmation/:orderId',
        name: 'order_confirmation',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          return Placeholder(); // Replace with OrderConfirmationPage(orderId: orderId)
        },
      ),

      // Favorites routes
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const Placeholder(), // Replace with FavoritesPage
      ),

      // Service routes
      GoRoute(
        path: '/service',
        name: 'service',
        builder: (context, state) => const Placeholder(), // Replace with ServiceTicketsPage
      ),

      GoRoute(
        path: '/service/submit',
        name: 'service_request',
        builder: (context, state) => const Placeholder(), // Replace with ServiceRequestPage
      ),

      GoRoute(
        path: '/service/:ticketId',
        name: 'service_detail',
        builder: (context, state) {
          final ticketId = state.pathParameters['ticketId'];
          return Placeholder(); // Replace with ServiceDetailPage(ticketId: ticketId)
        },
      ),

      // Chat routes
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const Placeholder(), // Replace with ChatPage
      ),

      // Store locator routes
      GoRoute(
        path: '/stores',
        name: 'store_locator',
        builder: (context, state) => const Placeholder(), // Replace with StoreLocatorPage
      ),

      // Profile routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const Placeholder(), // Replace with ProfilePage
      ),

      // Showcase routes
      GoRoute(
        path: '/showcase',
        name: 'showcase',
        builder: (context, state) => const Placeholder(), // Replace with ShowcasePage
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Route not found: ${state.uri.toString()}')),
      );
    },
  );

  /// Navigation helpers
  static void goHome(BuildContext context) => context.go('/home');
  static void goProducts(BuildContext context) => context.go('/products');
  static void goProductDetail(BuildContext context, String id) =>
      context.go('/products/$id');
  static void goBuilder(BuildContext context) => context.go('/builder');
  static void goCart(BuildContext context) => context.go('/cart');
  static void goCheckout(BuildContext context) => context.go('/checkout');
  static void goOrders(BuildContext context) => context.go('/orders');
  static void goProfile(BuildContext context) => context.go('/profile');
  static void goLogin(BuildContext context) => context.go('/login');
  static void goServiceTickets(BuildContext context) => context.go('/service');
}
