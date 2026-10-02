import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String toUid;
  final String fromUid;
  final String type;
  final String title;
  final String body;
  final String? bookingId;
  final bool read;
  final DateTime? createdAt;

  AppNotification({
    required this.id,
    required this.toUid,
    required this.fromUid,
    required this.type,
    required this.title,
    required this.body,
    this.bookingId,
    this.read = false,
    this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> data, String id) {
    return AppNotification(
      id: id,
      toUid: data['toUid'] ?? '',
      fromUid: data['fromUid'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      bookingId: data['bookingId'],
      read: data['read'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toUid': toUid,
      'fromUid': fromUid,
      'type': type,
      'title': title,
      'body': body,
      'bookingId': bookingId,
      'read': read,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
