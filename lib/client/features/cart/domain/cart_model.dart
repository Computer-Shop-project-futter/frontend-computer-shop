// lib/features/cart/domain/cart_model.dart

class CartItem {
  final String cartItemId;
  final String? productId;
  final String? buildId;
  final String name;
  final String type; // 'product' or 'build'
  final String variant;
  final int quantity;
  final double price;
  final String? imageUrl;
  final int addedAt;

  const CartItem({
    required this.cartItemId,
    this.productId,
    this.buildId,
    required this.name,
    required this.type,
    required this.variant,
    required this.quantity,
    required this.price,
    this.imageUrl,
    required this.addedAt,
  });

  Map<String, dynamic> toDbJson() {
    return {
      'cart_item_id': cartItemId,
      'product_id': productId,
      'build_id': buildId,
      'name': name,
      'type': type,
      'variant': variant,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
      'added_at': addedAt,
    };
  }

  factory CartItem.fromDbJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cart_item_id']?.toString() ?? '',
      productId: json['product_id']?.toString(),
      buildId: json['build_id']?.toString(),
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'product',
      variant: json['variant']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url']?.toString(),
      addedAt: json['added_at'] as int? ?? 0,
    );
  }
}
