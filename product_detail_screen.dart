import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skincare_app/providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _hasLoadedProduct = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoadedProduct) return;

    final productId =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false)
            .selectProduct(productId);
      });
      _hasLoadedProduct = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final product = productProvider.selectedProduct;

          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (product == null) {
            return const Center(child: Text("Product not found"));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: product.imageUrl != null
                      ? CachedNetworkImage(
                    imageUrl: product.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  )
                      : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              /// CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Brand
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Category + Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          const Spacer(),

                          if (product.rating != null) ...[
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            if (product.reviews != null)
                              Text(
                                " (${product.reviews} reviews)",
                                style:
                                const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ],
                      ),

                      /// Price
                      if (product.price != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          "Price: \$${product.price!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      /// Description
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ??
                            "No description available",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                      /// Ingredients
                      if (product.ingredients != null &&
                          product.ingredients!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                          product.ingredients!.map((ingredient) {
                            return Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(ingredient),
                            );
                          }).toList(),
                        ),
                      ],

                      /// Usage
                      if (product.usage != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          "How to Use",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(product.usage!),
                      ],

                      const SizedBox(height: 32),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/payment',
                                arguments: product,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Add to Routine",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}