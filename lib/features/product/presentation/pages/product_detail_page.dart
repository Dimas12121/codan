import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../offer/presentation/bloc/offer_bloc.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  String _formatPeriod(String? period) {
    switch (period) {
      case 'daily': return 'Hari';
      case 'weekly': return 'Minggu';
      case 'monthly': return 'Bulan';
      default: return 'Hari';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                _buildProductImage(context),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text(
                        'Rp ${product.price.toStringAsFixed(0)}${product.type == 'rent' ? ' / ${_formatPeriod(product.rentalPeriod)}' : ''}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats Row
                      Row(
                        children: [
                          _buildStatItem(Icons.location_on_outlined, product.location),
                          const SizedBox(width: 16),
                          _buildStatItem(Icons.visibility_outlined, '${product.views} dilihat'),
                          const SizedBox(width: 16),
                          _buildStatItem(Icons.chat_bubble_outline_rounded, '${product.messages} pesan'),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Condition Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          product.type == 'rent' ? 'Disewakan' : (product.condition.toLowerCase().contains('bekas') || product.condition.toLowerCase().contains('used') ? 'Bekas' : 'Baru'),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Seller Info
                      _buildSellerCard(),
                      const SizedBox(height: 32),

                      // Description
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 120), // Bottom space for bar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'product_image_${product.id}',
          child: product.imageUrl != null && product.imageUrl!.startsWith('http')
              ? Image.network(
                  product.imageUrl!,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 48),
                  ),
                )
              : (product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.asset(
                      product.imageUrl!,
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 400,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 48),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 400,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 48),
                    )),
        ),
        // Overlay for better icon visibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Top Buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircleButton(
                  icon: product.isLiked ? Icons.favorite : Icons.favorite_border,
                  iconColor: product.isLiked ? Colors.red : AppColors.textPrimary,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        // Carousel dots placeholder
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              _buildDot(),
              const SizedBox(width: 4),
              _buildDot(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap, Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSellerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: product.seller.avatarUrl != null
                ? NetworkImage(product.seller.avatarUrl!)
                : null,
            child: product.seller.avatarUrl == null
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      product.seller.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (product.seller.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 16, color: Colors.blue),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.seller.major} • ⭐ ${product.seller.rating}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUser = authState is Authenticated ? authState.user : null;
        final isOwnProduct = currentUser?.id == product.seller.id;

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isOwnProduct) {
                      AppSnackBar.showInfo(context, 'Ini adalah produk Anda sendiri');
                      return;
                    }
                    context.push('/chat/detail', extra: {
                      'produk_id': product.id,
                      'partner_id': product.seller.id,
                      'name': product.seller.name,
                      'avatar': product.seller.avatarUrl ?? 'assets/images/user_placeholder.png',
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      AppSnackBar.showInfo(context, 'Fitur keranjang segera hadir!');
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: const Text('cart'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: BlocListener<OfferBloc, OfferState>(
                    listener: (context, state) {
                      if (state is OfferOperationSuccess) {
                        AppSnackBar.showSuccess(context, state.message);
                      } else if (state is OfferError) {
                        AppSnackBar.showError(context, state.message);
                      }
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        if (isOwnProduct) {
                          AppSnackBar.showInfo(context, 'Ini adalah produk Anda sendiri');
                          return;
                        }
                        
                        context.read<OfferBloc>().add(CreateOfferEvent(
                          produkId: product.id,
                          offerPrice: product.price,
                          message: 'Saya ingin ${product.type == 'rent' ? 'menyewa' : 'membeli'} produk ini.',
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: BlocBuilder<OfferBloc, OfferState>(
                        builder: (context, state) {
                          if (state is OfferLoading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            );
                          }
                          return Text(
                            product.type == 'rent' ? 'Sewa Sekarang' : 'Beli Sekarang',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
