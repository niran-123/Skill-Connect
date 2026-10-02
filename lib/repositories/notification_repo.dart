import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_notification.dart';

class NotificationRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createNotification(AppNotification notification) async {
    await _db.collection('notifications').doc(notification.id).set(notification.toMap());
  }

  Stream<List<AppNotification>> streamUnreadNotifications(String uid) {
    return _db.collection('notifications')
        .where('toUid', isEqualTo: uid)
        .where('read', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => AppNotification.fromMap(d.data(), d.id)).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({'read': true});
  }
}
