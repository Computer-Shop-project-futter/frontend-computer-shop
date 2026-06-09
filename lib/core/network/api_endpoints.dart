/// API endpoint path constants
abstract class ApiEndpoints {
  // Base configuration
  static const String baseUrl = 'http://your-backend-url.com/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';

  // Products endpoints
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String productSpecs = '/products/:id/specs';
  static const String productBenchmarks = '/products/:id/benchmarks';
  static const String productReviews = '/products/:id/reviews';
  static const String productMedia = '/products/:id/media';

  // Categories
  static const String categories = '/categories';

  // Brands
  static const String brands = '/brands';

  // Cart endpoints
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static const String cartAdd = '/cart/add';
  static const String cartRemove = '/cart/remove/:id';
  static const String cartUpdate = '/cart/update/:id';

  // Orders endpoints
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String orderConfirm = '/orders/:id/confirm';

  // PC Builder endpoints
  static const String builds = '/builds';
  static const String buildDetail = '/builds/:id';
  static const String components = '/components';
  static const String componentsByType = '/components/type/:type';

  // Compare endpoints
  static const String compareLists = '/compare';
  static const String compareListDetail = '/compare/:id';

  // Favorites endpoints
  static const String favorites = '/favorites';
  static const String addFavorite = '/favorites/add';
  static const String removeFavorite = '/favorites/:id';

  // Service endpoints
  static const String serviceTickets = '/service/tickets';
  static const String submitTicket = '/service/tickets/submit';
  static const String ticketDetail = '/service/tickets/:id';
  static const String ticketTimeline = '/service/tickets/:id/timeline';

  // Chat endpoints
  static const String chatThreads = '/chat/threads';
  static const String chatMessages = '/chat/threads/:id/messages';
  static const String sendMessage = '/chat/messages/send';

  // Store locator endpoints
  static const String branches = '/branches';
  static const String branchDetail = '/branches/:id';

  // Showcase endpoints
  static const String showcase = '/showcase';
  static const String showcaseByTag = '/showcase/tag/:tag';

  // Coupons
  static const String applyCoupon = '/coupons/apply';

  /// Build full URL from endpoint
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';

  /// Replace path parameter in endpoint
  static String replaceParam(String endpoint, String paramName, String value) {
    return endpoint.replaceAll(':$paramName', value);
  }
}
