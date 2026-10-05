import 'dart:math';
import '../models/professional.dart';
import '../models/match_result.dart';
import '../models/job_profile.dart';

class MatchingService {
  // Simple haversine distance
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 + 
              cos(lat1 * p) * cos(lat2 * p) * 
              (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  List<MatchResult> rankProfessionals(
      List<ProfessionalModel> professionals, JobProfile job, List<String> requiredSkills) {
    List<MatchResult> results = [];

    for (var pro in professionals) {
      double totalScore = 0.0;
      List<String> reasons = [];

      // 1. Skill Match (0-40 points)
      int matchingSkills = 0;
      for (var skill in requiredSkills) {
        if (pro.skills.map((s) => s.toLowerCase()).contains(skill.toLowerCase())) {
          matchingSkills++;
        }
      }
      double skillScore = (requiredSkills.isEmpty) 
          ? 40.0 
          : (matchingSkills / requiredSkills.length) * 40.0;
      totalScore += skillScore;
      if (matchingSkills > 0) {
        reasons.add('Matches $matchingSkills required skill(s)');
      }

      // 2. Trust Score / Rating (0-30 points)
      double rating = (pro.stats['averageRating'] as num?)?.toDouble() ?? 0.0;
      int jobsCompleted = (pro.stats['jobsCompleted'] as num?)?.toInt() ?? 0;
      double trustScore = (rating / 5.0) * 20.0 + min((jobsCompleted / 10.0) * 10.0, 10.0);
      totalScore += trustScore;
      if (rating >= 4.5) {
        reasons.add('Highly rated professional (\${rating.toStringAsFixed(1)} ⭐️)');
      } else if (jobsCompleted > 20) {
        reasons.add('Highly experienced ($jobsCompleted jobs completed)');
      }

      // 3. Location / Distance (0-20 points)
      double locationScore = 10.0; // Default if coords not available
      if (job.lat != null && job.lng != null && pro.lat != null && pro.lng != null) {
        double distanceKm = _calculateDistance(job.lat!, job.lng!, pro.lat!, pro.lng!);
        if (distanceKm <= pro.serviceRadiusKm) {
          locationScore = max(0.0, 20.0 - distanceKm);
          if (distanceKm < 5.0) {
            reasons.add('Very close to your location (\${distanceKm.toStringAsFixed(1)} km)');
          }
        } else {
          // Out of radius, penalize heavily
          locationScore = 0.0;
          totalScore -= 20.0;
        }
      }
      totalScore += locationScore;

      // 4. Availability / Success rate (0-10 points)
      double successRate = (pro.stats['successRate'] as num?)?.toDouble() ?? 100.0;
      double successRateScore = (successRate / 100.0) * 10.0;
      totalScore += successRateScore;

      if (reasons.isEmpty) {
        reasons.add('Available for this category');
      }

      results.add(MatchResult(
        professional: pro,
        totalScore: totalScore,
        skillScore: skillScore,
        trustScore: trustScore,
        similarJobsScore: 0.0, // implement later if needed
        successRateScore: successRateScore,
        availabilityScore: 0.0, // implement later if needed
        locationScore: locationScore,
        recencyScore: 0.0,
        reasons: reasons,
      ));
    }

    // Sort descending by score
    results.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return results;
  }
}
