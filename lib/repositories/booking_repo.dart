import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../core/booking_status.dart';

class BookingRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Creates a new booking with status REQUEST_CREATED.
  /// Only the customer-supplied fields are accepted on creation; status is forced.
  Future<void> createBooking(BookingModel booking) async {
    final data = booking.toMap();
    // Always force initial status to REQUEST_CREATED regardless of what the model says
    data['status'] = BookingStatus.requestCreated;
    await _db.collection('bookings').doc(booking.id).set(data);
  }

  /// Updates the booking status with server-side validation.
  /// [extraData] may include amount/date/time (for PROFESSIONAL_ACCEPTED) or
  /// step timestamps. The repo adds the appropriate server timestamp automatically.
  Future<void> updateBookingStatus(
    String bookingId,
    String newStatus,
    String byUid, {
    Map<String, dynamic>? extraData,
  }) async {
    final updateData = <String, dynamic>{
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': FieldValue.arrayUnion([
        {
          'status': newStatus,
          'at': Timestamp.now(),
          'byUid': byUid,
        }
      ]),
    };

    // Add the step-specific server timestamp
    switch (newStatus) {
      case BookingStatus.customerConfirmed:
        updateData['customerConfirmedAt'] = FieldValue.serverTimestamp();
        break;
      case BookingStatus.professionalArrived:
        updateData['professionalArrivedAt'] = FieldValue.serverTimestamp();
        break;
      case BookingStatus.jobStarted:
        updateData['jobStartedAt'] = FieldValue.serverTimestamp();
        break;
      case BookingStatus.jobCompleted:
        updateData['jobCompletedAt'] = FieldValue.serverTimestamp();
        break;
    }

    if (extraData != null) {
      updateData.addAll(extraData);
    }

    await _db.collection('bookings').doc(bookingId).update(updateData);
  }

  /// Real-time stream for a single booking document — used by both apps for
  /// live status tracking.
  Stream<BookingModel?> streamBooking(String bookingId) {
    return _db.collection('bookings').doc(bookingId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return BookingModel.fromMap(snap.data()!, snap.id);
    });
  }

  /// Real-time stream of all bookings for a customer.
  Stream<List<BookingModel>> streamCustomerBookings(String customerId, {int limit = 50}) {
    return _db
        .collection('bookings')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => BookingModel.fromMap(d.data(), d.id)).toList());
  }

  /// Real-time stream of all bookings for a professional.
  Stream<List<BookingModel>> streamProfessionalBookings(String professionalId, {int limit = 50}) {
    return _db
        .collection('bookings')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => BookingModel.fromMap(d.data(), d.id)).toList());
  }

  Future<List<BookingModel>> getCustomerBookings(String customerId, {int limit = 50}) async {
    final snap = await _db
        .collection('bookings')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => BookingModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<BookingModel>> getProfessionalBookings(String professionalId, {int limit = 50}) async {
    final snap = await _db
        .collection('bookings')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => BookingModel.fromMap(d.data(), d.id)).toList();
  }
}
