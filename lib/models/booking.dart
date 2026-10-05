import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/booking_status.dart';

class BookingModel {
  final String id;
  final String jobId;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String? customerThumb;
  final String professionalId;
  final String professionalName;
  final String? professionalThumb;
  final Map<String, dynamic> jobSnapshot;
  final String? scheduledDate;
  final String? timeSlot;
  final String? address;
  final double? lat;
  final double? lng;
  final double? distanceKm;
  final double? estimatedCharge;
  final double? finalCharge;
  final Map<String, dynamic> match;
  final String status;
  final List<dynamic> statusHistory;
  final String? workSummary;
  final String? completionImageId;
  final String? completionNotes;
  final bool reviewed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // New timestamp fields for each step
  final DateTime? customerConfirmedAt;
  final DateTime? professionalArrivedAt;
  final DateTime? jobStartedAt;
  final DateTime? jobCompletedAt;

  BookingModel({
    required this.id,
    required this.jobId,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerThumb,
    required this.professionalId,
    required this.professionalName,
    this.professionalThumb,
    required this.jobSnapshot,
    this.scheduledDate,
    this.timeSlot,
    this.address,
    this.lat,
    this.lng,
    this.distanceKm,
    this.estimatedCharge,
    this.finalCharge,
    this.match = const {},
    this.status = BookingStatus.requestCreated,
    this.statusHistory = const [],
    this.workSummary,
    this.completionImageId,
    this.completionNotes,
    this.reviewed = false,
    this.createdAt,
    this.updatedAt,
    this.customerConfirmedAt,
    this.professionalArrivedAt,
    this.jobStartedAt,
    this.jobCompletedAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> data, String id) {
    return BookingModel(
      id: id,
      jobId: data['jobId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'],
      customerThumb: data['customerThumb'],
      professionalId: data['professionalId'] ?? '',
      professionalName: data['professionalName'] ?? '',
      professionalThumb: data['professionalThumb'],
      jobSnapshot: Map<String, dynamic>.from(data['jobSnapshot'] ?? {}),
      scheduledDate: data['scheduledDate'],
      timeSlot: data['timeSlot'],
      address: data['address'],
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
      distanceKm: (data['distanceKm'] as num?)?.toDouble(),
      estimatedCharge: (data['estimatedCharge'] as num?)?.toDouble(),
      finalCharge: (data['finalCharge'] as num?)?.toDouble(),
      match: Map<String, dynamic>.from(data['match'] ?? {}),
      status: data['status'] ?? BookingStatus.requestCreated,
      statusHistory: List<dynamic>.from(data['statusHistory'] ?? []),
      workSummary: data['workSummary'],
      completionImageId: data['completionImageId'],
      completionNotes: data['completionNotes'],
      reviewed: data['reviewed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      customerConfirmedAt: (data['customerConfirmedAt'] as Timestamp?)?.toDate(),
      professionalArrivedAt: (data['professionalArrivedAt'] as Timestamp?)?.toDate(),
      jobStartedAt: (data['jobStartedAt'] as Timestamp?)?.toDate(),
      jobCompletedAt: (data['jobCompletedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerThumb': customerThumb,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'professionalThumb': professionalThumb,
      'jobSnapshot': jobSnapshot,
      'scheduledDate': scheduledDate,
      'timeSlot': timeSlot,
      'address': address,
      'lat': lat,
      'lng': lng,
      'distanceKm': distanceKm,
      'estimatedCharge': estimatedCharge,
      'finalCharge': finalCharge,
      'match': match,
      'status': status,
      'statusHistory': statusHistory,
      'workSummary': workSummary,
      'completionImageId': completionImageId,
      'completionNotes': completionNotes,
      'reviewed': reviewed,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
