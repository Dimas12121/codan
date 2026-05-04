import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codan/core/constants/app_constants.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _isPromoEnabled = true;
  bool _isTransactionEnabled = true;
  bool _isChatEnabled = true;
  bool _isEmailEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPromoEnabled = prefs.getBool('notif_promo') ?? true;
      _isTransactionEnabled = prefs.getBool('notif_transaction') ?? true;
      _isChatEnabled = prefs.getBool('notif_chat') ?? true;
      _isEmailEnabled = prefs.getBool('notif_email') ?? false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih jenis pemberitahuan yang ingin Anda terima untuk tetap terupdate.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),

            _buildNotifSection(
              title: 'Aktivitas Aplikasi',
              items: [
                _buildNotifItem(
                  Icons.local_offer_outlined,
                  'Promo & Penawaran',
                  'Dapatkan info diskon dan promo menarik.',
                  _isPromoEnabled,
                  (val) {
                    setState(() => _isPromoEnabled = val);
                    _saveSetting('notif_promo', val);
                  },
                ),
                _buildNotifItem(
                  Icons.shopping_bag_outlined,
                  'Status Transaksi',
                  'Update tentang pembelian dan penyewaan.',
                  _isTransactionEnabled,
                  (val) {
                    setState(() => _isTransactionEnabled = val);
                    _saveSetting('notif_transaction', val);
                  },
                ),
                _buildNotifItem(
                  Icons.chat_bubble_outline_rounded,
                  'Pesan Chat',
                  'Notifikasi saat ada pesan masuk baru.',
                  _isChatEnabled,
                  (val) {
                    setState(() => _isChatEnabled = val);
                    _saveSetting('notif_chat', val);
                  },
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildNotifSection(
              title: 'Lainnya',
              items: [
                _buildNotifItem(
                  Icons.mail_outline_rounded,
                  'Email Marketing',
                  'Terima berita mingguan di email Anda.',
                  _isEmailEnabled,
                  (val) {
                    setState(() => _isEmailEnabled = val);
                    _saveSetting('notif_email', val);
                  },
                  isLast: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifSection({required String title, required List<Widget> items}) {
    return Column(
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
    );
  }

  Widget _buildNotifItem(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF5C6BC0), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
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
}
