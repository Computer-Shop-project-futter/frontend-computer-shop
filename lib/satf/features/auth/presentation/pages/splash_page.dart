import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/user_model.dart';
import '../providers/auth_provider.dart';

// ─────────────────────────────────────────────
//  G14-TECH  —  Splash / Loading Screen
//  File location in project tree:
//    lib/features/auth/presentation/pages/splash_page.dart
// ─────────────────────────────────────────────

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {

  String _routeForRole(UserModel user) {
    switch (user.roleId.toLowerCase()) {
      case 'admin':
        return '/admin';
      case 'staff':
      case 'salf':
        return '/staff';
      default:
        return '/home';
    }
  }

  // ── Controllers ──────────────────────────────
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final AnimationController _spinnerController;
  late final AnimationController _textController;
  late final AnimationController _scanController;

  // ── Logo animations ───────────────────────────
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  // ── Tagline animation ─────────────────────────
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  // ── Bottom section animations ─────────────────
  late final Animation<double> _bottomFade;

  // ── Scan line (decorative) ────────────────────
  late final Animation<double> _scanLine;

  // ── Loading messages ──────────────────────────
  final List<String> _messages = [
    'INITIALIZING CORE',
    'LOADING MODULES',
    'ESTABLISHING LINK',
    'SYSTEM READY',
  ];
  int _msgIndex = 0;
  String get _currentMessage => _messages[_msgIndex];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // Logo fades + scales in over 900ms
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.75, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Outer ring pulses forever
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // Spinner rotates forever
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Bottom text fades in
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Horizontal scan line sweeps down screen
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _scanLine = Tween<double>(begin: -0.05, end: 1.05).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );
  }

  Future<void> _startSequence() async {
    // 1. Logo appears
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // 2. Bottom section appears
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    // 3. Cycle loading messages
    for (int i = 1; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) setState(() => _msgIndex = i);
    }

    // 4. Navigate to next screen after loading completes
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      final isAuthed = await ref.read(authProvider.notifier).checkAuth();
      if (!mounted) return;
      if (isAuthed) {
        final user = ref.read(authProvider).user;
        context.go(user != null ? _routeForRole(user) : '/home');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _spinnerController.dispose();
    _textController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // ── 1. Background: subtle blue grid + corner accents ──
          const _BackgroundGrid(),

          // ── 2. Animated scan line sweep ──
          AnimatedBuilder(
            animation: _scanLine,
            builder: (_, __) => Positioned(
              top: MediaQuery.of(context).size.height * _scanLine.value,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    const Color(0xFF1565C0).withOpacity(0.15),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ),

          // ── 3. Corner accent borders ──
          const _CornerAccents(),

          // ── 4. Main content column ──
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              // ── LOGO BLOCK ──
              AnimatedBuilder(
                animation: _logoController,
                builder: (_, child) => Opacity(
                  opacity: _logoFade.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                ),
                child: Column(
                  children: [
                    // Pulsing outer ring + logo icon
                    _PulsingLogo(pulseAnim: _pulseController),
                    const SizedBox(height: 20),

                    // Brand name
                    const Text(
                      'G14-TECH',
                      style: TextStyle(
                        fontFamily: 'Rajdhani', // Swap for your actual font
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── TAGLINE ──
              FadeTransition(
                opacity: _taglineFade,
                child: SlideTransition(
                  position: _taglineSlide,
                  child: const Text(
                    'PRECISELY ENGINEERED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 5,
                      color: Color(0xFF90A4AE),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // ── BOTTOM: SPINNER + MESSAGE ──
              FadeTransition(
                opacity: _bottomFade,
                child: Column(
                  children: [
                    // Rotating arc spinner
                    AnimatedBuilder(
                      animation: _spinnerController,
                      builder: (_, __) => Transform.rotate(
                        angle: _spinnerController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: const Size(32, 32),
                          painter: _ArcSpinnerPainter(
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Loading message — animates when text changes
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: Text(
                        '• $_currentMessage',
                        key: ValueKey(_currentMessage),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3,
                          color: Color(0xFF78909C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── VERSION TAG ──
              FadeTransition(
                opacity: _bottomFade,
                child: const Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: Color(0xFFCFD8DC),
                  ),
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

// ─────────────────────────────────────────────────────────────────────────────
//  WIDGET: Pulsing outer ring around logo circle
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingLogo extends StatelessWidget {
  final AnimationController pulseAnim;
  const _PulsingLogo({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (_, child) {
        // Pulse value oscillates 0 → 1 → 0
        final pulse = pulseAnim.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring — expands and fades
            Container(
              width: 110 + (pulse * 18),
              height: 110 + (pulse * 18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1565C0).withOpacity(0.15 + pulse * 0.15),
                  width: 1.5,
                ),
              ),
            ),
            // Middle ring
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1565C0).withOpacity(0.25 + pulse * 0.1),
                  width: 1,
                ),
              ),
            ),
            // Inner filled circle (logo background)
            child!,
          ],
        );
      },
      child: Container(
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1565C0).withOpacity(0.35),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/g14_logo.png',
          width: 52,
          height: 52,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  WIDGET: Subtle blue dot-grid background
// ─────────────────────────────────────────────────────────────────────────────
class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1565C0).withOpacity(0.07)
      ..strokeWidth = 1;

    const spacing = 28.0;
    const dotRadius = 1.0;

    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  WIDGET: Blue corner accent lines (top-left, bottom-right)
// ─────────────────────────────────────────────────────────────────────────────
class _CornerAccents extends StatelessWidget {
  const _CornerAccents();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _CornerPainter(),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1565C0).withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const len = 22.0;
    const pad = 18.0;

    // Top-left
    canvas.drawLine(Offset(pad, pad + len), Offset(pad, pad), paint);
    canvas.drawLine(Offset(pad, pad), Offset(pad + len, pad), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - pad - len, pad), Offset(size.width - pad, pad), paint);
    canvas.drawLine(Offset(size.width - pad, pad), Offset(size.width - pad, pad + len), paint);

    // Bottom-left
    canvas.drawLine(Offset(pad, size.height - pad - len), Offset(pad, size.height - pad), paint);
    canvas.drawLine(Offset(pad, size.height - pad), Offset(pad + len, size.height - pad), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - pad - len, size.height - pad), Offset(size.width - pad, size.height - pad), paint);
    canvas.drawLine(Offset(size.width - pad, size.height - pad), Offset(size.width - pad, size.height - pad - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  PAINTER: Arc-based spinner (draws a partial circle arc)
// ─────────────────────────────────────────────────────────────────────────────
class _ArcSpinnerPainter extends CustomPainter {
  final Color color;
  const _ArcSpinnerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw a 270° arc (leaves a 90° gap — classic spinner shape)
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,        // start angle: 12 o'clock
      1.5 * math.pi,       // sweep: 270°
      false,
      paint,
    );

    // Faded tail — gives a comet-trail effect
    final fadePaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      math.pi,             // start at 6 o'clock
      0.5 * math.pi,       // 90° tail
      false,
      fadePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}