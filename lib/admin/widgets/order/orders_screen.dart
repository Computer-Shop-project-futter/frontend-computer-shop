// ─────────────────────────────────────────────
//  G14 Admin — Orders Screen
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../data/app_data.dart';
import '../../../data/app_theme.dart';
import '../../../models/models.dart';
import 'order_card.dart';
import 'popupOrderPage.dart';
import 'orders_metrics_bar.dart';


class OrdersScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const OrdersScreen({super.key, required this.onMenuTap});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late List<OrderDetail> _orders;
  String _searchQuery = '';
  OrderStatus? _filterStatus; // null = show all
  bool _showSearch = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orders = List.from(AppData.orders);
  }

  List<OrderDetail> get _filteredOrders {
    return _orders.where((o) {
      final matchSearch = _searchQuery.isEmpty ||
          o.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus =
          _filterStatus == null || o.status == _filterStatus;
      return matchSearch && matchStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders;

    
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: Column(
        children: [
          // ── App bar ─────────────────────────
          _OrdersAppBar(
            onMenuTap: widget.onMenuTap,
            showSearch: _showSearch,
            searchController: _searchController,
            onSearchToggle: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            onFilterTap: () => _showFilterSheet(),
            filterActive: _filterStatus != null,
          ),

          // ── Metrics bar ─────────────────────
          const OrdersMetricsBar(),

          const SizedBox(height: 8),

          _OrderStatusChips(
            selected: _filterStatus,
            onSelected: (status) => setState(() => _filterStatus = status),
          ),

          const SizedBox(height: 6),

          // ── Active filter chip ───────────────
          if (_filterStatus != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      _filterStatus!.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.statusFg(_filterStatus!),
                      ),
                    ),
                    backgroundColor: AppTheme.statusFg(_filterStatus!),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    deleteIconColor: AppTheme.textMuted,
                    onDeleted: () => setState(() => _filterStatus = null),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${orders.length} order${orders.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),

          // ── Orders list ─────────────────────
          Expanded(
            child: orders.isEmpty
                ? _EmptyState(onClear: () => setState(() {
                      _filterStatus = null;
                      _searchQuery = '';
                      _searchController.clear();
                      _showSearch = false;
                    }))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: orders.length,
                    itemBuilder: (_, i) {
                      final od = orders[i];
                      return OrderCard(
                        order: od,
                        onTap: () async {
                          final updated = await showOrderPopup(context, od);
                          if (updated != null) {
                            setState(() {
                              final idx = _orders.indexWhere((item) => item.id == updated.id);
                              if (idx >= 0) _orders[idx] = updated;
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterSheet(
        current: _filterStatus,
        onSelected: (s) {
          setState(() => _filterStatus = s);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ── App bar ───────────────────────────────────
class _OrdersAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final bool showSearch;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final bool filterActive;

  const _OrdersAppBar({
    required this.onMenuTap,
    required this.showSearch,
    required this.searchController,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.filterActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        bottom: 10,
      ),
      color: AppTheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              // Menu toggle (mobile only)
              if (MediaQuery.of(context).size.width < 900)
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(Icons.menu_rounded, size: 22),
                  color: AppTheme.textPrimary,
                ),
              // Brand
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'G14-TECH',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Search icon
              IconButton(
                onPressed: onSearchToggle,
                icon: Icon(
                  showSearch ? Icons.search_off_rounded : Icons.search_rounded,
                  size: 22,
                  color: showSearch ? AppTheme.accent : AppTheme.textSecondary,
                ),
              ),
              // Filter icon
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: onFilterTap,
                    icon: Icon(
                      Icons.tune_rounded,
                      size: 22,
                      color: filterActive
                          ? AppTheme.accent
                          : AppTheme.textSecondary,
                    ),
                  ),
                  if (filterActive)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          // Search field
          if (showSearch) ...[
            const SizedBox(height: 8),
            TextField(
              controller: searchController,
              autofocus: true,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by order ID or customer…',
                hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppTheme.textMuted, size: 18),
                filled: true,
                fillColor: AppTheme.bgPage,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppTheme.accent, width: 1.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
class _OrderStatusChips extends StatelessWidget {
  final OrderStatus? selected;
  final ValueChanged<OrderStatus?> onSelected;

  const _OrderStatusChips({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = <OrderStatus?>[
      null,
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: statuses.map((status) {
          final title = status == null ? 'All' : status.label;
          final active = selected == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(title),
              selected: active,
              selectedColor: AppTheme.accent,
              backgroundColor: AppTheme.bgPage,
              labelStyle: TextStyle(
                color: active ? Colors.white : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => onSelected(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}
// ── Filter bottom sheet ───────────────────────
class _FilterSheet extends StatelessWidget {
  final OrderStatus? current;
  final ValueChanged<OrderStatus?> onSelected;

  const _FilterSheet({required this.current, required this.onSelected});

  static const _options = [
    OrderStatus.pending,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Filter by Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          // All
          _FilterTile(
            label: 'All Orders',
            isSelected: current == null,
            color: AppTheme.accent,
            onTap: () => onSelected(null),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),
          ..._options.map(
            (s) => Column(
              children: [
                _FilterTile(
                  label: s.label[0] + s.label.substring(1).toLowerCase(),
                  isSelected: current == s,
                  color: AppTheme.statusFg(s),
                  onTap: () => onSelected(s),
                ),
                const Divider(height: 1, color: AppTheme.borderColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterTile({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? color : AppTheme.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: color, size: 20)
          : null,
    );
  }
}

// ── Empty state ───────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 52, color: AppTheme.textMuted.withOpacity(0.5)),
          const SizedBox(height: 14),
          const Text(
            'No orders found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try adjusting your search or filter.',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}
