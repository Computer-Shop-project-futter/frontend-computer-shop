// ─────────────────────────────────────────────
//  G14 Admin — Data Models
// ─────────────────────────────────────────────

import 'package:flutter/widgets.dart';

enum OrderStatus { paid, pending, cancelled, processing, delivered, shipped;

  String get label {
    switch (this) {
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipped';
    }
  }
}

// Coupon
enum DiscountType { percentage, fixed }
 
enum CouponStatus { active, expired, inactive }
 
extension DiscountTypeX on DiscountType {
  String get label => this == DiscountType.percentage ? 'PERCENTAGE' : 'FIXED';
}
 
extension CouponStatusX on CouponStatus {
  String get label {
    switch (this) {
      case CouponStatus.active:   return 'ACTIVE';
      case CouponStatus.expired:  return 'EXPIRED';
      case CouponStatus.inactive: return 'INACTIVE';
    }
  }
}
 
class CouponModel {
  final String id;
  String code;
  String description;
  DiscountType discountType;
  double discountValue;
  double? minCartTotal;
  DateTime startDate;
  DateTime endDate;
  bool isActive;
 
  CouponModel({
    required this.id,
    required this.code,
    this.description = '',
    required this.discountType,
    required this.discountValue,
    this.minCartTotal,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });
 
  CouponStatus get status {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return CouponStatus.expired;
    if (!isActive) return CouponStatus.inactive;
    return CouponStatus.active;
  }
 
  String get summaryLine {
    final val = discountType == DiscountType.percentage
        ? '${discountValue.toInt()}% Off'
        : '\$${discountValue.toStringAsFixed(0)} Off';
    final min = (minCartTotal != null && minCartTotal! > 0)
        ? ' | Min \$${minCartTotal!.toStringAsFixed(0)}'
        : ' | No Minimum';
    return '$val$min';
  }
 
  String get dateRange {
    String fmt(DateTime d) =>
        '${_mon(d.month)} ${d.day.toString().padLeft(2, '0')} — '
        '${_mon(endDate.month)} ${endDate.day.toString().padLeft(2, '0')}, ${endDate.year}';
    return fmt(startDate);
  }
 
  static String _mon(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
 
  CouponModel copyWith({
    String? code, String? description, DiscountType? discountType,
    double? discountValue, double? minCartTotal,
    DateTime? startDate, DateTime? endDate, bool? isActive,
  }) => CouponModel(
    id: id,
    code: code ?? this.code,
    description: description ?? this.description,
    discountType: discountType ?? this.discountType,
    discountValue: discountValue ?? this.discountValue,
    minCartTotal: minCartTotal ?? this.minCartTotal,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    isActive: isActive ?? this.isActive,
  );
}

// ── Customer ───────────────────────────────────
class Customer {
  final String fullName;
  final String email;
  final String phone;
  const Customer({required this.fullName, required this.email, required this.phone});
}

// ── Full order (used in Orders screen + detail) ─
class OrderDetail {
  final String id;
  final String customerName;
  final String date;
  final String coupon;
  final int itemCount;
  final String totalAmount;
  final OrderStatus status;
  final Customer customer;
  final List<OrderItem> items;
  final String email;
  final String phone;

  const OrderDetail(this.email, this.phone, {
    required this.id,
    required this.customerName,
    required this.date,
    required this.coupon,
    required this.itemCount,
    required this.totalAmount,
    required this.status,
    required this.customer,
    required this.items,
  });
}
class MetricItem {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  

  const MetricItem({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
  });
}

class Product {
  final String rank;
  final String name;
  final String price;

  const Product({
    required this.rank,
    required this.name,
    required this.price,
  });
}

class Order {
  final String id;
  final String timeAgo;
  final String category;
  final OrderStatus status;
  final String customerName;
  final String totalAmount;
  final String paymentMethod;
  final String shippingAddress;
  final String email;
  final String phone;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.timeAgo,
    required this.category,
    required this.status,
    required this.customerName,
    required this.totalAmount,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.email,
    required this.phone,
    required this.items,
    
  });
}

class OrderItem {
  final String title;
  final String subtitle;
  final double price;
  final int qty;

  const OrderItem({
    required this.title,
    required this.subtitle,
    required this.price,
    this.qty = 1,
  });

  String? get name => null;
}

class InventoryAlert {
  final String productName;
  final String warehouse;
  final int stockLeft;

  const InventoryAlert({
    required this.productName,
    required this.warehouse,
    required this.stockLeft,
  });
}

class NavItem {
  final String label;
  final String? iconAsset; // null = sub-item (no icon)
  final bool isSubItem;

  const NavItem({
    required this.label,
    this.iconAsset,
    this.isSubItem = false,
  });
}

class NavSection {
  final String sectionLabel;
  final List<NavItem> items;

  const NavSection({
    required this.sectionLabel,
    required this.items,
  });
}

class AdminUser {
  final String initials;
  final String name;
  final String role;

  const AdminUser({
    required this.initials,
    required this.name,
    required this.role,
  });
}

enum ComponentCategory { all, cpu, gpu, ram, storage, mb }
 
extension ComponentCategoryX on ComponentCategory {
  String get label {
    switch (this) {
      case ComponentCategory.all:     return 'ALL';
      case ComponentCategory.cpu:     return 'CPU';
      case ComponentCategory.gpu:     return 'GPU';
      case ComponentCategory.ram:     return 'RAM';
      case ComponentCategory.storage: return 'STORAGE';
      case ComponentCategory.mb:      return 'MB';
    }
  }
 
  Color get badgeColor {
    switch (this) {
      case ComponentCategory.cpu:     return const Color(0xFF3B82F6); // blue
      case ComponentCategory.gpu:     return const Color(0xFF8B5CF6); // purple
      case ComponentCategory.ram:     return const Color(0xFF10B981); // green
      case ComponentCategory.storage: return const Color(0xFFF59E0B); // amber
      case ComponentCategory.mb:      return const Color(0xFF6B7280); // gray
      default:                        return const Color(0xFF9CA3AF);
    }
  }
}
 
 
class ComponentItem {
  final String id;
  final String name;
  final String brand;
  final String price;
  final ComponentCategory category;
  final String? imagePath; // optional asset path
  final String? description;
  final bool isVisible;
 
  const ComponentItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    this.imagePath,
    this.description,
    this.isVisible = true,
  });
 
  ComponentItem copyWith({bool? isVisible, String? description}) => ComponentItem(
        id: id,
        name: name,
        brand: brand,
        price: price,
        category: category,
        imagePath: imagePath,
        description: description ?? this.description,
        isVisible: isVisible ?? this.isVisible,
      );
}
 
// ── Static mock data ──────────────────────────
class ComponentData {
  static List<ComponentItem> get items => [
        const ComponentItem(
          id: '1',
          name: 'Core i9-14900K',
          brand: 'Intel Corp.',
          price: '\$589.00',
          category: ComponentCategory.cpu,
          description: 'Best for high-end gaming and content creation.',
        ),
        const ComponentItem(
          id: '2',
          name: 'RTX 4090',
          brand: 'NVIDIA GeForce',
          price: '\$1,599.00',
          category: ComponentCategory.gpu,
          description: 'Top-tier GPU for 4K performance and ray tracing.',
        ),
        const ComponentItem(
          id: '3',
          name: 'Z790 Elite',
          brand: 'Gigabyte AORUS',
          price: '\$229.00',
          category: ComponentCategory.mb,
          isVisible: false,
        ),
        const ComponentItem(
          id: '4',
          name: '990 Pro 2TB',
          brand: 'Samsung',
          price: '\$189.99',
          category: ComponentCategory.storage,
        ),
        const ComponentItem(
          id: '5',
          name: 'Vengeance 32GB',
          brand: 'Corsair',
          price: '\$109.99',
          category: ComponentCategory.ram,
        ),
        const ComponentItem(
          id: '6',
          name: 'Radeon RX 7900 XTX',
          brand: 'AMD',
          price: '\$899.00',
          category: ComponentCategory.gpu,
        ),
        const ComponentItem(
          id: '7',
          name: 'Ryzen 9 7950X',
          brand: 'AMD',
          price: '\$549.00',
          category: ComponentCategory.cpu,
        ),
        const ComponentItem(
          id: '8',
          name: 'ROG Maximus Z790',
          brand: 'ASUS',
          price: '\$489.00',
          category: ComponentCategory.mb,
        ),
        const ComponentItem(
          id: '9',
          name: 'T-Force Delta 64GB',
          brand: 'TeamGroup',
          price: '\$139.99',
          category: ComponentCategory.ram,
        ),
        const ComponentItem(
          id: '10',
          name: '870 EVO 4TB',
          brand: 'Samsung',
          price: '\$279.99',
          category: ComponentCategory.storage,
        ),
      ];
}