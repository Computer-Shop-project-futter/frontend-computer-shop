// lib/features/account/domain/account_model.dart

import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final double total;
  final OrderStatus status;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });

  factory Order.fromDbJson(Map<String, dynamic> json) {
    OrderStatus parseStatus(String? raw) {
      switch (raw?.toLowerCase()) {
        case 'pending':
          return OrderStatus.pending;
        case 'processing':
          return OrderStatus.processing;
        case 'shipped':
          return OrderStatus.shipped;
        case 'delivered':
          return OrderStatus.delivered;
        case 'cancelled':
          return OrderStatus.cancelled;
        default:
          return OrderStatus.pending;
      }
    }

    return Order(
      id: json['order_id']?.toString() ?? json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      date: json['order_date'] != null
          ? DateTime.parse(json['order_date'].toString())
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'].toString())
              : DateTime.now()),
      total: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: parseStatus(json['status']?.toString()),
      items: (json['items'] as List?)
              ?.map((item) => OrderItem.fromDbJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.processing:
        return const Color(0xFF2A66FF);
      case OrderStatus.shipped:
        return const Color(0xFF8B5CF6);
      case OrderStatus.delivered:
        return const Color(0xFF10B981);
      case OrderStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromDbJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['item_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['product_name']?.toString() ?? json['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: (json['unit_price'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  double get total => quantity * price;
}

class Address {
  final String id;
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phone;
  final bool isDefault;

  const Address({
    required this.id,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });

  factory Address.fromDbJson(Map<String, dynamic> json) {
    return Address(
      id: json['address_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      street: json['street_address']?.toString() ?? json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state_province']?.toString() ?? json['state']?.toString() ?? '',
      zipCode: json['postal_code']?.toString() ?? json['zip_code']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      phone: json['phone_number']?.toString() ?? json['phone']?.toString() ?? '',
      isDefault: (json['is_default'] as bool?) ?? false,
    );
  }

  String get formattedAddress {
    return '$street\n$city, $state $zipCode\n$country';
  }
}

class UserProfile {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final DateTime joinDate;

  const UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.joinDate,
  });

  factory UserProfile.fromDbJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      joinDate: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }
}

class AccountState {
  final UserProfile? user;
  final List<Order> recentOrders;
  final List<Address> addresses;
  final bool isLoading;
  final String? error;
  final int selectedTabIndex;

  const AccountState({
    this.user,
    this.recentOrders = const [],
    this.addresses = const [],
    this.isLoading = false,
    this.error,
    this.selectedTabIndex = 0,
  });

  AccountState copyWith({
    UserProfile? user,
    List<Order>? recentOrders,
    List<Address>? addresses,
    bool? isLoading,
    String? error,
    int? selectedTabIndex,
  }) {
    return AccountState(
      user: user ?? this.user,
      recentOrders: recentOrders ?? this.recentOrders,
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}