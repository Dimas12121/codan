import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../core/constants/app_constants.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  String _selectedCategory = '';
  String _selectedCondition = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: null, // Title is in the body
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Jual Barang',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Foto yang bagus bikin cepat laku!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Foto Produk
              const Text(
                'Foto Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPhotoPicker(),
              const SizedBox(height: 24),

              // Judul Produk
              _buildLabel('Judul Produk'),
              _buildTextField(hint: 'Contoh: MacBook Air M1 2020 Fullset'),
              const SizedBox(height: 20),

              // Harga
              _buildLabel('Harga (Rp)'),
              _buildTextField(hint: 'Contoh: 8500000', keyboardType: TextInputType.number),
              const SizedBox(height: 20),

              // Deskripsi Produk
              _buildLabel('Deskripsi Produk'),
              _buildTextField(
                hint: 'Ceritakan kondisi barang, kelengkapan, dll...',
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Kategori
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Buku', Icons.book_rounded),
                    _buildCategoryChip('Elektronik', Icons.laptop_rounded),
                    _buildCategoryChip('Fashion', Icons.checkroom_rounded),
                    _buildCategoryChip('Kendaraan', Icons.directions_car_rounded),
                    _buildCategoryChip('Gaming', Icons.sports_esports_rounded),
                    _buildCategoryChip('Lainnya', Icons.more_horiz_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kondisi
              const Text(
                'Kondisi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildConditionChip('Baru'),
                  _buildConditionChip('Seperti Baru'),
                  _buildConditionChip('Bekas - Baik'),
                  _buildConditionChip('Bekas - Layak Pakai'),
                ],
              ),
              const SizedBox(height: 40),

              // Publish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logic to publish
                  },
                  icon: const Icon(Icons.publish_rounded, size: 20),
                  label: const Text(
                    'Publikasikan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC5BFFF), // Light purple from design
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: DashedRectPainter(color: AppColors.primary),
        child: InkWell(
          onTap: () {
            // Pick image logic
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 30),
              const SizedBox(height: 4),
              Text(
                'Tambah Foto',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({required String hint, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: TextField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionChip(String label) {
    final isSelected = _selectedCondition == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade100),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rRect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(15));
    final Path path = Path()..addRRect(rRect);

    final Path dashPath = Path();
    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(DashedRectPainter oldDelegate) => false;
}

