import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/match_result.dart';

class ProfessionalDetailScreen extends StatelessWidget {
  final MatchResult match;
  const ProfessionalDetailScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final pro = match.professional;
    

    
    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.favorite_border, color: onSurfaceVariant), onPressed: () {}),
          IconButton(icon: Icon(Icons.share, color: onSurfaceVariant), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(pro.avatarThumb ?? 'https://via.placeholder.com/150/cccccc/ffffff?text=\${pro.name[0]}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.verified, color: Color(0xFF10B981), size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pro.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface)),
                            const SizedBox(height: 4),
                            Text(pro.category, style: TextStyle(fontSize: 14, color: onSurfaceVariant)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Color(0xFF1D4ED8)),
                                const SizedBox(width: 4),
                                Text('\${pro.area}, \${pro.city} • ~3 km away', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Key Stats Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem('Rating', '★ \$rating', "(\${pro.stats?['reviewCount'] ?? 0} reviews)"),
                      _buildStatItem('Experience', '\${pro.experienceYears}+ Years', 'Verified'),
                      _buildStatItem('Jobs', '\$jobs', 'Completed'),
                      _buildStatItem('Response', '~15 Mins', 'Average'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8), // Gap
            
            // Why we recommend card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, color: Color(0xFFF59E0B), size: 20),
                      const SizedBox(width: 8),
                      Text('Why we recommend \${pro.name.split(' ').first}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationRow('\${match.score}% AI match for your request'),
                  if (match.reasons.isNotEmpty) const SizedBox(height: 8),
                  if (match.reasons.isNotEmpty) _buildRecommendationRow(match.reasons.first),
                  const SizedBox(height: 8),
                  _buildRecommendationRow(pro.available ? 'Available today' : 'Can schedule this week'),
                  const SizedBox(height: 8),
                  _buildRecommendationRow('Background verified ID & Skill Certificate on file'),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // About
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 8),
                  Text(
                    pro.bio ?? 'Specialized in residential \${pro.category}. Committed to clean, punctual, and transparent service.',
                    style: TextStyle(fontSize: 14, color: onSurfaceVariant, height: 1.5),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Skills
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Skills & Trade Expertise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pro.skills.map((s) => _buildSkillChip(s)).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Services Offered
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Services Offered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 12),
                  _buildServiceRow('Standard Visit & Diagnosis', '₹250'),
                  const Divider(),
                  _buildServiceRow('Small Fixes', '₹350 - ₹500'),
                  const Divider(),
                  _buildServiceRow('Major Work', 'Custom Quote'),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Trusted Badge
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trusted Professional', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTrustBadge('Verified Identity'),
                      _buildTrustBadge('Verified Skills'),
                      _buildTrustBadge('Completed Jobs'),
                      _buildTrustBadge('Experience Guarantee'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 100), // padding for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹250 / visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
                  Text('Standard Inspection', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('customer-booking-request', extra: match);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Request Service', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String subLabel) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        Text(subLabel, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
      ],
    );
  }

  Widget _buildRecommendationRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)))),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 12, color: Color(0xFF1D4ED8)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildServiceRow(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A))),
          Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield, size: 12, color: Color(0xFF10B981)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
