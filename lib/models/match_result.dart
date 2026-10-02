import 'professional.dart';

class MatchResult {
  final ProfessionalModel professional;
  final double totalScore;
  final double skillScore;
  final double trustScore;
  final double similarJobsScore;
  final double successRateScore;
  final double availabilityScore;
  final double locationScore;
  final double recencyScore;
  final List<String> reasons;

  MatchResult({
    required this.professional,
    required this.totalScore,
    required this.skillScore,
    required this.trustScore,
    required this.similarJobsScore,
    required this.successRateScore,
    required this.availabilityScore,
    required this.locationScore,
    required this.recencyScore,
    required this.reasons,
  });

  Map<String, dynamic> toMap() {
    return {
      'score': totalScore,
      'skill': skillScore,
      'trust': trustScore,
      'similarJobs': similarJobsScore,
      'successRate': successRateScore,
      'availability': availabilityScore,
      'location': locationScore,
      'recency': recencyScore,
      'reasons': reasons,
    };
  }
}
