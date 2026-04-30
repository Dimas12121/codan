import 'package:codan/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:codan/features/notification/presentation/bloc/notification_event.dart';
import 'package:codan/features/notification/presentation/bloc/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_event.dart';
import '../../../product/presentation/bloc/product_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(const LoadProducts());
            context.read<NotificationBloc>().add(LoadNotifications());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Search Bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/search'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.searchBarBackground,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                SizedBox(width: 12),
                                Text(
                                  'Find Mobile Phones and more',
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.shopping_cart_outlined, color: AppColors.searchBarBackground, size: 28),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => context.push('/notifications'),
                        child: BlocBuilder<NotificationBloc, NotificationState>(
                          builder: (context, state) {
                            int unreadCount = 0;
                            if (state is NotificationLoaded) {
                              unreadCount = state.notifications.where((n) => n.readAt == null).length;
                            }
                            return Stack(
                              children: [
                                const Icon(Icons.notifications_none_rounded, color: AppColors.searchBarBackground, size: 28),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                      child: Text(
                                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Hero Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.heroBannerTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(Icons.vpn_key_outlined, size: 80, color: Colors.white24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kamu butuh alat untuk tugas namun enggan membelinya?',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Kamu bisa menyewa barang disini!',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.searchBarBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Lihat', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Kategori
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Kategori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  children: [
                    CategoryItem(
                      icon: Icons.book_rounded,
                      label: 'Buku',
                      onTap: () => context.push('/marketplace?category=Buku'),
                    ),
                    CategoryItem(
                      icon: Icons.checkroom_rounded,
                      label: 'Fashion',
                      onTap: () => context.push('/marketplace?category=Fashion'),
                    ),
                    CategoryItem(
                      icon: Icons.directions_car_rounded,
                      label: 'Kendaraan',
                      onTap: () => context.push('/marketplace?category=Kendaraan'),
                    ),
                    CategoryItem(
                      icon: Icons.laptop_rounded,
                      label: 'Elektronik',
                      onTap: () => context.push('/marketplace?category=Elektronik'),
                    ),
                    CategoryItem(
                      icon: Icons.history_rounded,
                      label: 'Disewakan',
                      onTap: () => context.push('/marketplace?category=Disewakan'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Rekomendasi
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Rekomendasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const SizedBox(
                      height: 290,
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  } else if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return const SizedBox(
                        height: 290,
                        child: Center(child: Text('Belum ada produk.')),
                      );
                    }
                    
                    // Ambil maksimal 3 produk untuk rekomendasi
                    final recommendations = state.products.take(3).toList();
                    
                    return SizedBox(
                      height: 290,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 190,
                            margin: const EdgeInsets.only(right: 16),
                            child: ProductCard(product: recommendations[index]),
                          );
                        },
                      ),
                    );
                  } else if (state is ProductError) {
                    return SizedBox(
                      height: 290,
                      child: Center(child: Text('Gagal memuat: ${state.message}')),
                    );
                  }
                  
                  return const SizedBox(height: 290);
                },
              ),


              const SizedBox(height: 20),

              // Lainnya
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lainnya',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/marketplace'),
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(fontSize: 13, color: AppColors.searchBarBackground, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoaded) {
                    // Ambil sisa produk setelah 3 produk pertama
                    final others = state.products.skip(3).toList();
                    
                    if (others.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: Text('Tidak ada produk lainnya.')),
                      );
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: others.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: others[index]);
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    ),
  );
}
}
