import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String role;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final double? lat;
  final double? lng;
  final String? avatarThumb;
  final String? avatarImageId;
  final String? fullAddress;
  final List<String> savedProfessionalIds;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.role,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.lat,
    this.lng,
    this.avatarThumb,
    this.avatarImageId,
    this.fullAddress,
    this.savedProfessionalIds = const [],
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      role: data['role'] ?? 'customer',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      address: data['address'],
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
      avatarThumb: data['avatarThumb'],
      avatarImageId: data['avatarImageId'],
      fullAddress: data['fullAddress'],
      savedProfessionalIds: List<String>.from(data['savedProfessionalIds'] ?? []),
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'lat': lat,
      'lng': lng,
      'avatarThumb': avatarThumb,
      'avatarImageId': avatarImageId,
      'fullAddress': fullAddress,
      'savedProfessionalIds': savedProfessionalIds,
      'fcmToken': fcmToken,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
