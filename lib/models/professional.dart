import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalModel {
  final String uid;
  final String name;
  final String category;
  final String city;
  final String area;
  final double? lat;
  final double? lng;
  final String? bio;
  final String? serviceDescription;
  final int experienceYears;
  final double serviceRadiusKm;
  final List<String> skills;
  final bool available;
  final Map<String, dynamic> schedule;
  final String verificationStatus;
  final String? verificationNote;
  final List<dynamic> certificates;
  final String? avatarThumb;
  final Map<String, dynamic> stats;
  final Map<String, dynamic> skillStats;
  final List<String> searchTokens;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfessionalModel({
    required this.uid,
    required this.name,
    required this.category,
    required this.city,
    required this.area,
    this.lat,
    this.lng,
    this.bio,
    this.serviceDescription,
    this.experienceYears = 0,
    this.serviceRadiusKm = 15.0,
    this.skills = const [],
    this.available = true,
    this.schedule = const {},
    this.verificationStatus = 'unsubmitted',
    this.verificationNote,
    this.certificates = const [],
    this.avatarThumb,
    this.stats = const {},
    this.skillStats = const {},
    this.searchTokens = const [],
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfessionalModel.fromMap(Map<String, dynamic> data, String uid) {
    return ProfessionalModel(
      uid: uid,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      city: data['city'] ?? '',
      area: data['area'] ?? '',
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
      bio: data['bio'],
      serviceDescription: data['serviceDescription'],
      experienceYears: data['experienceYears'] ?? 0,
      serviceRadiusKm: (data['serviceRadiusKm'] as num?)?.toDouble() ?? 15.0,
      skills: List<String>.from(data['skills'] ?? []),
      available: data['available'] ?? true,
      schedule: Map<String, dynamic>.from(data['schedule'] ?? {}),
      verificationStatus: data['verificationStatus'] ?? 'unsubmitted',
      verificationNote: data['verificationNote'],
      certificates: List<dynamic>.from(data['certificates'] ?? []),
      avatarThumb: data['avatarThumb'],
      stats: Map<String, dynamic>.from(data['stats'] ?? {}),
      skillStats: Map<String, dynamic>.from(data['skillStats'] ?? {}),
      searchTokens: List<String>.from(data['searchTokens'] ?? []),
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'city': city,
      'area': area,
      'lat': lat,
      'lng': lng,
      'bio': bio,
      'serviceDescription': serviceDescription,
      'experienceYears': experienceYears,
      'serviceRadiusKm': serviceRadiusKm,
      'skills': skills,
      'available': available,
      'schedule': schedule,
      'verificationStatus': verificationStatus,
      'verificationNote': verificationNote,
      'certificates': certificates,
      'avatarThumb': avatarThumb,
      'stats': stats,
      'skillStats': skillStats,
      'searchTokens': searchTokens,
      'fcmToken': fcmToken,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
