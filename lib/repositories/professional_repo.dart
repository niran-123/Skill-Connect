import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/professional.dart';

class ProfessionalRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<ProfessionalModel?> getProfessional(String uid) async {
    final doc = await _db.collection('professionals').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return ProfessionalModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<ProfessionalModel>> getProfessionalsByIds(List<String> uids) async {
    if (uids.isEmpty) return [];
    final snap = await _db.collection('professionals').where(FieldPath.documentId, whereIn: uids.take(10).toList()).get();
    return snap.docs.map((d) => ProfessionalModel.fromMap(d.data(), d.id)).toList();
  }

  Future<void> createProfessional(ProfessionalModel professional) async {
    await _db.collection('professionals').doc(professional.uid).set(professional.toMap());
  }

  Future<void> updateProfessional(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('professionals').doc(uid).update(data);
  }

  Future<List<ProfessionalModel>> searchProfessionals({
    String? category,
    bool verifiedOnly = true,
  }) async {
    Query query = _db.collection('professionals')
        .where('available', isEqualTo: true);
        
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
        
    if (verifiedOnly) {
      query = query.where('verificationStatus', isEqualTo: 'verified');
    }
    
    final snap = await query.limit(30).get();
    return snap.docs.map((d) => ProfessionalModel.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
  }
}
