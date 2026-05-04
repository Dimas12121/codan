import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_event.dart';
import '../../../product/presentation/bloc/product_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_shimmer.dart';

class MarketplacePage extends StatefulWidget {
  final String? initialCategory;

  const MarketplacePage({super.key, this.initialCategory});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  late String _selectedCategory;
  final List<String> _categories = [
    'Semua',
    'Buku',
    'Elektronik',
    'Fashion',
    'Kendaraan',
    'Gaming',
    'Sewa Barang',
    'New',
    'Second',
    'Disewakan',
    'Lainnya',
  ];

  String _selectedType = 'Semua';
  String _selectedCondition = 'Semua';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Semua';
    // If initial category is a type or condition, handle it
    if (['rent', 'sell'].contains(_selectedCategory.toLowerCase())) {
      _selectedType = _selectedCategory;
      _selectedCategory = 'Semua';
    }
    context.read<ProductBloc>().add(const LoadProducts());
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedType = 'Semua';
                            _selectedCondition = 'Semua';
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Tipe Iklan', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Semua', 'Jual', 'Sewa'].map((t) {
                      final isSel = _selectedType == t;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(t),
                          selected: isSel,
                          onSelected: (s) => setModalState(() => _selectedType = t),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('Kondisi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Semua', 'Baru', 'Bekas'].map((c) {
                      final isSel = _selectedCondition == c;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: isSel,
                          onSelected: (s) => setModalState(() => _selectedCondition = c),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Terapkan Filter'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    return allProducts.where((p) {
      final matchesCategory = _selectedCategory == 'Semua' || 
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
          
      final matchesType = _selectedType == 'Semua' || 
          p.type.toLowerCase() == (_selectedType == 'Sewa' ? 'rent' : 'sell');
          
      final matchesCondition = _selectedCondition == 'Semua' || 
          p.condition.toLowerCase().contains(_selectedCondition.toLowerCase());
          
      return matchesCategory && matchesType && matchesCondition;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Marketplace',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            onPressed: () => _showFilterBottomSheet(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Category List
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              buildWhen: (previous, current) =>
                  current is ProductLoaded ||
                  current is ProductLoading ||
                  current is ProductError,
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const ProductListShimmer(isGrid: true);
                } else if (state is ProductLoaded) {
                  final filteredProducts = _getFilteredProducts(state.products);
                  
                  if (filteredProducts.isEmpty) {
                    return const Center(child: Text('Tidak ada produk.'));
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          '${filteredProducts.length} produk',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: filteredProducts[index]);
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ProductError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
