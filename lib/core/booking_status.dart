/// Canonical booking status constants — single source of truth.
/// These match exactly the 6-step workflow defined in the business requirements.
class BookingStatus {
  BookingStatus._();

  // Status strings (stored in Firestore)
  static const String requestCreated       = 'REQUEST_CREATED';
  static const String professionalAccepted = 'PROFESSIONAL_ACCEPTED';
  static const String customerConfirmed    = 'CUSTOMER_CONFIRMED';
  static const String professionalArrived  = 'PROFESSIONAL_ARRIVED';
  static const String jobStarted           = 'JOB_STARTED';
  static const String jobCompleted         = 'JOB_COMPLETED';

  // Extra non-workflow statuses
  static const String cancelled = 'CANCELLED';

  // Ordered workflow list
  static const List<String> workflowOrder = [
    requestCreated,
    professionalAccepted,
    customerConfirmed,
    professionalArrived,
    jobStarted,
    jobCompleted,
  ];

  // Human-readable label for Live Tracker
  static String label(String status) {
    switch (status) {
      case requestCreated:       return 'Request Created';
      case professionalAccepted: return 'Professional Accepted';
      case customerConfirmed:    return 'Customer Confirmed';
      case professionalArrived:  return 'Professional Arrived';
      case jobStarted:           return 'Job Started';
      case jobCompleted:         return 'Job Completed';
      case cancelled:            return 'Cancelled';
      default:                   return status;
    }
  }

  // Returns the index (0-based) in the workflow, or -1 if not found.
  static int workflowIndex(String status) => workflowOrder.indexOf(status);

  // Returns true if status is terminal (no more transitions possible).
  static bool isTerminal(String status) =>
      status == jobCompleted || status == cancelled;
}
