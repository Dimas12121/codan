import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/offer_bloc.dart';
import '../../domain/entities/offer.dart';

class BuyerOrdersPage extends StatefulWidget {
  const BuyerOrdersPage({super.key});

  @override
  State<BuyerOrdersPage> createState() => _BuyerOrdersPageState();
}

class _BuyerOrdersPageState extends State<BuyerOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOffers();
  }

  void _loadOffers() {
    // Load 'sent' — offers the current user sent as a buyer
    context.read<OfferBloc>().add(const LoadOffers('sent'));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: _loadOffers,
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Menunggu'),
            Tab(text: 'Diterima'),
            Tab(text: 'Ditolak'),
          ],
        ),
      ),
      body: BlocBuilder<OfferBloc, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is OfferError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadOffers,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: const Text('Coba Lagi',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          if (state is OffersLoaded) {
            final pending =
                state.offers.where((o) => o.status == 'pending').toList();
            final accepted =
                state.offers.where((o) => o.status == 'accepted').toList();
            final rejected =
                state.offers.where((o) => o.status == 'rejected').toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(pending, 'pending'),
                _buildOrderList(accepted, 'accepted'),
                _buildOrderList(rejected, 'rejected'),
              ],
            );
          }

          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        },
      ),
    );
  }

  Widget _buildOrderList(List<Offer> offers, String status) {
    if (offers.isEmpty) {
      final icons = {
        'pending': Icons.hourglass_empty_rounded,
        'accepted': Icons.check_circle_outline_rounded,
        'rejected': Icons.cancel_outlined,
      };
      final messages = {
        'pending': 'Tidak ada penawaran yang menunggu',
        'accepted': 'Belum ada penawaran yang diterima',
        'rejected': 'Tidak ada penawaran yang ditolak',
      };

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icons[status], size: 56, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              messages[status]!,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Temukan produk menarik dan ajukan penawaran!',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.go('/marketplace'),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Jelajahi Produk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadOffers(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: offers.length,
        itemBuilder: (context, index) => _buildOrderCard(offers[index]),
      ),
    );
  }

  Widget _buildOrderCard(Offer offer) {
    final statusColor = offer.status == 'pending'
        ? Colors.orange
        : offer.status == 'accepted'
            ? Colors.green
            : Colors.red;

    final statusLabel = offer.status == 'pending'
        ? 'Menunggu Respons'
        : offer.status == 'accepted'
            ? 'Penawaran Diterima ✓'
            : 'Penawaran Ditolak ✗';

    final statusIcon = offer.status == 'pending'
        ? Icons.schedule_rounded
        : offer.status == 'accepted'
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: offer.status == 'accepted'
            ? Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge + Date
            Row(
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(offer.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Product info
            if (offer.product != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image or placeholder
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                    ),
                    child: offer.product!.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              offer.product!.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, e, st) => const Icon(
                                  Icons.image_outlined,
                                  color: AppColors.primary),
                            ),
                          )
                        : const Icon(Icons.shopping_bag_outlined,
                            color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.product!.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Harga Asli: ${_formatPrice(offer.product!.price)}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Offer price highlight
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primary.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Penawaran Anda: ',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    _formatPrice(offer.offerPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Buyer message
            if (offer.message != null && offer.message!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '"${offer.message}"',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontStyle: FontStyle.italic),
              ),
            ],

            // If accepted — show contact seller & review buttons
            if (offer.status == 'accepted' && offer.product != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to chat with seller
                        context.push('/chat/detail', extra: {
                          'produk_id': offer.produkId,
                          'partner_id': offer.product!.seller.id,
                          'name': offer.product!.seller.name,
                          'avatar': offer.product!.seller.avatarUrl ?? '',
                        });
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                      label: const Text('Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(
                          '/write-review',
                          extra: {
                            'revieweeId': offer.product!.seller.id,
                            'produkId': offer.produkId,
                            'sellerName': offer.product!.seller.name,
                            'productName': offer.product!.title,
                          },
                        );
                      },
                      icon: const Icon(Icons.star_outline_rounded, size: 18),
                      label: const Text('Ulas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan','Feb','Mar','Apr','Mei','Jun',
      'Jul','Agu','Sep','Okt','Nov','Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
