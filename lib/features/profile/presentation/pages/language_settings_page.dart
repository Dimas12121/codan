import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codan/core/constants/app_constants.dart';
import 'package:codan/core/utils/app_snackbar.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _selectedLanguage = 'id'; // Default to Indonesian

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language_code') ?? 'id';
    });
  }

  Future<void> _saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
    setState(() {
      _selectedLanguage = code;
    });
    
    if (mounted) {
      AppSnackBar.showSuccess(context, code == 'id' ? 'Bahasa diubah ke Indonesia' : 'Language changed to English');
    }
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
          'Pilih Bahasa',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih bahasa yang ingin Anda gunakan dalam aplikasi.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),

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
                children: [
                  _buildLanguageItem(
                    'Bahasa Indonesia',
                    'Indonesian',
                    'assets/images/flags/id.png', // Placeholder for flag
                    'id',
                  ),
                  Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey.shade100),
                  _buildLanguageItem(
                    'English',
                    'English',
                    'assets/images/flags/us.png', // Placeholder for flag
                    'en',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String title, String subtitle, String flagPath, String code, {bool isLast = false}) {
    bool isSelected = _selectedLanguage == code;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            code == 'id' ? '🇮🇩' : '🇺🇸', // Use emojis as simple flags for now
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: isSelected 
        ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
        : null,
      onTap: () => _saveLanguage(code),
    );
  }
}
