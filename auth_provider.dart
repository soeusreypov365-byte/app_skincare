import 'package:flutter/material.dart';
import 'package:skincare_app/data/models/user_model.dart';
import 'package:skincare_app/data/services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  static const String adminEmail = 'admin@skincare.com';
  static const String adminPassword = 'admin123';

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadUserFromStorageAsync();
  }

  // Load user from local storage on app start (async to avoid build issues)
  void _loadUserFromStorageAsync() async {
    await Future.microtask(() {}); // Ensure this runs after build
    final savedUser = LocalStorageService.getUser();
    final isLoggedIn = LocalStorageService.isLoggedIn();
    
    if (savedUser != null && isLoggedIn) {
      _currentUser = savedUser;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final normalizedEmail = email.trim().toLowerCase();
      
      // Check for admin login
      if (normalizedEmail == adminEmail && password == adminPassword) {
        _currentUser = UserModel(
          id: 'admin_${DateTime.now().millisecondsSinceEpoch}',
          email: normalizedEmail,
          fullName: 'Admin User',
          isAdmin: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isAuthenticated = true;
      } else if (normalizedEmail == adminEmail) {
        throw Exception('Invalid admin credentials');
      } else if (normalizedEmail.isNotEmpty && password.length >= 6) {
        _currentUser = UserModel(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: normalizedEmail,
          fullName: normalizedEmail.split('@').first,
          skinType: 'Normal',
          skinConcerns: ['Dryness', 'Dark spots'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isAuthenticated = true;
      } else {
        throw Exception('Invalid email or password');
      }
      
      // Save to local storage
      await LocalStorageService.saveUser(_currentUser!);
      await LocalStorageService.saveOrUpdateUserInDirectory(_currentUser!);
      await LocalStorageService.setLoggedIn(true);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isNotEmpty && password.length >= 6 && fullName.isNotEmpty) {
        _currentUser = UserModel(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email.trim().toLowerCase(),
          fullName: fullName,
          skinType: null,
          skinConcerns: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isAuthenticated = true;
        
        // Save to local storage
        await LocalStorageService.saveUser(_currentUser!);
        await LocalStorageService.saveOrUpdateUserInDirectory(_currentUser!);
        await LocalStorageService.setLoggedIn(true);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Please fill all fields correctly');
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    // Clear local storage
    await LocalStorageService.clearUserData();
    
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = _currentUser!.copyWith(
        fullName: data['fullName'] ?? _currentUser!.fullName,
        phoneNumber: data['phoneNumber'] ?? _currentUser!.phoneNumber,
        skinType: data['skinType'] ?? _currentUser!.skinType,
        skinConcerns: data['skinConcerns'] != null 
            ? List<String>.from(data['skinConcerns']) 
            : _currentUser!.skinConcerns,
      );

      // Save updated user to local storage
      await LocalStorageService.saveUser(_currentUser!);
      await LocalStorageService.saveOrUpdateUserInDirectory(_currentUser!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
