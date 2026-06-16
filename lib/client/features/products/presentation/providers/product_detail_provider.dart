import 'package:flutter/material.dart';

class ProductDetailProvider extends StatelessWidget {
  const ProductDetailProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G14-TECH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A66FF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        useMaterial3: true,
      ),
      home: const ProductDetailPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────

class ProductSpec {
  final String label;
  final String value;
  const ProductSpec(this.label, this.value);
}

class PerformanceMetric {
  final String name;
  final String valueLabel;
  final double progress;
  final bool isGreen;
  const PerformanceMetric(this.name, this.valueLabel, this.progress,
      {this.isGreen = false});
}

class Review {
  final String author;
  final String badge;
  final double rating;
  final String title;
  final String body;
  const Review({
    required this.author,
    required this.badge,
    required this.rating,
    required this.title,
    required this.body,
  });
}

class UpsellProduct {
  final String brand;
  final String name;
  final String price;
  final String imageUrl;
  const UpsellProduct({
    required this.brand,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

// ─────────────────────────────────────────────────────────────
// COLORS & CONSTANTS
// ─────────────────────────────────────────────────────────────

const kBg           = Color(0xFFF6F8FC);
const kSurface      = Color(0xFFFFFFFF);
const kCard         = Color(0xFFF1F4FA);
const kBorder       = Color(0xFFE3E8F3);
const kBlue         = Color(0xFF2A66FF);
const kBlueDark     = Color(0xFF1D4ED8);
const kGreen        = Color(0xFF10B981);
const kRed          = Color(0xFFEF4444);
const kTextPrimary  = Color(0xFF0F172A);
const kTextSecondary= Color(0xFF4B5563);
const kTextMuted    = Color(0xFF6B7280);

// ─────────────────────────────────────────────────────────────
// MAIN PRODUCT PAGE
// ─────────────────────────────────────────────────────────────

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int  _carouselIndex = 0;
  String _selectedRam     = '32GB';
  String _selectedStorage = '1TB';
  int  _bottomNavIndex    = 0;
  bool _inWishlist        = false;

  final List<String> _ramOptions     = ['32GB', '64GB'];
  final List<Map<String, String>> _storageOptions = [
    {'label': '1TB',  'extra': ''},
    {'label': '2TB',  'extra': '+\$150'},
  ];

  // Only show 3 specs (as in screenshot)
  final List<ProductSpec> _specs = const [
    ProductSpec('PROCESSOR',  'Intel i9-14900K'),
    ProductSpec('GRAPHICS',   'NVIDIA RTX 4090'),
    ProductSpec('MOTHERBOARD','Z790 Elite'),
  ];

  // Only 2 metrics shown (as in screenshot)
  final List<PerformanceMetric> _metrics = const [
    PerformanceMetric('MULTI-CORE PERFORMANCE', '32,450 pts', 0.88),
    PerformanceMetric('THERMAL MANAGEMENT', 'Optimal', 0.95, isGreen: true),
  ];

  final List<Review> _reviews = const [
    Review(
      author: 'Alex D.',
      badge:  'GAMING',
      rating: 5,
      title:  'Absolute Beast',
      body:   'Performance is unmatched. From thermal management to pure frame output, this rig handles everything I throw at it with silence and grace.',
    ),
  ];

  final List<UpsellProduct> _upsells = const [
    UpsellProduct(
      brand:    'NEXCORE',
      name:     'Vision Ultra 32" 4K',
      price:    '\$799',
      imageUrl: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=300&q=80',
    ),
    UpsellProduct(
      brand:    'NEXCORE',
      name:     'Linear-X Mech KB',
      price:    '\$189',
      imageUrl: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=300&q=80',
    ),
    UpsellProduct(
      brand:    'NEXCORE',
      name:     'Phantom Pro Mouse',
      price:    '\$129',
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=300&q=80',
    ),
    UpsellProduct(
      brand:    'NEXCORE',
      name:     'ArcSound Headset',
      price:    '\$249',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCarousel(),
                    _buildCarouselDots(),
                    _buildProductInfo(),
                    _buildDivider(),
                    _buildRamSelector(),
                    _buildStorageSelector(),
                    _buildDivider(),
                    _buildActionButtons(),
                    _buildSectionTabs(),
                    _buildSpecsSection(),
                    _buildBenchmarksSection(),
                    _buildReviewsSection(),
                    const SizedBox(height: 16),
                    _buildCompleteSetup(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _iconButton(Icons.arrow_back_ios_new_rounded,
              () => Navigator.maybePop(context)),
          const Spacer(),
          const Text(
            'G14 · TECH',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: kTextPrimary,
            ),
          ),
          const Spacer(),
          Row(children: [
            _iconButton(
              _inWishlist ? Icons.favorite : Icons.favorite_border,
              () => setState(() => _inWishlist = !_inWishlist),
              color: _inWishlist ? kRed : null,
            ),
            const SizedBox(width: 8),
            _iconButton(Icons.share_outlined, () {}),
          ]),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder, width: 1),
        ),
        child: Icon(icon, color: color ?? kTextSecondary, size: 18),
      ),
    );
  }

  // ── HERO CAROUSEL ─────────────────────────────────────────

  Widget _buildHeroCarousel() {
    final desktopImages = [
      'images/desktop1.png',
      'images/desktop2.png',
      'images/desktop3.png',
    ];

    return GestureDetector(
      onHorizontalDragEnd: (d) {
        if (d.primaryVelocity! < -200 && _carouselIndex < 2) {
          setState(() => _carouselIndex++);
        } else if (d.primaryVelocity! > 200 && _carouselIndex > 0)
          setState(() => _carouselIndex--);
      },
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFAF3E0),
              const Color(0xFFEFDCC8),
              const Color(0xFFE8C9A0),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Subtle top accent light
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            // Subtle bottom accent light
            Positioned(
              bottom: -50,
              left: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4A847).withOpacity(0.15),
                ),
              ),
            ),
            // Product image carousel
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  desktopImages[_carouselIndex],
                  key: ValueKey(_carouselIndex),
                  fit: BoxFit.contain,
                  height: 240,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.computer,
                    size: 120,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            // DEAL badge
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: kRed.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'DEAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == _carouselIndex ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == _carouselIndex ? kBlue : kBorder,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  // ── PRODUCT INFO ──────────────────────────────────────────

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEXCORE',
            style: TextStyle(
              fontSize: 11,
              color: kTextMuted,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Apex-I Ultimate\nGaming Rig',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '\$2,899',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: kBlue,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '\$3,299',
                style: TextStyle(
                  fontSize: 16,
                  color: kTextMuted,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: kTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kRed.withOpacity(0.2)),
                ),
                child: const Text(
                  'SAVE 12%',
                  style: TextStyle(
                    color: kRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kGreen.withOpacity(0.2)),
                ),
                child: const Text(
                  'IN STOCK',
                  style: TextStyle(
                    color: kGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── SELECTORS ─────────────────────────────────────────────

  Widget _buildRamSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('SELECT RAM:'),
          const SizedBox(height: 10),
          Row(
            children: _ramOptions.map((opt) {
              final sel = _selectedRam == opt;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _optionChip(
                  label: opt,
                  selected: sel,
                  onTap: () => setState(() => _selectedRam = opt),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('STORAGE:'),
          const SizedBox(height: 10),
          Row(
            children: _storageOptions.map((opt) {
              final sel = _selectedStorage == opt['label'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _optionChip(
                  label: opt['label']!,
                  sublabel:
                      opt['extra']!.isEmpty ? null : opt['extra'],
                  selected: sel,
                  onTap: () =>
                      setState(() => _selectedStorage = opt['label']!),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _optionChip({
    required String label,
    String? sublabel,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? kBlue : kSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? kBlue : kBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : kTextSecondary,
              ),
            ),
            if (sublabel != null) ...[
              const SizedBox(width: 4),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white70 : kTextMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── ACTION BUTTONS ────────────────────────────────────────

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _showSnack('Added to cart!'),
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              label: const Text(
                'ADD TO CART',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                setState(() => _inWishlist = !_inWishlist);
                _showSnack(
                    _inWishlist ? 'Added to wishlist!' : 'Removed from wishlist');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kBlue,
                side: BorderSide(color: kBlue.withOpacity(0.4), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'ADD TO WISHLIST',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'COMPARE',
              style: TextStyle(
                fontSize: 13,
                color: kTextMuted,
                decoration: TextDecoration.underline,
                decorationColor: kTextMuted,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION TABS (visual only – content stacked below) ───

  Widget _buildSectionTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kBorder, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _tabLabel('SPECS',      true),
            const SizedBox(width: 28),
            _tabLabel('BENCHMARKS', false),
            const SizedBox(width: 28),
            _tabLabel('REVIEWS',    false),
          ],
        ),
      ),
    );
  }

  Widget _tabLabel(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: active ? kBlue : kTextMuted,
              ),
            ),
          ),
          Container(
            height: 2,
            width: text.length * 7.5,
            color: active ? kBlue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // ── SPECS SECTION ─────────────────────────────────────────

  Widget _buildSpecsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          children: _specs.asMap().entries.map((e) {
            final isLast = e.key == _specs.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.value.label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: kTextMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        e.value.value,
                        style: const TextStyle(
                          fontSize: 13,
                          color: kTextPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1, color: kBorder, indent: 14, endIndent: 14),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── BENCHMARKS SECTION ────────────────────────────────────

  Widget _buildBenchmarksSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PERFORMANCE METRICS',
            style: TextStyle(
              fontSize: 11,
              color: kTextMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              children: _metrics.asMap().entries.map((e) {
                final m = e.value;
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: e.key < _metrics.length - 1 ? 16 : 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.name,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: kTextSecondary,
                                  fontWeight: FontWeight.w600)),
                          Text(
                            m.valueLabel,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: m.isGreen ? kGreen : kBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: m.progress,
                          backgroundColor: kBorder,
                          valueColor: AlwaysStoppedAnimation(
                              m.isGreen ? kGreen : kBlue),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── REVIEWS SECTION ───────────────────────────────────────

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating header
          Row(
            children: [
              const Text('REVIEWS',
                  style: TextStyle(
                    fontSize: 11,
                    color: kTextMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('4.8',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: kTextPrimary,
                  )),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                        5,
                        (i) => Icon(
                              i < 4 ? Icons.star : Icons.star_half,
                              color: const Color(0xFFF59E0B),
                              size: 18,
                            )),
                  ),
                  const SizedBox(height: 2),
                  const Text('124 verified reviews',
                      style: TextStyle(fontSize: 12, color: kTextMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildReviewCard(r),
              )),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review r) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(r.author,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary)),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: kBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(r.badge,
                      style: const TextStyle(
                          fontSize: 10,
                          color: kBlue,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
              Row(
                children: List.generate(
                    5,
                    (i) => Icon(
                          i < r.rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFF59E0B),
                          size: 14,
                        )),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(r.title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary)),
          const SizedBox(height: 4),
          Text(r.body,
              style: const TextStyle(
                  fontSize: 12, color: kTextSecondary, height: 1.6)),
        ],
      ),
    );
  }

  // ── COMPLETE YOUR SETUP ───────────────────────────────────

  Widget _buildCompleteSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 14),
          child: Text(
            'Complete Your Setup',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _upsells.length,
            itemBuilder: (ctx, i) => Padding(
              padding: EdgeInsets.only(
                  right: i < _upsells.length - 1 ? 12 : 0),
              child: _buildUpsellCard(_upsells[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpsellCard(UpsellProduct p) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Network image with fallback
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(13)),
            child: SizedBox(
              height: 105,
              width: double.infinity,
              child: Image.network(
                p.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: kCard,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: kBlue, strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: kCard,
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        color: kTextMuted, size: 32),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.brand,
                    style: const TextStyle(
                        fontSize: 10, color: kTextMuted, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary,
                        height: 1.3)),
                const SizedBox(height: 4),
                Text(p.price,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ────────────────────────────────────────────

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined,        'label': 'HOME'},
      {'icon': Icons.grid_view_rounded,    'label': 'SHOP'},
      {'icon': Icons.build_outlined,       'label': 'BUILD'},
      {'icon': Icons.person_outline_rounded,'label': 'ACCOUNT'},
    ];
    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kBorder, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: items.asMap().entries.map((e) {
            final active = e.key == _bottomNavIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _bottomNavIndex = e.key),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      e.value['icon'] as IconData,
                      color: active ? kBlue : kTextMuted,
                      size: 22,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      e.value['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: active ? kBlue : kTextMuted,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────

  Widget _buildDivider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Divider(height: 1, color: kBorder.withOpacity(0.9)),
      );

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: kTextMuted,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      );

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: kTextPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}