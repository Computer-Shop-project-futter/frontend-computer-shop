// ─────────────────────────────────────────────
//  G14 Admin — Data Repository
// ─────────────────────────────────────────────

import '../models/models.dart';

class AppData {
  // ── Current admin user ───────────────────────
  static const AdminUser currentUser = AdminUser(
    initials: 'AR',
    name: 'Alexander R.',
    role: 'SYSTEM ADMIN',
  );


  
  // ── Dashboard metrics ────────────────────────
  static List<MetricItem> get metrics => [
        const MetricItem(
          label: 'Revenue',
          value: '\$124,500',
          change: '+12%',
          isPositive: true,
        ),
        const MetricItem(
          label: 'Orders Today',
          value: '42',
          change: '-5%',
          isPositive: false,
        ),
        const MetricItem(
          label: 'Open Tickets',
          value: '18',
          change: '-2%',
          isPositive: true,
        ),
        const MetricItem(
          label: 'Active Users',
          value: '1,240',
          change: '+18%',
          isPositive: true,
        ),
        const MetricItem(
          label: 'Product Views',
          value: '8,500',
          change: '+8%',
          isPositive: true,
        ),
      ];

  // ── Top products ─────────────────────────────
  static List<Product> get topProducts => [
        const Product(rank: '01', name: 'GeForce RTX 4090 OC', price: '\$42,900'),
        const Product(rank: '02', name: 'GeForce RTX 4080 Super', price: '\$18,450'),
        const Product(rank: '03', name: 'ASUS ROG Maximus Z790', price: '\$12,120'),
        const Product(rank: '04', name: 'Samsung 990 Pro 2TB', price: '\$8,800'),
      ];

  // ── Recent orders ────────────────────────────
  static List<Order> get recentOrders => [
        Order(
          id: '#ORD-9921',
          timeAgo: '3 mins ago',
          category: 'Electronics',
          status: OrderStatus.paid, 
          customerName: 'John Doe',
          totalAmount: '\$1,200',
          paymentMethod: 'Credit Card',
          shippingAddress: '123 Main St, City, State 12345',
          email: 'johndoe@example.com',
          phone: '(555) 123-4567',
          items: [
          OrderItem(
              title: 'RTX 4090 Founders Edition',
              subtitle: 'High-end graphics card',
              price: 42900.0,
            ),
          ],
        ),
        Order(
          id: '#ORD-9920',
          timeAgo: '15 mins ago',
          category: 'Components',
          status: OrderStatus.pending,
          customerName: 'Jane Smith',
          totalAmount: '\$800',
          paymentMethod: 'PayPal',
          shippingAddress: '456 Oak Ave, City, State 12345',
          email: 'janesmith@example.com',
          phone: '(555) 987-6543',
          items: [
            OrderItem(
              title: 'i9-14900K Processor',
              subtitle: 'High-performance CPU',
              price: 18450.0,
            ),
          ],
        ),
        Order(
          id: '#ORD-9919',
          timeAgo: '47 mins ago',
          category: 'Storage',
          status: OrderStatus.paid,
          customerName: 'Bob Johnson',
          totalAmount: '\$1,200',
          paymentMethod: 'Credit Card',
          shippingAddress: '789 Pine Rd, City, State 12345',
          email: 'bobjohnson@example.com',
          phone: '(555) 456-7890',
          items: [
            OrderItem(
              title: 'Samsung 990 Pro 2TB',
              subtitle: 'High-speed NVMe SSD',
              price: 8800.0,
            ),
          ],
        ),
        
      ];

  // ── Inventory alerts ─────────────────────────
  static List<InventoryAlert> get inventoryAlerts => [
        const InventoryAlert(
          productName: 'RTX 4090 Founders Edition',
          warehouse: 'Warehouse A',
          stockLeft: 2,
        ),
        const InventoryAlert(
          productName: 'i9-14900K Processor',
          warehouse: 'Warehouse C',
          stockLeft: 1,
        ),
      ];

  // ── Sidebar navigation ───────────────────────
  static List<NavSection> get navSections => [
        const NavSection(
          sectionLabel: 'PRECISION CORE',
          items: [
            NavItem(label: 'Dashboard Overview', iconAsset: 'dashboard'),
          ],
        ),
        const NavSection(
          sectionLabel: 'INVENTORY CONTROL',
          items: [
            NavItem(label: 'Master Catalog', iconAsset: 'catalog'),
            NavItem(label: 'Global Products', isSubItem: true),
            NavItem(label: 'Precision Components', isSubItem: true),
            NavItem(label: 'Partner Brands', isSubItem: true),
          ],
        ),
        const NavSection(
          sectionLabel: 'SYSTEM OPERATIONS',
          items: [
            NavItem(label: 'Control Center', iconAsset: 'settings'),
            NavItem(label: 'Order Fulfillment', isSubItem: true),
            NavItem(label: 'Regional Branches', isSubItem: true),
            NavItem(label: 'Support Tickets', isSubItem: true),
          ],
        ),
        const NavSection(
          sectionLabel: 'MARKETING',
          items: [
            NavItem(label: 'Feedback'),
            NavItem(label: 'Promotion'),
            NavItem(label: 'Coupon Points'),
          ],
        ),
        const NavSection(
          sectionLabel: 'ACCESS MANAGEMENT',
          items: [
            NavItem(label: 'User Directory', iconAsset: 'users'),
          ],
        ),
      ];

  // ── Bottom nav labels ────────────────────────
  static const List<String> bottomNavLabels = [
    'Home',
    'Orders',
    'Inventory',
    'Metrics',
  ];

  static List<OrderDetail> get orders => [
        OrderDetail(
          'johndoe@example.com',
          '(555) 123-4567',
          id: '#ORD-9921',
          customerName: 'John Doe',
          date: 'May 29, 2026',
          coupon: 'WELCOME10',
          itemCount: 1,
          totalAmount: '\$1,200',
          status: OrderStatus.paid,
          customer: const Customer(
            fullName: 'John Doe',
            email: 'johndoe@example.com',
            phone: '(555) 123-4567',
          ),
          items: [
            OrderItem(
              title: 'RTX 4090 Founders Edition',
              subtitle: 'High-end graphics card',
              price: 42900.0,
            ),
          ],
        ),
        OrderDetail(
          'janesmith@example.com',
          '(555) 987-6543',
          id: '#ORD-9920',
          customerName: 'Jane Smith',
          date: 'May 28, 2026',
          coupon: 'SPRING15',
          itemCount: 1,
          totalAmount: '\$800',
          status: OrderStatus.pending,
          customer: const Customer(
            fullName: 'Jane Smith',
            email: 'janesmith@example.com',
            phone: '(555) 987-6543',
          ),
          items: [
            OrderItem(
              title: 'i9-14900K Processor',
              subtitle: 'High-performance CPU',
              price: 18450.0,
            ),
          ],
        ),
        OrderDetail(
          'bobjohnson@example.com',
          '(555) 456-7890',
          id: '#ORD-9919',
          customerName: 'Bob Johnson',
          date: 'May 27, 2026',
          coupon: 'FREESHIP',
          itemCount: 1,
          totalAmount: '\$1,200',
          status: OrderStatus.paid,
          customer: const Customer(
            fullName: 'Bob Johnson',
            email: 'bobjohnson@example.com',
            phone: '(555) 456-7890',
          ),
          items: [
            OrderItem(
              title: 'Samsung 990 Pro 2TB',
              subtitle: 'High-speed NVMe SSD',
              price: 8800.0,
            ),
          ],
        ),
      ];

  static String get ordersTotalOrders => '${orders.length}';

  static String get ordersTodayRevenue => '\$10,500';

  static String get ordersMonthRevenue => '\$84,300';

  // ── Coupons ───────────────────────────────────
  static List<CouponModel> get seed => [
    CouponModel(
      id: '1', code: 'WINTER24',
      discountType: DiscountType.percentage, discountValue: 15,
      minCartTotal: 500,
      startDate: DateTime(2024, 11, 1), endDate: DateTime(2024, 12, 31),
      isActive: true,
    ),
    CouponModel(
      id: '2', code: 'SAVE100',
      discountType: DiscountType.fixed, discountValue: 100,
      minCartTotal: 2000,
      startDate: DateTime(2024, 12, 1), endDate: DateTime(2024, 12, 31),
      isActive: true,
    ),
    CouponModel(
      id: '3', code: 'BLACKFRIDAY',
      discountType: DiscountType.percentage, discountValue: 30,
      minCartTotal: null,
      startDate: DateTime(2024, 11, 20), endDate: DateTime(2024, 11, 25),
      isActive: false,
    ),
    CouponModel(
      id: '4', code: 'WELCOME50',
      discountType: DiscountType.percentage, discountValue: 50,
      minCartTotal: 1000,
      startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 1, 31),
      isActive: false,
    ),
  ];
}
