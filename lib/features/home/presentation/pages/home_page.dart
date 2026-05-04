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
import '../widgets/product_shimmer.dart';

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
                            child: Row(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Colors.white, Colors.white70],
                                  ).createShader(bounds),
                                  child: const Icon(Icons.search, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                const Flexible(
                                  child: Text(
                                    'Cari barang dan lainnya',
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Colors.white, Colors.white70],
                                    ).createShader(bounds),
                                    child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                                  ),
                                  onPressed: () => context.push('/marketplace'),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                    gradient: LinearGradient(
                      colors: [
                        AppColors.heroBannerTeal,
                        AppColors.heroBannerTeal.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.heroBannerTeal.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Image(image: AssetImage('assets/images/key.png'))
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
                            GestureDetector(
                              onTap: () => context.push('/marketplace?category=Disewakan'),
                              child: Align(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/categories'),
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(fontSize: 13, color: AppColors.searchBarBackground, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
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
                buildWhen: (previous, current) => 
                    current is ProductLoading || 
                    current is ProductLoaded || 
                    current is ProductError,
                builder: (context, state) {
                  if (state is ProductLoading) return const ProductListShimmer();
                  if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: Text('Belum ada produk.')),
                      );
                    }
                    
                    // Show all products if less than 4, otherwise split
                    final bool hasMany = state.products.length > 3;
                    final recommendations = hasMany ? state.products.take(3).toList() : state.products;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 240,
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
                        ),
                        
                        if (hasMany) ...[
                          const SizedBox(height: 20),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: state.products.length - 3,
                              itemBuilder: (context, index) {
                                return ProductCard(product: state.products[index + 3]);
                              },
                            ),
                          ),
                        ],
                      ],
                    );
                  } else if (state is ProductError) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text('Gagal memuat: ${state.message}')),
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
