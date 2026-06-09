import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

/// Order model
/// Maps to orders table
@JsonSerializable()
class OrderModel {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'order_number')
  final String orderNumber;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final double subtotal;

  @JsonKey(name: 'discount_total')
  final double discountTotal;

  final double total;

  @JsonKey(name: 'coupon_id')
  final String? couponId;

  final String status; // 'mock_paid', 'pending', 'shipped', 'delivered', 'cancelled'

  @JsonKey(name: 'order_items')
  final List<OrderItemModel>? items;

  OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.userId,
    required this.createdAt,
    required this.subtotal,
    required this.discountTotal,
    required this.total,
    this.couponId,
    required this.status,
    this.items,
  });

  /// Check if order is paid
  bool get isPaid => status == 'mock_paid' || status == 'shipped' || status == 'delivered';

  /// Check if order is delivered
  bool get isDelivered => status == 'delivered';

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

/// Order item model
/// Maps to order_items table
@JsonSerializable()
class OrderItemModel {
  @JsonKey(name: 'order_item_id')
  final String orderItemId;

  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'item_type')
  final String itemType; // 'product' or 'build'

  @JsonKey(name: 'product_id')
  final String? productId;

  @JsonKey(name: 'build_id')
  final String? buildId;

  @JsonKey(name: 'selected_config_json')
  final String? selectedConfigJson;

  final int quantity;

  @JsonKey(name: 'unit_price')
  final double unitPrice;

  OrderItemModel({
    required this.orderItemId,
    required this.orderId,
    required this.itemType,
    this.productId,
    this.buildId,
    this.selectedConfigJson,
    required this.quantity,
    required this.unitPrice,
  });

  /// Calculate line total
  double get lineTotal => unitPrice * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
