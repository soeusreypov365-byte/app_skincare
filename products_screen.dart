import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/data/models/product_model.dart';
import 'package:skincare_app/providers/product_provider.dart';
import 'package:skincare_app/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    } else {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.searchProducts(query).then((results) {
        setState(() {
          _searchResults = results;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final displayProducts = _searchController.text.isNotEmpty
                    ? _searchResults
                    : productProvider.filteredProducts;

                if (displayProducts.isEmpty) {
                  return const Center(
                    child: Text('No products found'),
                  );
                }

                return Column(
                  children: [
                    // Categories
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: productProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = productProvider.categories[index];
                          final isSelected = category == productProvider.selectedCategory;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                productProvider.setCategory(category);
                              },
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: const Color(0xFF9C27B0),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Products Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: displayProducts.length,
                        itemBuilder: (context, index) {
                          final product = displayProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-detail',
                                arguments: product.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}