import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 90),
            painter: NavbarPainter(),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, 'HOME'),
                _buildNavItem(1, Icons.list_alt_rounded, 'MARKET'),
                const SizedBox(width: 60), // Space for FAB
                _buildNavItem(3, Icons.chat_bubble_outline_rounded, 'CHAT'),
                _buildNavItem(4, Icons.person_outline_rounded, 'PROFILE'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.navbarActive : AppColors.navbarInactive;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.navbarActive,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            const SizedBox(height: 2),
          const SizedBox(height: 8),
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class NavbarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.navbarBackground
      ..style = PaintingStyle.fill;

    Path path = Path();
    double cornerRadius = 30;
    double notchWidth = 100;
    double notchHeight = 40;
    double curveWidth = 40;

    // Start from bottom left
    path.moveTo(0, size.height);
    // Line to bottom right
    path.lineTo(size.width, size.height);
    // Line to top right (rounded)
    path.lineTo(size.width, cornerRadius);
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);
    
    // Line to the start of the notch curve
    double startNotch = (size.width - notchWidth) / 2;
    path.lineTo(startNotch + curveWidth, 0);
    
    // Notch curve (smooth concave)
    path.quadraticBezierTo(
      startNotch + notchWidth / 2,
      notchHeight,
      size.width - (startNotch + curveWidth),
      0,
    );

    // Line to top left (rounded)
    path.lineTo(cornerRadius, 0);
    path.quadraticBezierTo(0, 0, 0, cornerRadius);
    
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
