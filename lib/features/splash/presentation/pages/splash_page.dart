import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Phase 1 — logo turun dari atas layar ke tengah (0% → 50%)
  late final Animation<double> _slideAnim;

  // Phase 2 — logo diam sebentar lalu zoom fill screen (65% → 100%)
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Slide dari -500px (di atas layar) → 0 (tengah)
    _slideAnim = Tween<double>(begin: -500.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOutCubic),
      ),
    );

    // Zoom dari ukuran normal (1.0) → sangat besar (40x) hingga memenuhi layar
    _scaleAnim = Tween<double>(begin: 1.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1.0, curve: Curves.easeInCubic),
      ),
    );

    // Navigasi ke splash screen kedua setelah animasi selesai
    _controller.forward().then((_) {
      if (mounted) context.go('/splash2');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ClipRect(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnim.value),
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: child,
                ),
              );
            },
            child: _buildLogo(),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 214.72,
      height: 128.40,
      child: Image.asset(
        'assets/images/splash_logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
