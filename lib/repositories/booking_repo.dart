import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toMap());
  }

  Future<void> updateBookingStatus(String bookingId, String status, String byUid, {Map<String, dynamic>? extraData}) async {
    final updateData = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': FieldValue.arrayUnion([
        {
          'status': status,
          'at': Timestamp.now(),
          'byUid': byUid,
        }
      ]),
    };
    if (extraData != null) {
      updateData.addAll(extraData);
    }
    await _db.collection('bookings').doc(bookingId).update(updateData);
  }

  Stream<BookingModel?> streamBooking(String bookingId) {
    return _db.collection('bookings').doc(bookingId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return BookingModel.fromMap(snap.data()!, snap.id);
    });
  }

  Future<List<BookingModel>> getCustomerBookings(String customerId, {int limit = 20}) async {
    final snap = await _db.collection('bookings')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => BookingModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<BookingModel>> getProfessionalBookings(String professionalId, {int limit = 20}) async {
    final snap = await _db.collection('bookings')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => BookingModel.fromMap(d.data(), d.id)).toList();
  }
}
