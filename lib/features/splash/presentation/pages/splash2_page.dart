import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash2Page extends StatefulWidget {
  const Splash2Page({super.key});

  @override
  State<Splash2Page> createState() => _Splash2PageState();
}

class _Splash2PageState extends State<Splash2Page>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Background: biru → putih
  late final Animation<Color?> _bgColorAnim;

  // Setiap huruf: list karakter yang di-scroll (slot reel)
  static const List<String> _finalLetters = ['C', 'O', 'D', 'A', 'N'];
  static const double _charHeight = 64.0;
  static const int _spinCount = 10; // jumlah karakter acak sebelum final
  static const String _charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  late final List<List<String>> _reelChars;
  late final List<Animation<double>> _reelAnims;
  late final Animation<double> _globalFade;
  late final Animation<double> _subtitleFade;
  late final List<Animation<double>> _merapatAnims; // horizontal merapat

  final _random = Random(42);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Background biru → putih (0% → 22%)
    _bgColorAnim = ColorTween(begin: const Color(0xFF3E3AE5), end: Colors.white)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.22, curve: Curves.easeOut),
          ),
        );

    // Semua huruf fade-in (18% → 38%)
    _globalFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.38, curve: Curves.easeOut),
      ),
    );
    // Animasi merapat: tiap huruf bergerak dari posisi tersebar → normal
    // Dimulai saat reel terakhir hampir berhenti (82% → 97%)
    // Spread: huruf paling pinggir mulai 30px lebih jauh dari pusat (sebelumnya 60px)
    const double spread = 15.0; // px extra spacing per slot dari pusat
    _merapatAnims = List.generate(_finalLetters.length, (i) {
      // index relatif terhadap pusat: C=-2, O=-1, D=0, A=+1, N=+2
      final double centerRel = i - (_finalLetters.length - 1) / 2.0;
      return Tween<double>(
        begin: centerRel * spread, // posisi tersebar
        end: 0.0, // posisi normal (rapat)
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.82, 0.97, curve: Curves.easeInOut),
        ),
      );
    });

    // Subtitle muncul setelah semua reel berhenti (88% → 100%)
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.88, 1.0, curve: Curves.easeOut),
      ),
    );
    _reelChars = [];
    _reelAnims = [];

    for (int i = 0; i < _finalLetters.length; i++) {
      // List: [acak × spinCount] + [huruf final]
      final chars = List.generate(
        _spinCount,
        (_) => _charset[_random.nextInt(_charset.length)],
      )..add(_finalLetters[i]);
      _reelChars.add(chars);

      // Stagger: tiap reel berhenti 130ms setelah reel sebelumnya
      // Reel pertama: 30% → 58%, terakhir: 72% → 94%
      final double startT = 0.30 + i * 0.09;
      final double endT = (startT + 0.36).clamp(0.0, 0.97);

      _reelAnims.add(
        Tween<double>(
          begin: 0.0,
          end:
              -(_spinCount * _charHeight), // scroll ke bawah sampai huruf final
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(startT, endT, curve: Curves.easeOut),
          ),
        ),
      );
    }

    _controller.forward().then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            // Check authentication status and navigate accordingly
            // This will be handled by the router's redirect logic
            context.go('/');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _bgColorAnim.value,
          body: Center(
            child: Opacity(
              opacity: _globalFade.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Baris huruf slot
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_finalLetters.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.5),
                        child: _buildReel(i),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle: MARKETPLACE
                  Opacity(
                    opacity: _subtitleFade.value,
                    child: const Text(
                      'MARKETPLACE',
                      style: TextStyle(
                        color: Color(0xFF3E3AE5),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle: jual beli & sewa
                  Opacity(
                    opacity: _subtitleFade.value,
                    child: const Text(
                      'jual beli & sewa',
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReel(int i) {
    return AnimatedBuilder(
      animation: _merapatAnims[i],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_merapatAnims[i].value, 0),
          child: child,
        );
      },
      child: SizedBox(
        width: 48,
        height: _charHeight,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: 0,
            maxHeight: double.infinity,
            child: AnimatedBuilder(
              animation: _reelAnims[i],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _reelAnims[i].value),
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _reelChars[i].map((char) {
                  return SizedBox(
                    height: _charHeight,
                    child: Center(
                      child: Text(
                        char,
                        style: const TextStyle(
                          color: Color(0xFF3E3AE5),
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
