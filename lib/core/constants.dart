class AppConstants {
  // Matching Weights
  static const double weightSkillMatch = 35.0;
  static const double weightTrustScore = 20.0;
  static const double weightSimilarJob = 20.0;
  static const double weightSuccessRate = 10.0;
  static const double weightAvailability = 5.0;
  static const double weightLocation = 5.0;
  static const double weightReviewRecency = 5.0;

  // Trust Score Weights
  static const double trustWeightVerified = 20.0;
  static const double trustWeightSuccessfulJobs = 20.0;
  static const double trustWeightSimilarJobs = 20.0;
  static const double trustWeightRating = 15.0;
  static const double trustWeightComplaints = 10.0; // Inverse
  static const double trustWeightCancellation = 5.0; // Inverse
  static const double trustWeightRecency = 5.0;
  static const double trustWeightCertifications = 5.0;

  static const double defaultTrustScore = 50.0;

  static const List<String> categories = [
    'AC Repair',
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Appliance Repair',
    'Cleaning',
    'Painting',
  ];

  static const Map<String, List<String>> skillCatalog = {
    'AC Repair': ['ac_repair', 'gas_refilling', 'compressor_repair', 'pcb_repair', 'deep_cleaning'],
    'Plumbing': ['pipe_repair', 'leak_fixing', 'water_heater', 'faucet_installation', 'drain_cleaning'],
    'Electrical': ['wiring', 'fan_installation', 'switch_repair', 'inverter_setup', 'mcb_replacement'],
    'Carpentry': ['furniture_repair', 'door_installation', 'lock_repair', 'wood_polishing'],
    'Appliance Repair': ['washing_machine', 'refrigerator', 'microwave', 'tv_repair', 'water_purifier'],
    'Cleaning': ['deep_cleaning', 'sofa_cleaning', 'bathroom_cleaning', 'pest_control'],
    'Painting': ['wall_painting', 'waterproofing', 'texture_painting'],
  };
}
