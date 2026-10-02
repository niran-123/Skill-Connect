import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createReview(ReviewModel review) async {
    // Should typically be a batched write at the service level handling stats
    await _db.collection('reviews').doc(review.bookingId).set(review.toMap());
  }

  Future<List<ReviewModel>> getProfessionalReviews(String professionalId, {int limit = 20}) async {
    final snap = await _db.collection('reviews')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => ReviewModel.fromMap(d.data(), d.id)).toList();
  }
}
