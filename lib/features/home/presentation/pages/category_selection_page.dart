import 'package:codan/features/product/presentation/bloc/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_state.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        int buku = 0;
        int elektronik = 0;
        int fashion = 0;
        int kendaraan = 0;
        int gaming = 0;
        int lainnya = 0;
        int sewa = 0;

        if (state is ProductLoaded) {
          // Hanya hitung barang yang statusnya aktif (berdasarkan yang diupload seller)
          final activeProducts = state.products.where((p) => p.status == 'active').toList();
          
          buku = activeProducts.where((p) => p.category == 'Buku' && p.type == 'sell').length;
          elektronik = activeProducts.where((p) => p.category == 'Elektronik' && p.type == 'sell').length;
          fashion = activeProducts.where((p) => p.category == 'Fashion' && p.type == 'sell').length;
          kendaraan = activeProducts.where((p) => p.category == 'Kendaraan' && p.type == 'sell').length;
          gaming = activeProducts.where((p) => p.category == 'Gaming' && p.type == 'sell').length;
          sewa = activeProducts.where((p) => p.type == 'rent').length;
          
          final knownCategories = ['Buku', 'Elektronik', 'Fashion', 'Kendaraan', 'Gaming'];
          lainnya = activeProducts.where((p) => p.type == 'sell' && !knownCategories.contains(p.category)).length;
        }

        final List<Map<String, dynamic>> categories = [
          {'label': 'Buku', 'icon': Icons.book_rounded, 'color': Colors.blue, 'bg': AppColors.accentBlue, 'count': buku},
          {'label': 'Elektronik', 'icon': Icons.laptop_rounded, 'color': AppColors.primary, 'bg': AppColors.primaryLight, 'count': elektronik},
          {'label': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': Colors.pinkAccent, 'bg': AppColors.accentPink, 'count': fashion},
          {'label': 'Kendaraan', 'icon': Icons.directions_car_rounded, 'color': Colors.orange, 'bg': AppColors.accentOrange, 'count': kendaraan},
          {'label': 'Gaming', 'icon': Icons.sports_esports_rounded, 'color': Colors.green, 'bg': AppColors.accentGreen, 'count': gaming},
          {'label': 'Lainnya', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey, 'bg': Colors.grey.shade100, 'count': lainnya},
          {'label': 'Sewa Barang', 'icon': Icons.swap_horiz_rounded, 'color': const Color(0xFF7E57C2), 'bg': const Color(0xFFF3E5F5), 'count': sewa},
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
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductBloc>().add(const LoadProducts());
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
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
                  onTap: () {
                    if (cat['label'] == 'Sewa Barang') {
                      context.push('/marketplace?category=rent');
                    } else {
                      context.push('/marketplace?category=${cat['label']}');
                    }
                  },
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
          ),
        );
      },
    );
  }
}
