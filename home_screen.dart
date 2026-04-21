import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/providers/product_provider.dart';
import 'package:skincare_app/providers/routine_provider.dart';
import 'package:skincare_app/widgets/product_card.dart';
import 'package:skincare_app/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeTab(),
    const ProductsTab(),
    const RoutinesTab(),
    const ProfileTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Routines',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFFFFB74D)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${authProvider.currentUser?.fullName ?? 'User'}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ready for your skincare routine today?',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Skin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.face,
                      color: Color(0xFF9C27B0),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.currentUser?.skinType ?? 'Not Analyzed',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (authProvider.currentUser?.skinConcerns?.isNotEmpty ?? false)
                              ? authProvider.currentUser!.skinConcerns!.join(', ')
                              : 'No skin concerns added',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/skin-analysis');
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommended for You',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/products');
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : productProvider.products.isEmpty
                      ? const Center(child: Text('No products available'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.products.length > 6
                              ? 6
                              : productProvider.products.length,
                          itemBuilder: (context, index) {
                            final product = productProvider.products[index];
                            return Container(
                              width: 180,
                              margin: const EdgeInsets.only(right: 12),
                              child: ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                    arguments: product.id,
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsTab extends StatefulWidget {
  const ProductsTab({super.key});
  @override
  State<ProductsTab> createState() => _ProductsTabState();
}
class _ProductsTabState extends State<ProductsTab> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    productProvider.searchProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                ),
              ),
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
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        selectedColor: const Color(0xFF9C27B0),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: productProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productProvider.filteredProducts.isEmpty
                        ? const Center(child: Text('No products found'))
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.62,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: productProvider.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = productProvider.filteredProducts[index];
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
    );
  }
}
class RoutinesTab extends StatelessWidget {
  const RoutinesTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create-routine');
            },
          ),
        ],
      ),
      body: Consumer<RoutineProvider>(
        builder: (context, routineProvider, child) {
          if (routineProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (routineProvider.routines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No routines yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first skincare routine',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-routine');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Routine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: routineProvider.routines.length,
            itemBuilder: (context, index) {
              final routine = routineProvider.routines[index];
              final isMorning = routine.time == 'Morning';
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/routine-detail',
                      arguments: routine.id,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isMorning
                                  ? [const Color(0xFFFFB74D), const Color(0xFFFF8A65)]
                                  : [const Color(0xFF9C27B0), const Color(0xFF5C6BC0)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isMorning ? Icons.wb_sunny : Icons.nightlight_round,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routine.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${routine.time} • ${routine.products.length} products',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}