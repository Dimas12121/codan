import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'label': 'Buku', 'icon': Icons.book_rounded, 'color': Colors.blue, 'bg': AppColors.accentBlue, 'count': 3},
      {'label': 'Elektronik', 'icon': Icons.laptop_rounded, 'color': AppColors.primary, 'bg': AppColors.primaryLight, 'count': 11},
      {'label': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': Colors.pinkAccent, 'bg': AppColors.accentPink, 'count': 3},
      {'label': 'Kendaraan', 'icon': Icons.directions_car_rounded, 'color': Colors.orange, 'bg': AppColors.accentOrange, 'count': 2},
      {'label': 'Gaming', 'icon': Icons.sports_esports_rounded, 'color': Colors.green, 'bg': AppColors.accentGreen, 'count': 2},
      {'label': 'Lainnya', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey, 'bg': Colors.grey.shade100, 'count': 1},
      {'label': 'Sewa Barang', 'icon': Icons.swap_horiz_rounded, 'color': const Color(0xFF7E57C2), 'bg': const Color(0xFFF3E5F5), 'count': 4},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Kategori',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => context.push('/marketplace?category=${cat['label']}'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: cat['bg'],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(cat['icon'], color: cat['color'], size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cat['label'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cat['count']} barang',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
