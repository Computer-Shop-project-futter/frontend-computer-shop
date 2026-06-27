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

<<<<<<< HEAD
=======
// ── Feedback ────────────────────────────────────

enum FeedbackStatus { newFeedback, inReview, resolved }

extension FeedbackStatusX on FeedbackStatus {
  String get label {
    switch (this) {
      case FeedbackStatus.newFeedback:
        return 'New';
      case FeedbackStatus.inReview:
        return 'In Review';
      case FeedbackStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case FeedbackStatus.newFeedback:
        return const Color(0xFFEF4444);
      case FeedbackStatus.inReview:
        return const Color(0xFFF59E0B);
      case FeedbackStatus.resolved:
        return const Color(0xFF10B981);
    }
  }
}

class FeedbackItem {
  final String id;
  final String customerName;
  final String message;
  final int rating;
  final String? adminReply;
  final FeedbackStatus status;
  final DateTime createdAt;

  const FeedbackItem({
    required this.id,
    required this.customerName,
    required this.message,
    required this.rating,
    this.adminReply,
    required this.status,
    required this.createdAt,
  });

  String get customerEmail => '$customerName@example.com';
  DateTime get submittedAt => createdAt;

  FeedbackItem copyWith({
    String? id,
    String? customerName,
    String? message,
    int? rating,
    String? adminReply,
    FeedbackStatus? status,
    DateTime? createdAt,
  }) {
    return FeedbackItem(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      adminReply: adminReply ?? this.adminReply,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FeedbackData {
  static List<FeedbackItem> get seed => [
        FeedbackItem(
          id: 'fb1',
          customerName: 'Sarah Johnson',
          message: 'Great service! My laptop was fixed within 24 hours.',
          rating: 5,
          status: FeedbackStatus.newFeedback,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        FeedbackItem(
          id: 'fb2',
          customerName: 'Mike Chen',
          message: 'The custom build exceeded my expectations. Fast delivery too.',
          rating: 5,
          adminReply: 'Thank you Mike! We appreciate your business.',
          status: FeedbackStatus.inReview,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        FeedbackItem(
          id: 'fb3',
          customerName: 'Emily Davis',
          message: 'Had some issues with the initial setup, but support was helpful.',
          rating: 3,
          adminReply: 'Sorry for the trouble Emily. We\'ve noted this for improvement.',
          status: FeedbackStatus.resolved,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
}

// ── Promotion ───────────────────────────────────

enum PromotionType { banner, discount, newArrival }

extension PromotionTypeX on PromotionType {
  String get label {
    switch (this) {
      case PromotionType.banner:
        return 'BANNER';
      case PromotionType.discount:
        return 'DISCOUNT';
      case PromotionType.newArrival:
        return 'NEW ARRIVAL';
    }
  }

  Color get badgeColor {
    switch (this) {
      case PromotionType.banner:
        return const Color(0xFF3B82F6);
      case PromotionType.discount:
        return const Color(0xFFEF4444);
      case PromotionType.newArrival:
        return const Color(0xFF10B981);
    }
  }
}

class PromotionItem {
  final String id;
  final String title;
  final String subtitle;
  final PromotionType type;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String? imagePath;

  const PromotionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.imagePath,
  });

  String get statusLabel => isActive ? 'Active' : 'Inactive';
  Color get statusColor => isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280);
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

  PromotionItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    PromotionType? type,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? imagePath,
  }) {
    return PromotionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class PromotionData {
  static List<PromotionItem> get seed => [
        PromotionItem(
          id: 'p1',
          title: 'Summer GPU Blowout',
          subtitle: 'Up to 30% off on select graphics cards',
          type: PromotionType.banner,
          startDate: DateTime.now().subtract(const Duration(days: 5)),
          endDate: DateTime.now().add(const Duration(days: 25)),
          isActive: true,
        ),
        PromotionItem(
          id: 'p2',
          title: 'Back to School Bundle',
          subtitle: 'Save \$100 on student PC bundles',
          type: PromotionType.discount,
          startDate: DateTime.now().subtract(const Duration(days: 10)),
          endDate: DateTime.now().add(const Duration(days: 20)),
          isActive: true,
        ),
        PromotionItem(
          id: 'p3',
          title: 'New Ryzen 9000 Series',
          subtitle: 'Now in stock - Pre-order today',
          type: PromotionType.newArrival,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 14)),
          isActive: false,
        ),
      ];
}

>>>>>>> 4bf4199 (update code in client and admin)
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