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

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Semua';
    context.read<ProductBloc>().add(const LoadProducts());
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    if (_selectedCategory == 'Semua') return allProducts;
    return allProducts.where((p) {
      final matchesCategory = p.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesCondition = p.condition.toLowerCase().contains(_selectedCategory.toLowerCase());
      return matchesCategory || matchesCondition;
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
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade100),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
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
