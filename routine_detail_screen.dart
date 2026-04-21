import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/routine_provider.dart';
import 'package:skincare_app/providers/product_provider.dart';

class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routineId = ModalRoute.of(context)?.settings.arguments as String?;
    
    return Consumer2<RoutineProvider, ProductProvider>(
      builder: (context, routineProvider, productProvider, child) {
        final routine = routineProvider.routines.firstWhere(
          (r) => r.id == routineId,
          orElse: () => routineProvider.routines.first,
        );

        final isMorning = routine.time == 'Morning';

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    routine.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isMorning
                            ? [const Color(0xFFFFB74D), const Color(0xFFFF8A65)]
                            : [const Color(0xFF9C27B0), const Color(0xFF5C6BC0)],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isMorning ? Icons.wb_sunny : Icons.nightlight_round,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteDialog(context, routineProvider, routine.id),
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isMorning
                                  ? const Color(0xFFFFB74D).withValues(alpha: 0.2)
                                  : const Color(0xFF9C27B0).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isMorning ? Icons.wb_sunny : Icons.nightlight_round,
                                  size: 18,
                                  color: isMorning ? const Color(0xFFFF8A65) : const Color(0xFF9C27B0),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  routine.time,
                                  style: TextStyle(
                                    color: isMorning ? const Color(0xFFFF8A65) : const Color(0xFF9C27B0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${routine.products.length} steps',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Products Section
                      const Text(
                        'Your Routine Steps',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Follow these steps in order for best results',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Products List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final routineProduct = routine.products[index];
                    final product = productProvider.products.firstWhere(
                      (p) => p.id == routineProduct.productId,
                      orElse: () => productProvider.products.first,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Step Number
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isMorning
                                        ? [const Color(0xFFFFB74D), const Color(0xFFFF8A65)]
                                        : [const Color(0xFF9C27B0), const Color(0xFF5C6BC0)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${routineProduct.order}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  product.imageUrl ?? 'https://via.placeholder.com/60',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      routineProduct.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.brand,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (routineProduct.notes != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        routineProduct.notes!,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Checkmark
                              IconButton(
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: routine.products.length,
                ),
              ),

              // Bottom spacing and tips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Tips Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isMorning
                              ? const Color(0xFFFFB74D).withValues(alpha: 0.1)
                              : const Color(0xFF9C27B0).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isMorning
                                ? const Color(0xFFFFB74D).withValues(alpha: 0.3)
                                : const Color(0xFF9C27B0).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: isMorning ? const Color(0xFFFF8A65) : const Color(0xFF9C27B0),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isMorning ? 'Morning Tip' : 'Evening Tip',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isMorning ? const Color(0xFFFF8A65) : const Color(0xFF9C27B0),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isMorning
                                        ? 'Always apply sunscreen as the last step before makeup!'
                                        : 'Wait 20 minutes after retinol before applying other products.',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Start Routine Button
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isMorning
                                  ? [const Color(0xFFFFB74D), const Color(0xFFFF8A65)]
                                  : [const Color(0xFF9C27B0), const Color(0xFF5C6BC0)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Starting ${routine.name}...'),
                                  backgroundColor: isMorning ? const Color(0xFFFF8A65) : const Color(0xFF9C27B0),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Start Routine',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, RoutineProvider provider, String routineId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine'),
        content: const Text('Are you sure you want to delete this routine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deleteRoutine(routineId);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
