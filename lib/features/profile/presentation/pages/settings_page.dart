import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:codan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:codan/features/auth/presentation/bloc/auth_event.dart';
import 'package:codan/features/auth/presentation/bloc/auth_state.dart';
import 'package:codan/core/constants/app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Account Section
                _buildSection(
                  title: 'Akun',
                  items: [
                    _buildSettingsItem(
                      Icons.person_outline_rounded,
                      'Informasi Pribadi',
                      'Nama, Email, dan No. HP',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _buildSettingsItem(
                      Icons.lock_outline_rounded,
                      'Kata Sandi',
                      'Ubah kata sandi Anda',
                      onTap: () => context.push('/change-password'),
                    ),
                    _buildSettingsItem(
                      Icons.verified_user_outlined,
                      'Keamanan Akun',
                      'Autentikasi dua faktor',
                      isLast: true,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Notifications Section
                _buildSection(
                  title: 'Notifikasi',
                  items: [
                    _buildSettingsItem(
                      Icons.notifications_none_rounded,
                      'Push Notification',
                      'Atur pemberitahuan aplikasi',
                      onTap: () => context.push('/notification-settings'),
                    ),
                    _buildSettingsItem(
                      Icons.mail_outline_rounded,
                      'Email Marketing',
                      'Promosi dan penawaran',
                      isLast: true,
                      onTap: () => context.push('/notification-settings'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // App Info Section
                _buildSection(
                  title: 'Aplikasi',
                  items: [
                    _buildSettingsItem(
                      Icons.language_rounded,
                      'Bahasa',
                      'Bahasa Indonesia',
                      onTap: () => context.push('/language-settings'),
                    ),
                    _buildSettingsItem(
                      Icons.help_outline_rounded,
                      'Pusat Bantuan',
                      'FAQ dan dukungan',
                      onTap: () => context.push('/help-center'),
                    ),
                    _buildSettingsItem(
                      Icons.info_outline_rounded,
                      'Tentang CODean',
                      'Versi 1.0.0',
                      isLast: true,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: const Text(
                      'Keluar dari Akun',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
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

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, {bool isLast = false, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF5C6BC0), size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 70,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
            child: const Text('Keluar', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
