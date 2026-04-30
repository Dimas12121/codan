import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../bloc/search_bloc.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? ['Laptop', 'Sepatu Nike', 'Hp Second'];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<SearchBloc>().add(SearchQueryChanged(query));
      } else {
        context.read<SearchBloc>().add(ClearSearch());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.searchBarBackground.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _onSearchChanged,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _recentSearches.remove(value);
                              _recentSearches.insert(0, value);
                              if (_recentSearches.length > 5) {
                                _recentSearches.removeLast();
                              }
                            });
                            _saveSearchHistory();
                            context.read<SearchBloc>().add(SearchQueryChanged(value));
                          } else {
                            context.read<SearchBloc>().add(ClearSearch());
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Cari HP, Laptop, dan lainnya...',
                          hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (_searchController.text.isEmpty && state is! SearchLoading) {
                    return _buildInitialSearchUI();
                  }

                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SearchLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('Tidak ada produk ditemukan.'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: state.products[index]);
                      },
                    );
                  }

                  if (state is SearchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return _buildInitialSearchUI();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialSearchUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Recent Searches Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pencarian Terakhir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (_recentSearches.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                    _saveSearchHistory();
                  },
                  child: const Text(
                    'Hapus Semua',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._recentSearches.map((search) => _buildRecentSearchItem(Icons.history, search)).toList(),
        if (_recentSearches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Belum ada pencarian terbaru',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

        const SizedBox(height: 32),

        // Kategori Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              _buildCategoryChip(
                'New',
                AppColors.primaryLight,
                AppColors.textPrimary,
                onTap: () => context.push('/marketplace?category=New'),
              ),
              _buildCategoryChip(
                'Second',
                AppColors.primaryLight,
                AppColors.textPrimary,
                onTap: () => context.push('/marketplace?category=Second'),
              ),
              _buildCategoryChip(
                'Disewakan',
                Colors.yellow.shade400,
                AppColors.textPrimary,
                onTap: () => context.push('/marketplace?category=Disewakan'),
              ),
              _buildCategoryChip(
                'Fashion',
                Colors.yellow.shade400,
                AppColors.textPrimary,
                onTap: () => context.push('/marketplace?category=Fashion'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchItem(IconData icon, String text) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
        setState(() {
          _recentSearches.remove(text);
          _recentSearches.insert(0, text);
        });
        _saveSearchHistory();
        context.read<SearchBloc>().add(SearchQueryChanged(text));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 18),
              onPressed: () {
                setState(() {
                  _recentSearches.remove(text);
                });
                _saveSearchHistory();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, Color bgColor, Color textColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
