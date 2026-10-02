import 'package:cloud_firestore/cloud_firestore.dart';

class ImageRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> saveImage({
    required String ownerId,
    required String purpose,
    required String base64Data,
    required String mimeType,
    required int width,
    required int height,
    String? bookingId,
  }) async {
    final docRef = _db.collection('images').doc();
    
    final data = <String, dynamic>{
      'ownerId': ownerId,
      'purpose': purpose,
      'base64': base64Data,
      'mime': mimeType,
      'width': width,
      'height': height,
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (bookingId != null) {
      data['bookingId'] = bookingId;
    }
    
    await docRef.set(data);
    return docRef.id;
  }

  Future<Map<String, dynamic>?> getImage(String imageId) async {
    final snap = await _db.collection('images').doc(imageId).get();
    if (snap.exists && snap.data() != null) {
      return snap.data();
    }
    return null;
  }
}
