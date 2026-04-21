import 'package:flutter/material.dart';
import 'package:skincare_app/data/models/consultation_model.dart';
import 'package:skincare_app/data/services/consultation_service.dart';

class ConsultationProvider with ChangeNotifier {
  final ConsultationService _consultationService = ConsultationService();

  List<ConsultationModel> _consultations = [];
  List<ConsultationModel> _upcomingConsultations = [];
  List<ConsultationModel> _pastConsultations = [];
  bool _isLoading = false;
  String? _error;

  List<ConsultationModel> get consultations => _consultations;
  List<ConsultationModel> get upcomingConsultations => _upcomingConsultations;
  List<ConsultationModel> get pastConsultations => _pastConsultations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all consultations for a user
  Future<void> loadUserConsultations(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _consultations = await _consultationService.getUserConsultations(userId);
      _upcomingConsultations = await _consultationService.getUpcomingConsultations(userId);
      _pastConsultations = await _consultationService.getPastConsultations(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new consultation
  Future<bool> addConsultation(ConsultationModel consultation) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final consultationId = await _consultationService.addConsultation(consultation);
      final newConsultation = consultation.copyWith(id: consultationId);
      _consultations.add(newConsultation);

      // Update upcoming/past lists
      if (newConsultation.date.isAfter(DateTime.now())) {
        _upcomingConsultations.add(newConsultation);
        _upcomingConsultations.sort((a, b) => a.date.compareTo(b.date));
      } else {
        _pastConsultations.insert(0, newConsultation);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update a consultation
  Future<bool> updateConsultation(String consultationId, ConsultationModel updatedConsultation) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultationService.updateConsultation(consultationId, updatedConsultation);

      final index = _consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        _consultations[index] = updatedConsultation;
      }

      // Update upcoming/past lists
      _upcomingConsultations.removeWhere((c) => c.id == consultationId);
      _pastConsultations.removeWhere((c) => c.id == consultationId);

      if (updatedConsultation.date.isAfter(DateTime.now())) {
        _upcomingConsultations.add(updatedConsultation);
        _upcomingConsultations.sort((a, b) => a.date.compareTo(b.date));
      } else {
        _pastConsultations.insert(0, updatedConsultation);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete a consultation
  Future<bool> deleteConsultation(String consultationId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultationService.deleteConsultation(consultationId);

      _consultations.removeWhere((c) => c.id == consultationId);
      _upcomingConsultations.removeWhere((c) => c.id == consultationId);
      _pastConsultations.removeWhere((c) => c.id == consultationId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data (admin function)
  Future<void> clearAllData() async {
    _consultations.clear();
    _upcomingConsultations.clear();
    _pastConsultations.clear();
    notifyListeners();
  }
}