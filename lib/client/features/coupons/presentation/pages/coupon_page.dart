import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:computer_shop/client/features/shared/header/app_main_header.dart';
import 'package:computer_shop/client/features/shared/footer/app_footer.dart';
import 'package:computer_shop/client/features/shared/widgets/navigation/app_drawer.dart';

class CouponPage extends StatefulWidget {
  final String? productId;
  const CouponPage({super.key, this.productId});

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _availableCoupons = [
    {'code': 'WELCOME10', 'desc': '10% off first order', 'discount': '10%'},
    {'code': 'FREESHIP', 'desc': 'Free shipping', 'discount': 'Free'},
    {'code': 'SAVE50', 'desc': 'R50 off on orders over R500', 'discount': 'R50'},
  ];

  String? _applied;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _applyCoupon(String code, {String? productId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final exists = _availableCoupons.any((c) => c['code'] == code);
    if (exists) setState(() => _applied = code);
    return exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Shared header
          AppMainHeader(
            dark: true,
            showSearch: false,
            showFavorites: false,
            showCart: false,
            showBack: true,
            onBackPressed: () => Navigator.pop(context),
          ),

          // Page content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.productId != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text('Applying to product: ${widget.productId}'),
                    ),

                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Coupon code',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _controller.clear(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final code = _controller.text.trim();
                        if (code.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter a coupon code')),
                          );
                          return;
                        }

                        final success = await _applyCoupon(code, productId: widget.productId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? 'Coupon applied: $code' : 'Invalid coupon'),
                          ),
                        );
                      },
                      child: const Text('Apply'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (_applied != null)
                    Text('Applied: $_applied', style: const TextStyle(color: Colors.green)),

                  const SizedBox(height: 8),

                  const Text('Available coupons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _availableCoupons.length,
                      itemBuilder: (context, index) {
                        final c = _availableCoupons[index];
                        return Card(
                          child: ListTile(
                            title: Text(c['code'] ?? ''),
                            subtitle: Text(c['desc'] ?? ''),
                            trailing: Text(c['discount'] ?? ''),
                            onTap: () => setState(() => _controller.text = c['code'] ?? ''),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Shared footer
          AppNavigationFooter(
            currentIndex: 0,
            onTabSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/products');
                  break;
                case 2:
                  context.go('/builder');
                  break;
                case 3:
                  context.go('/repair');
                  break;
                case 4:
                  context.go('/account');
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
