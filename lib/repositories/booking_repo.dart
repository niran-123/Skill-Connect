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
    final docRef = _db.collection('bookings').doc(bookingId);

    await _db.runTransaction((transaction) async {
      final snap = await transaction.get(docRef);
      if (!snap.exists || snap.data() == null) {
        throw Exception("Booking not found");
      }
      
      final data = snap.data()!;
      final currentStatus = data['status'] as String?;
      final customerId = data['customerId'] as String?;
      final professionalId = data['professionalId'] as String?;

      switch (newStatus) {
        case BookingStatus.professionalAccepted:
          if (byUid != professionalId) throw Exception("Only the assigned professional can accept.");
          if (currentStatus != BookingStatus.requestCreated) throw Exception("Cannot accept a request that is not in created state.");
          break;
        case BookingStatus.customerConfirmed:
          if (byUid != customerId) throw Exception("Only the customer can confirm the proposal.");
          if (currentStatus != BookingStatus.professionalAccepted) throw Exception("Cannot confirm unless professional has sent a proposal.");
          break;
        case BookingStatus.cancelled:
          if (byUid != customerId && byUid != professionalId) throw Exception("Unauthorized cancellation.");
          break;
        case BookingStatus.professionalArrived:
          if (byUid != professionalId) throw Exception("Only the professional can mark arrived.");
          if (currentStatus != BookingStatus.customerConfirmed) throw Exception("Cannot mark arrived until customer confirms.");
          break;
        case BookingStatus.jobStarted:
          if (byUid != professionalId) throw Exception("Only the professional can start the job.");
          if (currentStatus != BookingStatus.professionalArrived) throw Exception("Cannot start job before arriving.");
          break;
        case BookingStatus.jobCompleted:
          if (byUid != customerId) throw Exception("Only the customer can mark the job as completed.");
          if (currentStatus != BookingStatus.jobStarted) throw Exception("Cannot complete job before it is started.");
          break;
      }

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

      transaction.update(docRef, updateData);
    });
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
