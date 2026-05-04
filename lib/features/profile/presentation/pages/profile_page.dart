import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:codan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:codan/features/auth/presentation/bloc/auth_event.dart';
import 'package:codan/features/auth/presentation/bloc/auth_state.dart';
import 'package:codan/features/auth/domain/entities/user.dart';
import 'package:codan/core/constants/app_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Profile Header Card
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),
                  // Quick Actions Grid
                  _buildQuickActions(),
                  const SizedBox(height: 32),
                  // Sections
                  _buildSection(
                    title: 'Transaksi',
                    items: [
                      _buildListTile(Icons.shopping_bag_outlined, 'Riwayat Transaksi', isLast: false),
                      _buildListTile(Icons.favorite_border, 'Wishlist', isLast: true, onTap: () => context.push('/wishlist')),
                    ],
                  ),
                  if (user.role == 'seller') ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Jual & Sewa',
                      items: [
                        _buildListTile(Icons.storefront_outlined, 'Produk Saya', isLast: false, onTap: () => context.push('/my-products')),
                        _buildListTile(Icons.swap_horiz, 'Sewaan Saya', isLast: false),
                        _buildListTile(Icons.star_outline, 'Ulasan & Rating', isLast: true),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Lainnya',
                    items: [
                      _buildListTile(
                        user.role == 'seller' ? Icons.person_outline : Icons.storefront_outlined, 
                        user.role == 'seller' ? 'Beralih ke Pembeli' : 'Beralih ke Penjual', 
                        isLast: false, 
                        onTap: () {
                          context.read<AuthBloc>().add(
                            AuthUpdateProfileRequested({'role': user.role == 'seller' ? 'buyer' : 'seller'}),
                          );
                        }
                      ),
                      _buildListTile(Icons.settings_outlined, 'Pengaturan', isLast: false, onTap: () => context.push('/settings')),
                      _buildListTile(
                        Icons.logout_rounded, 
                        'Keluar', 
                        isLast: true,
                        textColor: AppColors.error,
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 160), // Extra space for bottom nav
                ],
              ),
            ),
          );
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // Unauthenticated or Initial
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off_rounded, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Anda belum login'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Login sekarang'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100, width: 2),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: user.profilePhoto != null 
                    ? NetworkImage(user.profilePhoto!) 
                    : null,
                  child: user.profilePhoto == null 
                    ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ) 
                    : null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            user.phone,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('0', 'Produk'),
              _buildStatItem('0.0', 'Rating'),
              _buildStatItem('0', 'Transaksi'),
              _buildStatItem('100%', 'Respon'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuickActionItem(Icons.history_rounded, 'Riwayat'),
          _buildQuickActionItem(Icons.favorite_rounded, 'Wishlist'),
          _buildQuickActionItem(Icons.local_offer_rounded, 'Promo'),
          _buildQuickActionItem(Icons.help_rounded, 'Bantuan'),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF5C6BC0), size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {required bool isLast, Color? textColor, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: textColor ?? const Color(0xFF5C6BC0), size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          onTap: onTap ?? () {},
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 70,
            endIndent: 20,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
}
