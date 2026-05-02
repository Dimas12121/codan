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
      case 'daily':
        return 'Hari';
      case 'weekly':
        return 'Minggu';
      case 'monthly':
        return 'Bulan';
      default:
        return 'Hari';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
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
            /// 🔥 IMAGE (FLEXIBLE)
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Hero(
                      tag: 'product_image_${product.id}',
                      child: product.imageUrl != null &&
                              product.imageUrl!.startsWith('http')
                          ? Image.network(
                              product.imageUrl!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildFallbackImage(),
                            )
                          : (product.imageUrl != null &&
                                  product.imageUrl!.isNotEmpty
                              ? Image.asset(
                                  product.imageUrl!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildFallbackImage(),
                                )
                              : _buildFallbackImage()),
                    ),
                  ),

                  /// ❤️ WISHLIST BUTTON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, state) {
                        bool isLiked = product.isLiked;

                        if (state is WishlistLoaded) {
                          isLiked = state.wishlist
                              .any((p) => p.id == product.id);
                        } else if (state is WishlistToggleSuccess &&
                            state.produkId == product.id) {
                          isLiked = state.isAdded;
                        }

                        return GestureDetector(
                          onTap: () {
                            context
                                .read<WishlistBloc>()
                                .add(ToggleWishlistEvent(product.id));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color:
                                  isLiked ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// STATUS (TERJUAL / DISEWA)
                  if (product.status == 'sold' ||
                      product.status == 'rented')
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 4),
                        color: Colors.black.withValues(alpha: 0.6),
                        child: Text(
                          product.type == 'rent'
                              ? 'SUDAH DISEWA'
                              : 'TERJUAL',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// 🔥 CONTENT
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// PRICE
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}${(product.type == 'rent' || product.rentalPeriod != null) ? ' / ${_formatPeriod(product.rentalPeriod)}' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// TAG
                  Row(
                    children: [
                      if (product.type == 'rent')
                        _buildTag(
                          'Disewakan',
                          backgroundColor: const Color(0xFFF9F07A),
                          textColor: const Color(0xFF8B8000),
                        )
                      else ...[
                        _buildTag(
                          product.condition
                                      .toLowerCase()
                                      .contains('bekas') ||
                                  product.condition
                                      .toLowerCase()
                                      .contains('used')
                              ? 'Second'
                              : 'New',
                        ),
                        const SizedBox(width: 4),
                        _buildTag('10/10'),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// LOCATION + TIME
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          product.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Hari ini',
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey),
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

  Widget _buildTag(String text,
      {Color? backgroundColor, Color? textColor}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE0E0FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: textColor ?? AppColors.priceBlue,
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
      ),
    );
  }
}