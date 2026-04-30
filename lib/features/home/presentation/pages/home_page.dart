import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import '../../domain/entities/product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> recommendations = [
      Product(
        id: '1',
        title: 'Berbagai hp second 2020-2022',
        price: '1.500.000-2.500.000',
        description: 'Berbagai macam hp second berkualitas tahun 2020 sampai 2022.',
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600&auto=format&fit=crop',
        category: 'Elektronik',
        condition: 'Bekas',
        location: 'Cibinong',
        views: '234',
        messages: '45',
        seller: Seller(name: 'Roy', avatarUrl: '', major: 'IT', rating: '5.0'),
      ),
      Product(
        id: '2',
        title: 'Honda Supra X 125',
        price: '6.500.000',
        description: 'Motor supra x 125 kondisi mulus.',
        imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f97cbba6c1?q=80&w=600&auto=format&fit=crop',
        category: 'Kendaraan',
        condition: 'Bekas',
        location: 'Cibinong',
        views: '128',
        messages: '12',
        seller: Seller(name: 'Budi', avatarUrl: '', major: 'Ekonomi', rating: '4.8'),
      ),
    ];

    final List<Product> others = [
      Product(
        id: '3',
        title: 'Berbagai hp 2020-2022',
        price: '25.000/Hari',
        description: 'Sewa hp harian.',
        imageUrl: 'https://images.unsplash.com/photo-1556656793-062ff987b50c?q=80&w=600&auto=format&fit=crop',
        category: 'Elektronik',
        condition: 'Disewakan',
        location: 'Cibinong',
        views: '1.2k',
        messages: '23',
        seller: Seller(name: 'Santi', avatarUrl: '', major: 'Hukum', rating: '4.7'),
      ),
      Product(
        id: '4',
        title: 'Hoodie dream',
        price: '150.000',
        description: 'Hoodie keren.',
        imageUrl: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=600&auto=format&fit=crop',
        category: 'Fashion',
        condition: 'New',
        location: 'Cibinong',
        views: '3.4k',
        messages: '12',
        seller: Seller(name: 'Andi', avatarUrl: '', major: 'Seni', rating: '4.9'),
      ),
      Product(
        id: '5',
        title: 'Proyektor BenQ',
        price: '45.000/Hari',
        description: 'Sewa proyektor.',
        imageUrl: 'https://images.unsplash.com/photo-1535016120720-40c646bebbdc?q=80&w=600&auto=format&fit=crop',
        category: 'Elektronik',
        condition: 'Disewakan',
        location: 'Cibinong',
        views: '890',
        messages: '45',
        seller: Seller(name: 'Dani', avatarUrl: '', major: 'Teknik', rating: '4.6'),
      ),
      Product(
        id: '6',
        title: 'Nike Air Force 1 Low Denim uk 42',
        price: '1.500.000',
        description: 'Sepatu nike original.',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop',
        category: 'Fashion',
        condition: 'Bekas',
        location: 'Cibinong',
        views: '450',
        messages: '15',
        seller: Seller(name: 'Anisa', avatarUrl: '', major: 'Sipil', rating: '4.8'),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    const Icon(Icons.notifications_none_rounded, color: AppColors.searchBarBackground, size: 28),
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
              SizedBox(
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
                    Text(
                      'Lihat semua',
                      style: TextStyle(fontSize: 13, color: AppColors.searchBarBackground, fontWeight: FontWeight.bold),
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
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: others.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: others[index]);
                  },
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
