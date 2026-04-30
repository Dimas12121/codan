import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/product.dart';
import 'product_detail_page.dart';

class RentPage extends StatelessWidget {
  const RentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> rentalItems = [
      Product(
        id: 'r1',
        title: 'MacBook Pro 14" M2 Pro',
        price: '75.000',
        description: 'MacBook Pro 14 inch dengan chip M2 Pro. Performa monster untuk editing video dan programming. Kondisi terawat.',
        imageUrl: 'images/macbook_featured.png',
        category: 'Laptop',
        condition: 'Bekas - Seperti Baru',
        location: '1.2 km',
        views: '1.2k',
        messages: '89',
        seller: Seller(
          name: 'Andi Pratama',
          avatarUrl: 'https://ui-avatars.com/api/?name=Andi+Pratama&background=7E57C2&color=fff',
          major: 'Teknik Informatika',
          rating: '4.9',
          isVerified: true,
        ),
      ),
      Product(
        id: 'r2',
        title: 'Sony A6400 + Lens 18-135mm',
        price: '120.000',
        description: 'Kamera mirrorless Sony A6400 dengan lensa serbaguna 18-135mm. Cocok untuk dokumentasi acara atau hunting foto.',
        imageUrl: 'images/sony_camera.png',
        category: 'Kamera',
        condition: 'Bekas - Seperti Baru',
        location: '0.8 km',
        views: '856',
        messages: '34',
        seller: Seller(
          name: 'Sarah Wijaya',
          avatarUrl: 'https://ui-avatars.com/api/?name=Sarah+Wijaya&background=7E57C2&color=fff',
          major: 'Desain Komunikasi Visual',
          rating: '4.8',
          isVerified: true,
        ),
      ),
      Product(
        id: 'r3',
        title: 'Proyektor Epson EB-X500',
        price: '60.000',
        description: 'Proyektor Epson terang 3600 lumens. Resolusi XGA. Cocok untuk presentasi di kelas atau nonton bareng.',
        imageUrl: 'images/projector.png',
        category: 'Proyektor',
        condition: 'Bekas - Baik',
        location: '2.5 km',
        views: '432',
        messages: '15',
        seller: Seller(
          name: 'Budi Setiawan',
          avatarUrl: 'https://ui-avatars.com/api/?name=Budi+Setiawan&background=7E57C2&color=fff',
          major: 'Sistem Informasi',
          rating: '4.5',
          isVerified: true,
        ),
      ),
      Product(
        id: 'r4',
        title: 'Buku Paket Statistik Semester 3',
        price: '15.000',
        description: 'Buku paket statistika untuk mahasiswa semester 3. Kondisi masih sangat bagus dan lengkap.',
        imageUrl: 'images/statistics_book.png',
        category: 'Buku',
        condition: 'Bekas - Layak Pakai',
        location: '0.5 km',
        views: '210',
        messages: '5',
        seller: Seller(
          name: 'Rina Kartika',
          avatarUrl: 'https://ui-avatars.com/api/?name=Rina+Kartika&background=7E57C2&color=fff',
          major: 'Manajemen',
          rating: '4.7',
          isVerified: false,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Sewa & Pinjam',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pinjam barang kampus tanpa harus beli',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Semua', isSelected: true),
                    _buildCategoryChip('Laptop', icon: Icons.laptop_rounded),
                    _buildCategoryChip('Kamera', icon: Icons.camera_alt_rounded),
                    _buildCategoryChip('Proyektor', icon: Icons.videocam_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Featured Card
              _buildFeaturedCard(context, rentalItems[0]),
              const SizedBox(height: 32),

              // Available for Rent List
              const Text(
                'Tersedia untuk Disewa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...rentalItems.map((item) => _buildRentListItem(context, item)),
              const SizedBox(height: 80), // Bottom padding for Navbar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {IconData? icon, bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.primary),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: product.imageUrl.startsWith('http')
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
                    )
                  : Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'POPULER',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Hero(
                tag: 'product_title_${product.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp ${product.price}/hari',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${product.seller.rating} (${product.messages} sewa)',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentListItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                tag: 'product_image_${product.id}',
                child: product.imageUrl.startsWith('http')
                    ? Image.network(
                        product.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(width: 90, height: 90),
                      )
                    : Image.asset(
                        product.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(width: 90, height: 90),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${product.seller.rating} • ${product.views} dilihat',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(product.seller.avatarUrl),
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          product.seller.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.seller.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 14, color: Colors.blue),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${product.price}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  '/hari',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage({double? width, double? height}) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}
