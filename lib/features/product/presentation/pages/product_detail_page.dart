import 'package:codan/features/product/presentation/bloc/product_bloc.dart';
import 'package:codan/features/product/presentation/bloc/product_event.dart';
import 'package:codan/features/product/presentation/bloc/product_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../offer/presentation/bloc/offer_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart';
import '../../../wishlist/presentation/bloc/wishlist_state.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Product _currentProduct;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    // Load fresh details (views, messages count, etc)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(LoadProductDetail(_currentProduct.id.toString()));
    });
  }

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
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductOperationSuccess && state.product != null) {
          if (state.product!.id == _currentProduct.id) {
            setState(() {
              _currentProduct = state.product!;
            });
            AppSnackBar.showSuccess(context, state.message);
          }
        } else if (state is ProductDetailLoaded) {
          if (state.product.id == _currentProduct.id) {
            setState(() {
              _currentProduct = state.product;
            });
          }
        } else if (state is ProductOperationError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      child: Scaffold(
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
                        // Title
                        Text(
                          _currentProduct.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontFamily: 'Rubik',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${_currentProduct.price.toStringAsFixed(0)}${_currentProduct.type == 'rent' ? ' / ${_formatPeriod(_currentProduct.rentalPeriod)}' : ''}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Stats Row
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _buildStatItem(Icons.location_on_outlined, _currentProduct.location),
                            _buildStatItem(Icons.visibility_outlined, '${_currentProduct.views} dilihat'),
                            _buildStatItem(Icons.chat_bubble_outline_rounded, '${_currentProduct.messages} pesan'),
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
                            _currentProduct.type == 'rent' ? 'Disewakan' : (_currentProduct.condition.toLowerCase().contains('bekas') || _currentProduct.condition.toLowerCase().contains('used') ? 'Bekas' : 'Baru'),
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
                          _currentProduct.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                        // Review Section — only for non-owners
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            final currentUser = authState is Authenticated ? authState.user : null;
                            final isOwnProduct = currentUser?.id != null &&
                                (currentUser?.id == _currentProduct.seller.id ||
                                    currentUser?.id == _currentProduct.userId);
                            if (isOwnProduct) return const SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 28),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Ulasan Penjual',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => context.push(
                                        '/reviews/${_currentProduct.seller.id}?name=${Uri.encodeComponent(_currentProduct.seller.name)}',
                                      ),
                                      icon: const Icon(Icons.star_border_rounded, size: 16),
                                      label: const Text('Lihat Semua'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => context.push('/write-review', extra: {
                                      'revieweeId': _currentProduct.seller.id,
                                      'produkId': _currentProduct.id,
                                      'sellerName': _currentProduct.seller.name,
                                      'productName': _currentProduct.title,
                                    }),
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    label: const Text('Tulis Ulasan untuk Penjual'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 150), // Bottom space for bar
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
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'product_image_${_currentProduct.id}',
          child: _currentProduct.imageUrl != null && _currentProduct.imageUrl!.startsWith('http')
              ? Image.network(
                  _currentProduct.imageUrl!,
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
              : (_currentProduct.imageUrl != null && _currentProduct.imageUrl!.isNotEmpty
                  ? Image.asset(
                      _currentProduct.imageUrl!,
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
        if (_currentProduct.status == 'sold' || _currentProduct.status == 'rented')
          Positioned(
            top: 100,
            left: -30,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                color: Colors.red.withValues(alpha: 0.8),
                child: Text(
                  _currentProduct.type == 'rent' ? 'SUDAH DISEWA' : 'TERJUAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
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
                Row(
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        final currentUser = authState is Authenticated ? authState.user : null;
                        final isOwnProduct = currentUser?.id != null && (currentUser?.id == _currentProduct.seller.id || currentUser?.id == _currentProduct.userId);
                        
                        if (isOwnProduct) {
                          return _buildCircleButton(
                            icon: Icons.edit_outlined,
                            onTap: () => context.push('/edit-product', extra: _currentProduct),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, state) {
                        bool isLiked = _currentProduct.isLiked;
                        if (state is WishlistLoaded) {
                          isLiked = state.wishlist.any((p) => p.id == _currentProduct.id);
                        } else if (state is WishlistToggleSuccess && state.produkId == _currentProduct.id) {
                          isLiked = state.isAdded;
                        }
                        
                        return _buildCircleButton(
                          icon: isLiked ? Icons.favorite : Icons.favorite_border,
                          iconColor: isLiked ? Colors.red : AppColors.textPrimary,
                          onTap: () {
                            context.read<WishlistBloc>().add(ToggleWishlistEvent(_currentProduct.id));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
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
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 20),
      ),
    );
  }


  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerCard() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUser = authState is Authenticated ? authState.user : null;
        final sellerName = (_currentProduct.seller.name == 'Penjual' && currentUser != null && (_currentProduct.seller.id == currentUser.id || _currentProduct.userId == currentUser.id))
            ? currentUser.name
            : _currentProduct.seller.name;
        
        return GestureDetector(
          onTap: () => context.push(
            '/seller-profile',
            extra: _currentProduct.seller,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                _currentProduct.seller.avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: _currentProduct.seller.avatarUrl!,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 25,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              sellerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_currentProduct.seller.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 16, color: Colors.blue),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentProduct.seller.major} • ⭐ ${_currentProduct.seller.rating}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                    const SizedBox(height: 2),
                    Text(
                      'Lihat Ulasan',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openWhatsApp() async {
    final phone = _currentProduct.seller.phone;
    if (phone == null || phone.isEmpty) {
      AppSnackBar.showError(context, 'Nomor WhatsApp penjual tidak tersedia');
      return;
    }

    // Format number: remove non-digits, replace leading 0 with 62
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }

    final message = Uri.encodeComponent('Halo ${_currentProduct.seller.name}, saya tertarik dengan produk "${_currentProduct.title}" di CODan. Apakah masih tersedia?');
    final url = Uri.parse('https://wa.me/$cleanPhone?text=$message');

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        AppSnackBar.showError(context, 'Gagal membuka WhatsApp. Pastikan aplikasi terpasang.');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Tidak dapat membuka WhatsApp: $e');
      }
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUser = authState is Authenticated ? authState.user : null;
        final isOwnProduct = currentUser?.id != null && (currentUser?.id == _currentProduct.seller.id || currentUser?.id == _currentProduct.userId);

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (isOwnProduct) ...[
                    Expanded(
                      flex: 3,
                      child: _currentProduct.status == 'active'
                          ? ElevatedButton.icon(
                              onPressed: () => _markAsSold(context),
                              icon: const Icon(Icons.check_circle_outline, size: 18),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(_currentProduct.type == 'rent' ? 'Sudah Disewa' : 'Terjual'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => _markAsAvailable(context),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Tersedia Kembali'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    _buildCircleButton(
                      icon: Icons.edit_outlined,
                      onTap: () => context.push('/edit-product', extra: _currentProduct),
                    ),
                    const SizedBox(width: 8),
                    _buildCircleButton(
                      icon: Icons.delete_outline,
                      iconColor: Colors.red,
                      onTap: () => _showDeleteConfirmation(context),
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        context.push('/chat/detail', extra: {
                          'produk_id': _currentProduct.id,
                          'partner_id': _currentProduct.seller.id,
                          'name': _currentProduct.seller.name,
                          'avatar': _currentProduct.seller.avatarUrl ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_currentProduct.seller.name)}&background=random&color=fff',
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
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: _openWhatsApp,
                        icon: Icon(Icons.chat_outlined, size: 20, color: Colors.green),
                        label: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('WA'),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          side: const BorderSide(color: Colors.green),
                          foregroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
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
                            context.read<OfferBloc>().add(CreateOfferEvent(
                              produkId: _currentProduct.id,
                              offerPrice: _currentProduct.price,
                              message: 'Saya ingin ${_currentProduct.type == 'rent' ? 'menyewa' : 'membeli'} produk ini.',
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
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _currentProduct.type == 'rent' ? 'Sewa Sekarang' : 'Beli Sekarang',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _markAsAvailable(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Aktifkan Kembali', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menandai produk ini sebagai tersedia kembali?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(UpdateProductEvent(_currentProduct.id, {
                'status': 'active'
              }));
              Navigator.pop(dialogContext); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Aktifkan'),
          ),
        ],
      ),
    );
  }

  void _markAsSold(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(_currentProduct.type == 'rent' ? 'Tandai Sudah Disewa' : 'Tandai Terjual', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menandai produk ini sebagai ${_currentProduct.type == 'rent' ? 'sudah disewa' : 'terjual'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(UpdateProductEvent(_currentProduct.id, {
                'status': _currentProduct.type == 'rent' ? 'rented' : 'sold'
              }));
              Navigator.pop(dialogContext); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Tandai'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(DeleteProductEvent(_currentProduct.id));
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Back to previous page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
