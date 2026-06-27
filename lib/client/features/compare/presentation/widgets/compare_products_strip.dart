import 'package:flutter/material.dart';
import 'compare_product_card.dart';

class CompareProductsStrip extends StatelessWidget {
  final List<CompareProductInfo> products;
  final ValueChanged<String> onRemove;

  const CompareProductsStrip({
    super.key,
    required this.products,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Compare',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < products.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      right: i < products.length - 1 ? 12 : 0,
                    ),
                    child: CompareProductCard(
                      title: products[i].title,
                      image: products[i].image,
                      price: products[i].price,
                      onRemove: () => onRemove(products[i].id),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompareProductInfo {
  final String id;
  final String title;
  final String image;
  final String price;

  const CompareProductInfo({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });
}
