// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  orderId: json['order_id'] as String,
  orderNumber: json['order_number'] as String,
  userId: json['user_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  subtotal: (json['subtotal'] as num).toDouble(),
  discountTotal: (json['discount_total'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  couponId: json['coupon_id'] as String?,
  status: json['status'] as String,
  items: (json['order_items'] as List<dynamic>?)
      ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'subtotal': instance.subtotal,
      'discount_total': instance.discountTotal,
      'total': instance.total,
      'coupon_id': instance.couponId,
      'status': instance.status,
      'order_items': instance.items,
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      orderItemId: json['order_item_id'] as String,
      orderId: json['order_id'] as String,
      itemType: json['item_type'] as String,
      productId: json['product_id'] as String?,
      buildId: json['build_id'] as String?,
      selectedConfigJson: json['selected_config_json'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'order_item_id': instance.orderItemId,
      'order_id': instance.orderId,
      'item_type': instance.itemType,
      'product_id': instance.productId,
      'build_id': instance.buildId,
      'selected_config_json': instance.selectedConfigJson,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
    };
