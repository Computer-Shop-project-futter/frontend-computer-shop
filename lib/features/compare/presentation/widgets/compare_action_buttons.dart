import 'package:flutter/material.dart';

class CompareActionButtons extends StatelessWidget {
  final int productCount;
  final List<VoidCallback> onAddToCartCallbacks;

  const CompareActionButtons({
    super.key,
    required this.productCount,
    required this.onAddToCartCallbacks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          for (int i = 0; i < productCount; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i < productCount - 1 ? 8 : 0,
                ),
                child: ElevatedButton(
                  onPressed: onAddToCartCallbacks[i],
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A66FF),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ADD TO CART',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
