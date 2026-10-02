import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String bookingId;
  final String customerId;
  final String professionalId;
  final int rating;
  final bool problemSolved;
  final int professionalism;
  final int skillQuality;
  final int communication;
  final int timeliness;
  final String? comment;
  final bool complaint;
  final String? complaintText;
  final DateTime? createdAt;

  ReviewModel({
    required this.bookingId,
    required this.customerId,
    required this.professionalId,
    required this.rating,
    required this.problemSolved,
    required this.professionalism,
    required this.skillQuality,
    required this.communication,
    required this.timeliness,
    this.comment,
    required this.complaint,
    this.complaintText,
    this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> data, String id) {
    return ReviewModel(
      bookingId: id,
      customerId: data['customerId'] ?? '',
      professionalId: data['professionalId'] ?? '',
      rating: data['rating'] ?? 0,
      problemSolved: data['problemSolved'] ?? false,
      professionalism: data['professionalism'] ?? 0,
      skillQuality: data['skillQuality'] ?? 0,
      communication: data['communication'] ?? 0,
      timeliness: data['timeliness'] ?? 0,
      comment: data['comment'],
      complaint: data['complaint'] ?? false,
      complaintText: data['complaintText'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'customerId': customerId,
      'professionalId': professionalId,
      'rating': rating,
      'problemSolved': problemSolved,
      'professionalism': professionalism,
      'skillQuality': skillQuality,
      'communication': communication,
      'timeliness': timeliness,
      'comment': comment,
      'complaint': complaint,
      'complaintText': complaintText,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
