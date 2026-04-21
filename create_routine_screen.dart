import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/data/models/routine_model.dart';
import 'package:skincare_app/providers/routine_provider.dart';
import 'package:skincare_app/providers/product_provider.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedTime = 'Morning';
  final List<RoutineProduct> _selectedProducts = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Routine Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Routine Name',
                    hintText: 'e.g., Morning Glow Routine',
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a routine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Time Selection
                const Text(
                  'When do you want to use this routine?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeCard(
                        'Morning',
                        Icons.wb_sunny,
                        [const Color(0xFFFFB74D), const Color(0xFFFF8A65)],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeCard(
                        'Evening',
                        Icons.nightlight_round,
                        [const Color(0xFF9C27B0), const Color(0xFF5C6BC0)],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Products Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_selectedProducts.length} selected',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Selected Products
                if (_selectedProducts.isNotEmpty) ...[
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedProducts.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _selectedProducts.removeAt(oldIndex);
                        _selectedProducts.insert(newIndex, item);
                        _updateOrder();
                      });
                    },
                    itemBuilder: (context, index) {
                      final product = _selectedProducts[index];
                      return Card(
                        key: ValueKey(product.productId),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF9C27B0),
                            child: Text(
                              '${product.order}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(product.productName),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedProducts.removeAt(index);
                                _updateOrder();
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Add Product Button
                OutlinedButton.icon(
                  onPressed: () => _showProductSelector(context, productProvider),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _selectedTime == 'Morning'
                            ? [const Color(0xFFFFB74D), const Color(0xFFFF8A65)]
                            : [const Color(0xFF9C27B0), const Color(0xFF5C6BC0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: _selectedProducts.isEmpty ? null : _saveRoutine,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Routine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeCard(String time, IconData icon, List<Color> colors) {
    final isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTime = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: colors) : null,
          color: isSelected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateOrder() {
    for (int i = 0; i < _selectedProducts.length; i++) {
      _selectedProducts[i] = RoutineProduct(
        productId: _selectedProducts[i].productId,
        productName: _selectedProducts[i].productName,
        order: i + 1,
        notes: _selectedProducts[i].notes,
      );
    }
  }

  void _showProductSelector(BuildContext context, ProductProvider productProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      final isAdded = _selectedProducts.any((p) => p.productId == product.id);
                      
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image),
                              );
                            },
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.brand),
                        trailing: isAdded
                            ? const Icon(Icons.check_circle, color: Color(0xFF9C27B0))
                            : const Icon(Icons.add_circle_outline),
                        onTap: isAdded
                            ? null
                            : () {
                                setState(() {
                                  _selectedProducts.add(RoutineProduct(
                                    productId: product.id,
                                    productName: product.name,
                                    order: _selectedProducts.length + 1,
                                  ));
                                });
                                Navigator.pop(context);
                              },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveRoutine() async {
    if (_formKey.currentState!.validate() && _selectedProducts.isNotEmpty) {
      final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
      
      final routine = RoutineModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user_123',
        name: _nameController.text.trim(),
        time: _selectedTime,
        products: _selectedProducts,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await routineProvider.createRoutine(routine);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Routine created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
