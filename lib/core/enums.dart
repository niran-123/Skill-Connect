enum UserRole {
  customer,
  professional,
  admin,
}

enum VerificationStatus {
  unsubmitted,
  pending,
  verified,
  rejected,
}

enum JobStatus {
  draft,
  booked,
  closed,
}

// NOTE: String constants are defined in core/booking_status.dart
// This enum is kept for type safety in the legacy code paths.
enum BookingStatusEnum {
  requestCreated,
  professionalAccepted,
  customerConfirmed,
  professionalArrived,
  jobStarted,
  jobCompleted,
  cancelled,
  rejected,
}

enum Severity {
  low,
  medium,
  high,
}
