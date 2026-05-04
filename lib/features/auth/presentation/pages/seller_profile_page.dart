import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_event.dart';
import '../../../product/presentation/bloc/product_state.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../../../product/domain/entities/product.dart';

class SellerProfilePage extends StatefulWidget {
  final Seller seller;

  const SellerProfilePage({super.key, required this.seller});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final ScrollController _scrollController = ScrollController();
  double _avatarOffset = 0.0;
  double _avatarOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Dynamic avatar positioning logic
    double offset = _scrollController.offset;
    setState(() {
      _avatarOffset = offset;
      // Fade out avatar when it reaches the pinned app bar area
      _avatarOpacity = (1 - (offset / 100)).clamp(0.0, 1.0);
    });
  }

  Future<void> _openWhatsApp() async {
    final phone = widget.seller.phone;
    if (phone == null || phone.isEmpty) {
      AppSnackBar.showError(context, 'Nomor WhatsApp tidak tersedia');
      return;
    }

    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) cleanPhone = '62${cleanPhone.substring(1)}';

    final url = Uri.parse('https://wa.me/$cleanPhone');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) AppSnackBar.showError(context, 'Gagal membuka WhatsApp');
      }
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 240.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // 1. MAIN SCROLL VIEW
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: appBarHeight,
                pinned: true,
                backgroundColor: AppColors.primary,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, Color(0xFF4F46E5)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -40,
                          right: -20,
                          child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Seller Card Content
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 65, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.seller.name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                          ),
                          if (widget.seller.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.verified_rounded, color: Color(0xFF3B82F6), size: 22),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          widget.seller.major,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildImprovedStat(Icons.star_rounded, 'Rating', widget.seller.rating, Colors.orange),
                          _buildDivider(),
                          _buildImprovedStat(Icons.shopping_bag_rounded, 'Produk', 'Aktif', Colors.blue),
                          _buildDivider(),
                          _buildImprovedStat(Icons.verified_user_rounded, 'Status', 'Verified', Colors.green),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildPrimaryAction(
                        label: 'Hubungi WhatsApp',
                        icon: Icons.chat_rounded,
                        color: const Color(0xFF22C55E),
                        onTap: _openWhatsApp,
                      ),
                    ],
                  ),
                ),
              ),

              // Catalog Title
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Katalog Produk',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Grid
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        height: 200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  if (state is ProductLoaded) {
                    final products = state.products.where((p) => p.seller.id == widget.seller.id || p.userId == widget.seller.id).toList();
                    
                    if (products.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Column(
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade200),
                              const SizedBox(height: 16),
                              Text('Belum ada produk aktif', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProductCard(product: products[index]),
                          childCount: products.length,
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),

          // 2. THE FLOATING AVATAR (PALING DEPAN)
          Positioned(
            top: (appBarHeight - 40) - _avatarOffset,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: _avatarOpacity,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Hero(
                    tag: 'seller_avatar_${widget.seller.id}',
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey.shade100,
                      child: widget.seller.avatarUrl != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: widget.seller.avatarUrl!,
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              widget.seller.name.isNotEmpty ? widget.seller.name[0].toUpperCase() : '?',
                              style: const TextStyle(fontSize: 38, color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovedStat(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: const Color(0xFFF1F5F9));
  }

  Widget _buildPrimaryAction({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
