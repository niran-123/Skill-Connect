import 'package:flutter/material.dart';
import '../../models/professional.dart';
import '../../models/booking.dart';
import '../../repositories/professional_repo.dart';
import '../../repositories/booking_repo.dart';

class ProfessionalProvider extends ChangeNotifier {
  final ProfessionalRepo _proRepo = ProfessionalRepo();
  final BookingRepo _bookingRepo = BookingRepo();
  
  bool _isLoading = false;
  String? _errorMessage;
  ProfessionalModel? _professional;
  List<BookingModel> _bookings = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfessionalModel? get professional => _professional;
  List<BookingModel> get bookings => _bookings;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> loadDashboard(String professionalId) async {
    _setLoading(true);
    try {
      _professional = await _proRepo.getProfessional(professionalId);
      if (_professional == null) {
        // First time, create basic profile
        _professional = ProfessionalModel(
          uid: professionalId,
          name: 'New Professional',
          category: 'Handyman',
          city: 'City',
          area: 'Area',
        );
        await _proRepo.createProfessional(_professional!);
      }
      
      // Load bookings
      _bookings = await _bookingRepo.getProfessionalBookings(professionalId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSettings(ProfessionalModel updatedProfile) async {
    _setLoading(true);
    try {
      await _proRepo.updateProfessional(updatedProfile.uid, updatedProfile.toMap());
      _professional = updatedProfile;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBookingStatus(String bookingId, String status, String byUid, {Map<String, dynamic>? extraData}) async {
    _setLoading(true);
    try {
      await _bookingRepo.updateBookingStatus(bookingId, status, byUid, extraData: extraData);
      // Reload bookings
      if (_professional != null) {
        _bookings = await _bookingRepo.getProfessionalBookings(_professional!.uid);
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
