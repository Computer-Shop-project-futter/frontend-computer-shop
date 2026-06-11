import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:computer_shop/home/presentation/widgets/deals_section.dart';
import 'package:computer_shop/home/presentation/widgets/featured_rigs_section.dart';
import 'package:computer_shop/home/presentation/widgets/hero_banner.dart';
import 'package:computer_shop/client/products/domain/product_model.dart';

void main() {
  setUpAll(() {
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('Failed to load network image')) {
        return;
      }
      FlutterError.presentError(details);
    };
  });

  testWidgets('HeroBanner shows title and buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: HeroBanner()),
      ),
    );

    expect(find.text('Build Your Legend.'), findsOneWidget);
    expect(find.text('Shop Now'), findsOneWidget);
    expect(find.text('Build a PC'), findsOneWidget);
  });

  testWidgets('FeaturedRigsSection renders product cards', (tester) async {
    final products = [
      const ProductModel(
        productId: 'p1',
        categoryId: 'c1',
        brandId: 'b1',
        name: 'Rig One',
        shortDescription: 'Fast rig',
        basePrice: 2000,
        dealPrice: null,
        thumbnailUrl: 'https://example.com/rig.png',
        isFeatured: true,
        isDeal: false,
        isActive: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FeaturedRigsSection(products: products),
        ),
      ),
    );

    expect(find.text('FEATURED RIGS'), findsOneWidget);
    expect(find.text('Rig One'), findsOneWidget);
  });

  testWidgets('DealsSection renders deal prices', (tester) async {
    final deals = [
      const ProductModel(
        productId: 'p2',
        categoryId: 'c1',
        brandId: 'b1',
        name: 'Deal Rig',
        shortDescription: 'Hot deal',
        basePrice: 1800,
        dealPrice: 1600,
        thumbnailUrl: 'https://example.com/deal.png',
        isFeatured: false,
        isDeal: true,
        isActive: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DealsSection(deals: deals),
        ),
      ),
    );

    expect(find.text('HOT DEALS'), findsOneWidget);
    expect(find.text('Deal Rig'), findsOneWidget);
    expect(find.text('\$1800'), findsOneWidget);
    expect(find.text('\$1600'), findsOneWidget);
  });
}
