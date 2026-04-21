import 'package:flutter/material.dart';
import 'package:skincare_app/data/models/routine_model.dart';
import 'package:skincare_app/data/services/local_storage_service.dart';

class RoutineProvider with ChangeNotifier {
  List<RoutineModel> _routines = [];
  RoutineModel? _selectedRoutine;
  bool _isLoading = false;
  String? _error;

  List<RoutineModel> get routines => _routines;
  RoutineModel? get selectedRoutine => _selectedRoutine;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RoutineProvider() {
    _loadRoutinesAsync();
  }

  void _loadRoutinesAsync() async {
    await Future.microtask(() {}); // Ensure this runs after build
    await loadRoutines();
  }

  Future<void> loadRoutines() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load from local storage
      _routines = LocalStorageService.getRoutines();
      
      // If no saved routines, create default ones
      if (_routines.isEmpty) {
        _routines = [
          RoutineModel(
            id: '1',
            userId: 'user_123',
            name: 'Morning Routine',
            time: 'Morning',
            products: [
              RoutineProduct(productId: '1', productName: 'Hydrating Cleanser', order: 1),
              RoutineProduct(productId: '2', productName: 'Vitamin C Serum', order: 2),
              RoutineProduct(productId: '3', productName: 'Daily Moisturizer SPF 30', order: 3),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          RoutineModel(
            id: '2',
            userId: 'user_123',
            name: 'Evening Routine',
            time: 'Evening',
            products: [
              RoutineProduct(productId: '1', productName: 'Hydrating Cleanser', order: 1),
              RoutineProduct(productId: '5', productName: 'Niacinamide Toner', order: 2),
              RoutineProduct(productId: '4', productName: 'Retinol Night Cream', order: 3),
              RoutineProduct(productId: '6', productName: 'Eye Cream', order: 4),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
        // Save default routines
        await LocalStorageService.saveRoutines(_routines);
      }
      
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRoutine(RoutineModel routine) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _routines.add(routine);
      
      // Save to local storage
      await LocalStorageService.saveRoutines(_routines);
      
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRoutine(String routineId, RoutineModel updatedRoutine) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _routines.indexWhere((r) => r.id == routineId);
      if (index != -1) {
        _routines[index] = updatedRoutine;
        
        // Save to local storage
        await LocalStorageService.saveRoutines(_routines);
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRoutine(String routineId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _routines.removeWhere((r) => r.id == routineId);
      
      // Save to local storage
      await LocalStorageService.saveRoutines(_routines);
      
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectRoutine(RoutineModel routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }

  void clearSelectedRoutine() {
    _selectedRoutine = null;
    notifyListeners();
  }

  List<RoutineModel> getRoutinesByTime(String time) {
    return _routines.where((r) => r.time == time).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data (admin function)
  Future<void> clearAllData() async {
    _routines.clear();
    _selectedRoutine = null;
    notifyListeners();
  }
}
