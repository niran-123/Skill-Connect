import 'package:cloud_firestore/cloud_firestore.dart';

class JobProfile {
  final String id;
  final String customerId;
  final String description;
  final String categoryChosen;
  final Map<String, dynamic> analysis;
  final List<String> imageIds;
  final String? preferredDate;
  final String? preferredTime;
  final String? address;
  final double? lat;
  final double? lng;
  final String? notes;
  final String status;
  final DateTime? createdAt;

  JobProfile({
    required this.id,
    required this.customerId,
    required this.description,
    required this.categoryChosen,
    this.analysis = const {},
    this.imageIds = const [],
    this.preferredDate,
    this.preferredTime,
    this.address,
    this.lat,
    this.lng,
    this.notes,
    this.status = 'draft',
    this.createdAt,
  });

  factory JobProfile.fromMap(Map<String, dynamic> data, String id) {
    return JobProfile(
      id: id,
      customerId: data['customerId'] ?? '',
      description: data['description'] ?? '',
      categoryChosen: data['categoryChosen'] ?? '',
      analysis: Map<String, dynamic>.from(data['analysis'] ?? {}),
      imageIds: List<String>.from(data['imageIds'] ?? []),
      preferredDate: data['preferredDate'],
      preferredTime: data['preferredTime'],
      address: data['address'],
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
      notes: data['notes'],
      status: data['status'] ?? 'draft',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'description': description,
      'categoryChosen': categoryChosen,
      'analysis': analysis,
      'imageIds': imageIds,
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'address': address,
      'lat': lat,
      'lng': lng,
      'notes': notes,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
