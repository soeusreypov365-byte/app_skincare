import 'package:flutter/material.dart';
import 'package:skincare_app/data/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  ProductProvider();

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _products = [
        // SKIN1004 Products
        ProductModel(
          id: '1',
          name: 'Madagascar Centella Ampoule',
          brand: 'SKIN1004',
          category: 'Serum',
          description: 'Soothing ampoule with 100% Madagascar Centella Asiatica for sensitive skin.',
          price: 18.00,
          imageUrl: 'https://images.pexels.com/photos/3685530/pexels-photo-3685530.jpeg?w=400',
          ingredients: ['Centella Asiatica', 'Madecassoside', 'Asiaticoside'],
          rating: 4.8,
          reviews: 3250,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '2',
          name: 'Centella Light Suncream',
          brand: 'SKIN1004',
          category: 'Sunscreen',
          description: 'Lightweight, non-greasy sunscreen with SPF50+ PA++++ for daily protection.',
          price: 21.90,
          imageUrl: 'https://images.pexels.com/photos/3018845/pexels-photo-3018845.jpeg?w=400',
          ingredients: ['Centella Asiatica', 'Niacinamide', 'Zinc Oxide'],
          rating: 4.6,
          reviews: 4500,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '3',
          name: 'Centella Toning Toner',
          brand: 'SKIN1004',
          category: 'Toner',
          description: 'Gentle toner that soothes and hydrates sensitive skin with Centella extract.',
          price: 16.00,
          imageUrl: 'https://images.pexels.com/photos/4465124/pexels-photo-4465124.jpeg?w=400',
          ingredients: ['Centella Asiatica', 'Hyaluronic Acid', 'Panthenol'],
          rating: 4.7,
          reviews: 2800,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // Mary & May Products
        ProductModel(
          id: '4',
          name: 'Idebenone Blackberry Serum',
          brand: 'Mary & May',
          category: 'Serum',
          description: 'Anti-aging serum with Idebenone and Blackberry for youthful, radiant skin.',
          price: 29.90,
          imageUrl: 'https://images.pexels.com/photos/4041392/pexels-photo-4041392.jpeg?w=400',
          ingredients: ['Idebenone', 'Blackberry Extract', 'Niacinamide'],
          rating: 4.9,
          reviews: 1890,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '5',
          name: 'Vegan CICA Toner',
          brand: 'Mary & May',
          category: 'Toner',
          description: 'Vegan-friendly CICA toner that soothes and hydrates irritated skin.',
          price: 20.00,
          imageUrl: 'https://images.pexels.com/photos/5069432/pexels-photo-5069432.jpeg?w=400',
          ingredients: ['Centella Asiatica', 'Hyaluronic Acid', 'Panthenol'],
          rating: 4.7,
          reviews: 2100,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '6',
          name: 'Houttuynia Tea Tree Serum',
          brand: 'Mary & May',
          category: 'Serum',
          description: 'Calming serum for acne-prone skin with Tea Tree and Houttuynia Cordata.',
          price: 24.99,
          imageUrl: 'https://images.pexels.com/photos/6621462/pexels-photo-6621462.jpeg?w=400',
          ingredients: ['Tea Tree', 'Houttuynia Cordata', 'Centella Asiatica'],
          rating: 4.8,
          reviews: 1560,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '7',
          name: 'Lemon Niacinamide Glow Mask',
          brand: 'Mary & May',
          category: 'Mask',
          description: 'Brightening wash-off mask with Lemon and Niacinamide for glowing skin.',
          price: 19.99,
          imageUrl: 'https://images.pexels.com/photos/3762879/pexels-photo-3762879.jpeg?w=400',
          ingredients: ['Niacinamide', 'Lemon Extract', 'Vitamin C'],
          rating: 4.6,
          reviews: 1450,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // Romand Products
        ProductModel(
          id: '8',
          name: 'Zero Velvet Tint',
          brand: 'Romand',
          category: 'Lip',
          description: 'Lightweight velvet lip tint with long-lasting, buildable color.',
          price: 14.99,
          imageUrl: 'https://images.pexels.com/photos/2533266/pexels-photo-2533266.jpeg?w=400',
          ingredients: ['Sunflower Oil', 'Rosehip Oil', 'Vitamin E'],
          rating: 4.9,
          reviews: 8200,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '9',
          name: 'Glasting Water Gloss',
          brand: 'Romand',
          category: 'Lip',
          description: 'High-shine, non-sticky lip gloss with moisturizing formula.',
          price: 12.99,
          imageUrl: 'https://images.pexels.com/photos/3373739/pexels-photo-3373739.jpeg?w=400',
          ingredients: ['Jojoba Oil', 'Vitamin E', 'Shea Butter'],
          rating: 4.8,
          reviews: 5600,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '10',
          name: 'Better Than Cheek Blush',
          brand: 'Romand',
          category: 'Blush',
          description: 'Silky, buildable blush with natural finish for a healthy glow.',
          price: 13.99,
          imageUrl: 'https://images.pexels.com/photos/2587370/pexels-photo-2587370.jpeg?w=400',
          ingredients: ['Silica', 'Dimethicone', 'Tocopherol'],
          rating: 4.7,
          reviews: 3400,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // 3CE Products
        ProductModel(
          id: '11',
          name: 'Velvet Lip Tint',
          brand: '3CE',
          category: 'Lip',
          description: 'Iconic velvet matte lip tint with rich pigmentation.',
          price: 21.00,
          imageUrl: 'https://images.pexels.com/photos/2113855/pexels-photo-2113855.jpeg?w=400',
          ingredients: ['Shea Butter', 'Jojoba Oil', 'Vitamin E'],
          rating: 4.8,
          reviews: 12500,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '12',
          name: 'Face Blush',
          brand: '3CE',
          category: 'Blush',
          description: 'Silky blush with natural finish for a healthy, radiant glow.',
          price: 17.05,
          imageUrl: 'https://images.pexels.com/photos/2688991/pexels-photo-2688991.jpeg?w=400',
          ingredients: ['Silica', 'Dimethicone', 'Tocopherol'],
          rating: 4.7,
          reviews: 4200,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '13',
          name: 'Multi Eye Palette',
          brand: '3CE',
          category: 'Eye',
          description: '9-shade eyeshadow palette with mix of matte and shimmer finishes.',
          price: 42.99,
          imageUrl: 'https://images.pexels.com/photos/1499511/pexels-photo-1499511.jpeg?w=400',
          ingredients: ['Mica', 'Silica', 'Tocopherol'],
          rating: 4.9,
          reviews: 7800,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // CeraVe Products
        ProductModel(
          id: '14',
          name: 'Hydrating Facial Cleanser',
          brand: 'CeraVe',
          category: 'Cleanser',
          description: 'Gentle hydrating cleanser with ceramides and hyaluronic acid.',
          price: 14.99,
          imageUrl: 'https://images.pexels.com/photos/4465829/pexels-photo-4465829.jpeg?w=400',
          ingredients: ['Ceramides', 'Hyaluronic Acid', 'Glycerin'],
          rating: 4.8,
          reviews: 15000,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '15',
          name: 'PM Facial Moisturizing Lotion',
          brand: 'CeraVe',
          category: 'Moisturizer',
          description: 'Nourishing night moisturizer with niacinamide and ceramides.',
          price: 16.99,
          imageUrl: 'https://images.pexels.com/photos/6621329/pexels-photo-6621329.jpeg?w=400',
          ingredients: ['Niacinamide', 'Ceramides', 'Hyaluronic Acid'],
          rating: 4.7,
          reviews: 12000,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // The Ordinary Products
        ProductModel(
          id: '16',
          name: 'Niacinamide 10% + Zinc 1%',
          brand: 'The Ordinary',
          category: 'Serum',
          description: 'High-strength vitamin and mineral blemish formula.',
          price: 9.99,
          imageUrl: 'https://images.pexels.com/photos/4041391/pexels-photo-4041391.jpeg?w=400',
          ingredients: ['Niacinamide', 'Zinc PCA', 'Glycerin'],
          rating: 4.6,
          reviews: 25000,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '17',
          name: 'Hyaluronic Acid 2% + B5',
          brand: 'The Ordinary',
          category: 'Serum',
          description: 'Hydrating serum with multi-depth hyaluronic acid and vitamin B5.',
          price: 11.99,
          imageUrl: 'https://images.pexels.com/photos/5069612/pexels-photo-5069612.jpeg?w=400',
          ingredients: ['Hyaluronic Acid', 'Vitamin B5', 'Glycerin'],
          rating: 4.7,
          reviews: 18000,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '18',
          name: 'Retinol 0.5% in Squalane',
          brand: 'The Ordinary',
          category: 'Treatment',
          description: 'Anti-aging retinol serum in hydrating squalane base.',
          price: 8.99,
          imageUrl: 'https://images.pexels.com/photos/3762875/pexels-photo-3762875.jpeg?w=400',
          ingredients: ['Retinol', 'Squalane', 'Jojoba Oil'],
          rating: 4.5,
          reviews: 14000,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // La Roche-Posay Products
        ProductModel(
          id: '19',
          name: 'Effaclar Duo+ Cream',
          brand: 'La Roche-Posay',
          category: 'Treatment',
          description: 'Dual action acne treatment with niacinamide and salicylic acid.',
          price: 29.99,
          imageUrl: 'https://images.pexels.com/photos/4046316/pexels-photo-4046316.jpeg?w=400',
          ingredients: ['Niacinamide', 'Salicylic Acid', 'Zinc'],
          rating: 4.6,
          reviews: 8500,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '20',
          name: 'Anthelios SPF 50+ Sunscreen',
          brand: 'La Roche-Posay',
          category: 'Sunscreen',
          description: 'Ultra-light fluid sunscreen with broad spectrum SPF 50+ protection.',
          price: 33.99,
          imageUrl: 'https://images.pexels.com/photos/3018847/pexels-photo-3018847.jpeg?w=400',
          ingredients: ['Mexoryl SX', 'Vitamin E', 'Thermal Water'],
          rating: 4.8,
          reviews: 9200,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // Body Lotion Products
        ProductModel(
          id: '21',
          name: 'Moisturizing Body Lotion',
          brand: 'CeraVe',
          category: 'Body Lotion',
          description: 'Daily moisturizing body lotion with ceramides and hyaluronic acid for dry skin.',
          price: 15.99,
          imageUrl: 'https://images.pexels.com/photos/3321416/pexels-photo-3321416.jpeg?w=400',
          ingredients: ['Ceramides', 'Hyaluronic Acid', 'Glycerin'],
          rating: 4.8,
          reviews: 18500,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '22',
          name: 'Shea Butter Body Lotion',
          brand: 'Nivea',
          category: 'Body Lotion',
          description: 'Rich body lotion with shea butter for 48-hour deep moisture.',
          price: 8.99,
          imageUrl: 'https://images.pexels.com/photos/3735149/pexels-photo-3735149.jpeg?w=400',
          ingredients: ['Shea Butter', 'Vitamin E', 'Glycerin'],
          rating: 4.6,
          reviews: 12000,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '23',
          name: 'Cica Body Lotion',
          brand: 'SKIN1004',
          category: 'Body Lotion',
          description: 'Soothing body lotion with Centella Asiatica for sensitive body skin.',
          price: 19.99,
          imageUrl: 'https://images.pexels.com/photos/4465128/pexels-photo-4465128.jpeg?w=400',
          ingredients: ['Centella Asiatica', 'Shea Butter', 'Aloe Vera'],
          rating: 4.7,
          reviews: 3200,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '24',
          name: 'Aloe Vera Body Lotion',
          brand: 'Nature Republic',
          category: 'Body Lotion',
          description: 'Lightweight body lotion with 92% Aloe Vera for cooling hydration.',
          price: 12.99,
          imageUrl: 'https://images.pexels.com/photos/4612158/pexels-photo-4612158.jpeg?w=400',
          ingredients: ['Aloe Vera', 'Green Tea', 'Vitamin E'],
          rating: 4.5,
          reviews: 8900,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '25',
          name: 'Intensive Repair Body Lotion',
          brand: 'Eucerin',
          category: 'Body Lotion',
          description: 'Advanced repair body lotion with ceramides for very dry skin.',
          price: 18.99,
          imageUrl: 'https://images.pexels.com/photos/5217958/pexels-photo-5217958.jpeg?w=400',
          ingredients: ['Ceramides', 'Urea', 'Natural Moisturizing Factors'],
          rating: 4.7,
          reviews: 7500,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '26',
          name: 'Lipikar Body Lotion AP+M',
          brand: 'La Roche-Posay',
          category: 'Body Lotion',
          description: 'Triple-action body lotion that restores skin barrier and relieves dryness.',
          price: 24.99,
          imageUrl: 'https://images.pexels.com/photos/4041394/pexels-photo-4041394.jpeg?w=400',
          ingredients: ['Niacinamide', 'Shea Butter', 'Thermal Water'],
          rating: 4.8,
          reviews: 6800,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '27',
          name: 'Cherry Blossom Body Lotion',
          brand: 'Innisfree',
          category: 'Body Lotion',
          description: 'Floral-scented body lotion with Jeju cherry blossom extract.',
          price: 16.99,
          imageUrl: 'https://images.pexels.com/photos/3685523/pexels-photo-3685523.jpeg?w=400',
          ingredients: ['Cherry Blossom Extract', 'Betaine', 'Glycerin'],
          rating: 4.6,
          reviews: 5400,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: '28',
          name: 'Collagen Body Lotion',
          brand: 'Aveeno',
          category: 'Body Lotion',
          description: 'Firming body lotion with collagen and oat extract for smoother skin.',
          price: 14.99,
          imageUrl: 'https://images.pexels.com/photos/3997373/pexels-photo-3997373.jpeg?w=400',
          ingredients: ['Collagen', 'Oat Extract', 'Vitamin B3'],
          rating: 4.5,
          reviews: 9200,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      _filterProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _filterProducts() {
    if (_selectedCategory == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _filterProducts();
    notifyListeners();
  }

  Future<void> selectProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _selectedProduct = _products.firstWhere((p) => p.id == productId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.isEmpty) {
      _filterProducts();
      return _filteredProducts;
    }

    return _products.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      p.brand.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data (admin function)
  Future<void> clearAllData() async {
    _products.clear();
    _filteredProducts.clear();
    _selectedProduct = null;
    notifyListeners();
  }
}
