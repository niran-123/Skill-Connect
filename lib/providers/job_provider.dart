import 'package:flutter/material.dart';
import '../../models/job_profile.dart';
import '../../models/match_result.dart';
import '../../services/gemini_service.dart';
import '../../services/matching_service.dart';
import '../../repositories/professional_repo.dart';
import '../../repositories/booking_repo.dart';
import '../../models/booking.dart';
import '../../models/professional.dart';
import '../../models/review.dart' as import_review;
import 'package:cloud_firestore/cloud_firestore.dart' as import_firestore;
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../../core/booking_status.dart';

class JobProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final MatchingService _matchingService = MatchingService();
  final ProfessionalRepo _proRepo = ProfessionalRepo();
  final BookingRepo _bookingRepo = BookingRepo();
  
  bool _isLoading = false;
  String? _errorMessage;
  JobProfile? _currentJob;
  List<MatchResult> _matches = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  JobProfile? get currentJob => _currentJob;
  List<MatchResult> get matches => _matches;

  JobProvider() {
    _geminiService.init();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> processJobRequest(String description, String customerId, {double? lat, double? lng, String? city, String? explicitCategory}) async {
    _setLoading(true);
    _setError(null);
    _currentJob = null;
    _matches = [];

    try {
      final analysis = await _geminiService.analyzeJobDescription(description);
      
      String mapCategoryToFull(String cat) {
        final lowerCat = cat.toLowerCase();
        if (lowerCat.contains('ac') || lowerCat.contains('appliance')) return '❄️ AC Technician / AC Mechanic';
        if (lowerCat.contains('plumb')) return '🔧 Plumber';
        if (lowerCat.contains('electric')) return '⚡ Electrician';
        if (lowerCat.contains('carpent')) return '🪚 Carpenter';
        if (lowerCat.contains('paint')) return '🎨 Painter';
        if (lowerCat.contains('mason') || lowerCat.contains('construct')) return '🧱 Mason / Construction Worker';
        if (lowerCat.contains('weld')) return '🔩 Welder';
        if (lowerCat.contains('two-wheel')) return '🛵 Two-Wheeler Mechanic';
        if (lowerCat.contains('car mech')) return '🚗 Car Mechanic';
        if (lowerCat.contains('clean')) return '🧹 Cleaning / Housekeeping Professional';
        if (lowerCat.contains('locksmith')) return '🔑 Locksmith';
        if (lowerCat.contains('mobile')) return '📱 Mobile Phone Technician';
        if (lowerCat.contains('roof')) return '🏠 Roofing / Waterproofing Worker';
        if (lowerCat.contains('garden') || lowerCat.contains('landscape')) return '🌿 Gardener / Landscaping Professional';
        if (lowerCat.contains('wash')) return '🧼 Car/Bike Washing Professional';
        if (lowerCat.contains('glass') || lowerCat.contains('alum')) return '🪟 Glass & Aluminium Worker';
        if (lowerCat.contains('furniture')) return '🛋️ Furniture Repair Technician';
        if (lowerCat.contains('ro water') || lowerCat.contains('purifier')) return '🔧 RO Water Purifier Technician';
        if (lowerCat.contains('tv') || lowerCat.contains('electronic')) return '📺 TV & Electronics Repair Technician';
        return '🧰 Appliance Repair Technician'; // Default fallback
      }

      final aiCategory = analysis['category'] ?? 'Handyman';
      final fullCategory = explicitCategory ?? mapCategoryToFull(aiCategory);
      
      // Override the analysis category with the explicit one so the UI displays it correctly
      analysis['category'] = fullCategory;
      
      final requiredSkills = List<String>.from(analysis['requiredSkills'] ?? []);
      
      _currentJob = JobProfile(
        id: const Uuid().v4(),
        customerId: customerId,
        description: description,
        categoryChosen: fullCategory,
        analysis: analysis,
        lat: lat,
        lng: lng,
      );

      // Fetch professionals in category and city strictly
      List<ProfessionalModel> pros = await _proRepo.searchProfessionals(category: fullCategory, city: city, verifiedOnly: false);
      
      // Rank them
      _matches = _matchingService.rankProfessionals(pros, _currentJob!, requiredSkills);

    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> bookProfessional({
    required MatchResult match,
    required String customerId,
    required String customerName,
  }) async {
    if (_currentJob == null) return false;
    _setLoading(true);
    _setError(null);

    try {
      final booking = BookingModel(
        id: const Uuid().v4(),
        jobId: _currentJob!.id,
        customerId: customerId,
        customerName: customerName,
        professionalId: match.professional.uid,
        professionalName: match.professional.name,
        professionalThumb: match.professional.avatarThumb,
        jobSnapshot: _currentJob!.toMap(),
        match: match.toMap(),
        lat: _currentJob!.lat,
        lng: _currentJob!.lng,
        // Status is forced to REQUEST_CREATED by BookingRepo.createBooking()
        status: BookingStatus.requestCreated,
      );

      await _bookingRepo.createBooking(booking);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  List<BookingModel> _customerBookings = [];
  List<BookingModel> get customerBookings => _customerBookings;
  StreamSubscription? _customerBookingsSub;
  StreamSubscription? _singleBookingSub;
  BookingModel? _liveBooking;
  BookingModel? get liveBooking => _liveBooking;

  Future<void> loadCustomerBookings(String customerId) async {
    _setLoading(true);
    try {
      _customerBookingsSub?.cancel();
      _customerBookingsSub = _bookingRepo.streamCustomerBookings(customerId).listen((bookings) {
        _customerBookings = bookings;
        notifyListeners();
      });
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Subscribe to a single booking for the Live Tracker.
  void subscribeToBooking(String bookingId) {
    _singleBookingSub?.cancel();
    _singleBookingSub = _bookingRepo.streamBooking(bookingId).listen((booking) {
      _liveBooking = booking;
      // Also update the booking in the main list if it exists
      if (booking != null) {
        final idx = _customerBookings.indexWhere((b) => b.id == bookingId);
        if (idx >= 0) {
          _customerBookings[idx] = booking;
        }
      }
      notifyListeners();
    });
  }

  void unsubscribeFromBooking() {
    _singleBookingSub?.cancel();
    _singleBookingSub = null;
    _liveBooking = null;
  }

  List<ProfessionalModel> _savedProfessionals = [];
  List<ProfessionalModel> get savedProfessionals => _savedProfessionals;

  Future<void> loadSavedProfessionals(List<String> ids) async {
    if (ids.isEmpty) {
      _savedProfessionals = [];
      notifyListeners();
      return;
    }
    _setLoading(true);
    try {
      _savedProfessionals = await _proRepo.getProfessionalsByIds(ids);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  List<BookingModel> _professionalBookings = [];
  List<BookingModel> get professionalBookings => _professionalBookings;
  StreamSubscription? _professionalBookingsSub;

  Future<void> loadProfessionalBookings(String professionalId) async {
    _setLoading(true);
    try {
      _professionalBookingsSub?.cancel();
      _professionalBookingsSub = _bookingRepo.streamProfessionalBookings(professionalId).listen((bookings) {
        _professionalBookings = bookings;
        notifyListeners();
      });
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBookingStatus(String bookingId, String status, String byUid, {bool isCustomer = false}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _bookingRepo.updateBookingStatus(bookingId, status, byUid);
      // Removed manual reload since streams will automatically update the UI
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _customerBookingsSub?.cancel();
    _professionalBookingsSub?.cancel();
    _singleBookingSub?.cancel();
    super.dispose();
  }

  Future<bool> submitReview(import_review.ReviewModel review) async {
    _setLoading(true);
    _setError(null);
    try {
      final db = import_firestore.FirebaseFirestore.instance;
      final batch = db.batch();

      // 1. Create Review
      final reviewRef = db.collection('reviews').doc(review.bookingId);
      batch.set(reviewRef, review.toMap());

      // 2. Update Booking
      final bookingRef = db.collection('bookings').doc(review.bookingId);
      batch.update(bookingRef, {
        'reviewed': true,
        'updatedAt': import_firestore.FieldValue.serverTimestamp()
      });

      // 3. Update Professional Stats
      final proRef = db.collection('professionals').doc(review.professionalId);
      final proSnap = await proRef.get();
      if (proSnap.exists && proSnap.data() != null) {
        final data = proSnap.data()!;
        final stats = Map<String, dynamic>.from(data['stats'] ?? {});
        
        int jobsCompleted = (stats['jobsCompleted'] as num?)?.toInt() ?? 0;
        int reviewCount = (stats['reviewCount'] as num?)?.toInt() ?? 0;
        double averageRating = (stats['averageRating'] as num?)?.toDouble() ?? 0.0;
        
        // Recalculate
        double totalRating = averageRating * reviewCount;
        reviewCount += 1;
        averageRating = (totalRating + review.rating) / reviewCount;
        jobsCompleted += 1; // Assuming every reviewed job was completed

        stats['jobsCompleted'] = jobsCompleted;
        stats['reviewCount'] = reviewCount;
        stats['averageRating'] = averageRating;

        batch.update(proRef, {
          'stats': stats,
          'updatedAt': import_firestore.FieldValue.serverTimestamp()
        });
      }

      await batch.commit();
      
      // Reload bookings
      _customerBookings = await _bookingRepo.getCustomerBookings(review.customerId);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
