/// Repository for orders operations
abstract class OrdersRepository {
  /// Get user's orders (optionally filtered by status)
  Future<dynamic> getOrders({String? status, int page = 1, int limit = 20});

  /// Get order details by ID
  Future<dynamic> getOrderById(String orderId);

  /// Create new order from cart
  Future<dynamic> createOrder(Map<String, dynamic> orderData);

  /// Confirm order payment
  Future<void> confirmOrder(String orderId);

  /// Cancel order
  Future<void> cancelOrder(String orderId);
}
