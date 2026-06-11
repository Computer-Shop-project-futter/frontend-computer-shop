// ─────────────────────────────────────────────
//  G14 Admin — Order Detail Bottom Sheet
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../data/app_theme.dart';
import '../../models/models.dart';

class OrderDetailSheet extends StatefulWidget {
  final OrderDetail order;

  const OrderDetailSheet({super.key, required this.order});

  /// Helper to open this sheet
  static Future<void> show(BuildContext context, OrderDetail order) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderDetailSheet(order: order),
    );
  }

  @override
  State<OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends State<OrderDetailSheet> {
  late OrderStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.92,
      decoration: const BoxDecoration(
        color: AppTheme.bgPage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Drag handle ─────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ──────────────────────────
          _SheetHeader(orderId: order.id),

          // ── Scrollable body ──────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Update status card
                  _StatusUpdateCard(
                    selectedStatus: _selectedStatus,
                    onStatusChanged: (s) => setState(() => _selectedStatus = s),
                  ),

                  const SizedBox(height: 16),

                  // Customer details
                  _CustomerDetailsCard(customer: order.customer),

                  const SizedBox(height: 16),

                  // Order items
                  _OrderItemsCard(
                    items: order.items,
                    totalAmount: order.totalAmount,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet header ──────────────────────────────
class _SheetHeader extends StatelessWidget {
  final String orderId;
  const _SheetHeader({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 16, 14),
      decoration: const BoxDecoration(
        color: AppTheme.bgPage,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'G14  PRECISION SUITE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'ORDER MANAGEMENT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Order $orderId',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, size: 16, color: AppTheme.textSecondary),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ── Status update card ────────────────────────
class _StatusUpdateCard extends StatelessWidget {
  final OrderStatus selectedStatus;
  final ValueChanged<OrderStatus> onStatusChanged;

  const _StatusUpdateCard({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  static const _statuses = [
    OrderStatus.pending,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UPDATE ORDER STATUS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<OrderStatus>(
                      value: selectedStatus,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.textMuted, size: 20),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                      dropdownColor: AppTheme.surface,
                      items: _statuses
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s.label[0] + s.label.substring(1).toLowerCase(),
                                ),
                              ))
                          .toList(),
                      onChanged: (s) {
                        if (s != null) onStatusChanged(s);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Save button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Status updated to ${selectedStatus.label}'),
                      backgroundColor: AppTheme.accent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Customer details card ─────────────────────
class _CustomerDetailsCard extends StatelessWidget {
  final Customer customer;
  const _CustomerDetailsCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: const [
              Icon(Icons.person_outline, size: 16, color: AppTheme.textMuted),
              SizedBox(width: 6),
              Text(
                'CUSTOMER DETAILS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.borderColor),
          const SizedBox(height: 10),
          _DetailRow(label: 'Full Name',     value: customer.fullName),
          _DetailRow(label: 'Email Address', value: customer.email),
          _DetailRow(label: 'Phone Number',  value: customer.phone),
        ],
      ),
    );
  }
}


class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order items card ──────────────────────────
class _OrderItemsCard extends StatelessWidget {
  final List<OrderItem> items;
  final String totalAmount;
  const _OrderItemsCard({required this.items, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 16, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              Text(
                'ORDER ITEMS (${items.length})',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.borderColor),
          ...items.map((item) => _OrderItemRow(item: item)),

          const SizedBox(height: 4),
          const Divider(height: 1, color: AppTheme.borderColor),
          const SizedBox(height: 12),

          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                totalAmount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accentDark,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product icon placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.memory_rounded, size: 24, color: AppTheme.textMuted),
          ),
          const SizedBox(width: 12),
          // Name + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.bgPage,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'QTY:${item.qty}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared section container ──────────────────
class _SectionContainer extends StatelessWidget {
  final Widget child;
  const _SectionContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
