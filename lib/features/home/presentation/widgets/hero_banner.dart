import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  final VoidCallback? onShopNow;
  final VoidCallback? onBuildPc;

  const HeroBanner({
    super.key,
    this.onShopNow,
    this.onBuildPc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1C3F),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=1200',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Build Your Legend.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onShopNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A66FF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Shop Now'),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: onBuildPc,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: const Text('Build a PC'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
