import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  int? _selectedCategoryId;
  String _selectedCondition = 'used';
  String _selectedType = 'sell';
  String _selectedRentalPeriod = 'daily';
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  
  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toStringAsFixed(0);
      _locationController.text = widget.product!.location;
      _descriptionController.text = widget.product!.description;
      _selectedCondition = widget.product!.condition.toLowerCase().contains('bekas') || widget.product!.condition.toLowerCase().contains('used') ? 'used' : 'new';
      _selectedType = widget.product!.type;
      _selectedRentalPeriod = widget.product!.rentalPeriod ?? 'daily';
      // Note: Category selection for edit requires mapping the name back to ID
    }
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await context.read<ProductBloc>().repository.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
          
          if (isEdit) {
            final cat = _categories.firstWhere(
              (c) => c['name'] == widget.product!.category,
              orElse: () => {},
            );
            if (cat.isNotEmpty) {
              _selectedCategoryId = cat['id'];
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat kategori: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih kategori')),
        );
        return;
      }

      if (!isEdit && _images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan tambahkan setidaknya satu gambar')),
        );
        return;
      }

      final Map<String, dynamic> data = {
        'title': _titleController.text,
        'category_id': _selectedCategoryId,
        'price': double.parse(_priceController.text),
        'location': _locationController.text,
        'description': _descriptionController.text,
        'condition': _selectedCondition,
        'type': _selectedType,
        'rental_period': _selectedType == 'rent' ? _selectedRentalPeriod : null,
      };

      // Add images if any
      if (_images.isNotEmpty) {
        // In a real app, you'd convert XFile to MultipartFile for Dio
        // We'll handle this in the DataSource
        data['images'] = _images.map((img) => img.path).toList();
      }

      if (isEdit) {
        context.read<ProductBloc>().add(UpdateProductEvent(widget.product!.id, data));
      } else {
        context.read<ProductBloc>().add(AddProduct(data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Produk' : 'Jual Produk'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProductOperationSuccess) {
            Navigator.pop(context); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop(); // Go back
          } else if (state is ProductOperationError) {
            Navigator.pop(context); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Picker
                const Text(
                  'Foto Produk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _images.length) {
                        return GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                          ),
                        );
                      }
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(File(_images[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 15,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Type Selection
                _buildLabel('Tipe Iklan'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeOption(
                        title: 'Jual',
                        isSelected: _selectedType == 'sell',
                        onTap: () => setState(() => _selectedType = 'sell'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTypeOption(
                        title: 'Sewa',
                        isSelected: _selectedType == 'rent',
                        onTap: () => setState(() => _selectedType = 'rent'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form Fields
                _buildLabel('Judul Produk'),
                TextFormField(
                  controller: _titleController,
                  decoration: _buildInputDecoration('Contoh: MacBook Pro 2021'),
                  validator: (v) => v!.isEmpty ? 'Judul tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Kategori'),
                _isLoadingCategories
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<int>(
                        initialValue: _selectedCategoryId,
                        decoration: _buildInputDecoration('Pilih Kategori'),
                        items: _categories.map((cat) {
                          return DropdownMenuItem<int>(
                            value: cat['id'],
                            child: Text(cat['name']),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCategoryId = val;
                          });
                        },
                        validator: (v) => v == null ? 'Pilih kategori' : null,
                      ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildLabel(_selectedType == 'rent' ? 'Harga Sewa (Rp)' : 'Harga (Rp)'),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration('0'),
                            validator: (v) => v!.isEmpty ? 'Harga kosong' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_selectedType == 'rent')
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Periode'),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedRentalPeriod,
                              decoration: _buildInputDecoration('Periode'),
                              items: const [
                                DropdownMenuItem(value: 'daily', child: Text('Harian')),
                                DropdownMenuItem(value: 'weekly', child: Text('Mingguan')),
                                DropdownMenuItem(value: 'monthly', child: Text('Bulanan')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedRentalPeriod = val!;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Kondisi'),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCondition,
                              decoration: _buildInputDecoration('Kondisi'),
                              items: const [
                                DropdownMenuItem(value: 'new', child: Text('Baru')),
                                DropdownMenuItem(value: 'used', child: Text('Bekas')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedCondition = val!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildLabel('Lokasi'),
                TextFormField(
                  controller: _locationController,
                  decoration: _buildInputDecoration('Contoh: Kampus A, Gedung 2'),
                  validator: (v) => v!.isEmpty ? 'Lokasi kosong' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Deskripsi'),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: _buildInputDecoration('Jelaskan detail produk Anda...'),
                  validator: (v) => v!.isEmpty ? 'Deskripsi kosong' : null,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isEdit ? 'Simpan Perubahan' : 'Pasang Iklan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
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
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildTypeOption({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
