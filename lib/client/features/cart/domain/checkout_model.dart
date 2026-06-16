// lib/features/checkout/domain/checkout_model.dart

enum ShippingMethod {
  standard,
  express,
}

enum PaymentMethod {
  creditCard,
  paypal,
  applePay,
  googlePay,
}

class ShippingMethodDetails {
  final ShippingMethod method;
  final String name;
  final String description;
  final double price;
  final String duration;

  const ShippingMethodDetails({
    required this.method,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
  });
}

class OrderItem {
  final String id;
  final String name;
  final String type; // 'PRODUCT' or 'BUILD'
  final String variant;
  final int quantity;
  final double price;
  final String? imageUrl;

  const OrderItem({
    required this.id,
    required this.name,
    required this.type,
    required this.variant,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  double get total => price * quantity;
}

class CheckoutState {
  final List<OrderItem> items;
  final String fullName;
  final String email;
  final String phone;
  final String? couponCode;
  final double? discountAmount;
  final ShippingMethod selectedShipping;
  final PaymentMethod? selectedPayment;
  final bool isLoading;
  final String? error;

  const CheckoutState({
    required this.items,
    required this.fullName,
    required this.email,
    required this.phone,
    this.couponCode,
    this.discountAmount,
    required this.selectedShipping,
    this.selectedPayment,
    this.isLoading = false,
    this.error,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  
  double get discount => discountAmount ?? 0;
  
  double get shippingCost {
    switch (selectedShipping) {
      case ShippingMethod.standard:
        return 0;
      case ShippingMethod.express:
        return 15.00;
    }
  }
  
  double get total => subtotal - discount + shippingCost;

  CheckoutState copyWith({
    List<OrderItem>? items,
    String? fullName,
    String? email,
    String? phone,
    String? couponCode,
    double? discountAmount,
    ShippingMethod? selectedShipping,
    PaymentMethod? selectedPayment,
    bool? isLoading,
    String? error,
  }) {
    return CheckoutState(
      items: items ?? this.items,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      couponCode: couponCode ?? this.couponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      selectedShipping: selectedShipping ?? this.selectedShipping,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}