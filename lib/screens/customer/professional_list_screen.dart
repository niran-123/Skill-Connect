import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/job_provider.dart';
import '../../models/match_result.dart';

class ProfessionalListScreen extends StatelessWidget {
  const ProfessionalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final matches = jobProvider.matches;

    
    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    final Color outline = const Color(0xFFCBD5E1);
    final Color surfaceContainerLowest = const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Matching Professionals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface)),
        centerTitle: true,
      ),
      body: jobProvider.isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primary),
                const SizedBox(height: 16),
                const Text('Finding the best professionals...', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          )
        : matches.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text('No matches found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
                    const SizedBox(height: 8),
                    Text('We could not find any verified professionals in your area for this issue.', textAlign: TextAlign.center, style: TextStyle(color: onSurfaceVariant)),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header summary
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: surfaceContainerLowest,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Based on your service request: \${currentJob?.analysis['problemType'] ?? 'Unknown Issue'}", style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: outline.withValues(alpha: 0.5))),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: Color(0xFF1D4ED8)),
                              const SizedBox(width: 8),
                              Expanded(child: Text("Priority: \${currentJob?.analysis['severity'] ?? 'Medium'}", style: TextStyle(fontSize: 12, color: onSurface, fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\${matches.length} Best Fit Professionals Found', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface)),
                        IconButton(
                          icon: Icon(Icons.filter_list, color: primary, size: 20),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return _buildProCard(
                        context: context,
                        match: match,
                        isTopMatch: index == 0,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildProCard({
    required BuildContext context,
    required MatchResult match,
    required bool isTopMatch,
  }) {
    final pro = match.professional;
    final score = match.totalScore;
    

    
    final Color primary = const Color(0xFF1D4ED8);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    final Color outline = const Color(0xFFCBD5E1);

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isTopMatch ? const Color(0xFFFDE047) : outline.withValues(alpha: 0.3), width: isTopMatch ? 1.5 : 1.0),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          if (isTopMatch)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1D4ED8), Color(0xFF4F46E5)]),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Color(0xFFFDE047), size: 14),
                  SizedBox(width: 6),
                  Text('BEST MATCH FOR YOU', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(pro.avatarThumb ?? 'https://via.placeholder.com/150/cccccc/ffffff?text=Pro'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.verified, color: Color(0xFF10B981), size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(pro.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                              const SizedBox(width: 4),
                              Text('\$rating', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: onSurface)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(pro.category, style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text('\$jobs completed', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(value: score / 100, color: primary, backgroundColor: outline.withValues(alpha: 0.3), strokeWidth: 3),
                        Center(child: Text('\$score%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primary))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Skill Match: \${(score + 2).clamp(0, 100)}%', style: TextStyle(fontSize: 10, color: onSurfaceVariant)),
                            Text('Exp: \${(score - 1).clamp(0, 100)}%', style: TextStyle(fontSize: 10, color: onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(pro.available ? 'Available' : 'Busy', style: TextStyle(fontSize: 10, color: pro.available ? const Color(0xFF10B981) : Colors.orange, fontWeight: FontWeight.w600)),
                            Text('~3 km away', style: TextStyle(fontSize: 10, color: onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: pro.skills.take(3).map((s) => _buildSkillChip(s)).toList(),
            ),
          ),
          
          const Divider(height: 1),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹250 / visit inspection', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: onSurface)),
                ElevatedButton(
                  onPressed: () => context.pushNamed('customer-match-detail', pathParameters: {'id': pro.uid}, extra: match),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTopMatch ? primary : Colors.white,
                    foregroundColor: isTopMatch ? Colors.white : primary,
                    side: BorderSide(color: primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
    );
  }
}
