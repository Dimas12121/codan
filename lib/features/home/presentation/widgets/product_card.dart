import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart';
import '../../../wishlist/presentation/bloc/wishlist_state.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Hero(
                    tag: 'product_image_${product.id}',
                    child: product.imageUrl != null && product.imageUrl!.startsWith('http')
                        ? Image.network(
                            product.imageUrl!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildFallbackImage(height: 140),
                          )
                        : (product.imageUrl != null && product.imageUrl!.isNotEmpty
                            ? Image.asset(
                                product.imageUrl!,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildFallbackImage(height: 140),
                              )
                            : _buildFallbackImage(height: 140)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      // Note: In a real app, you'd check if this specific product is liked
                      // based on the global wishlist state or local product state
                      return GestureDetector(
                        onTap: () {
                          context.read<WishlistBloc>().add(ToggleWishlistEvent(product.id));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            product.isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: product.isLiked ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}${product.type == 'rent' ? ' / ${_formatPeriod(product.rentalPeriod)}' : ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.priceBlue,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (product.type == 'rent')
                        _buildTag('Disewakan', backgroundColor: const Color(0xFFF9F07A), textColor: const Color(0xFF8B8000))
                      else ...[
                        _buildTag(product.condition.toLowerCase().contains('bekas') || product.condition.toLowerCase().contains('used') ? 'Second' : 'New'),
                        const SizedBox(width: 4),
                        _buildTag('10/10'),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            product.location.length > 10
                                ? '${product.location.substring(0, 10)}...'
                                : product.location,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Text(
                        'Hari ini',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
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

  Widget _buildTag(String text, {Color? backgroundColor, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE0E0FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor ?? AppColors.priceBlue,
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
