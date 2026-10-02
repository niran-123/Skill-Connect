import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/session_provider.dart';

class SavedProfessionalsScreen extends StatefulWidget {
  const SavedProfessionalsScreen({super.key});

  @override
  State<SavedProfessionalsScreen> createState() => _SavedProfessionalsScreenState();
}

class _SavedProfessionalsScreenState extends State<SavedProfessionalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<SessionProvider>().userModel;
      if (user != null) {
        context.read<JobProvider>().loadSavedProfessionals(user.savedProfessionalIds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final savedPros = jobProvider.savedProfessionals;

    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    final Color outline = const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Saved Professionals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
              child: Text('${savedPros.length} Saved', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.search, color: onSurfaceVariant), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Category Strip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPill('All (${savedPros.length})', true, primary),
                ],
              ),
            ),
          ),

          Expanded(
            child: jobProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : savedPros.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_border, size: 48, color: Color(0xFFCBD5E1)),
                        const SizedBox(height: 16),
                        Text('No saved professionals yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                        const SizedBox(height: 8),
                        Text('Tap the heart icon on any professional\'s profile or search card to quickly rebook them here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => context.goNamed('customer-home'),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: outline), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: const Text('Browse Recommended Pros'),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: savedPros.length,
                    itemBuilder: (context, index) {
                      final p = savedPros[index];
                      return _buildSavedCard(
                        context,
                        name: p.name,
                        title: 'Master ${p.category}',
                        rating: 4.8, // Fallback since stats aren't exposed cleanly yet
                        reviews: 20,
                        exp: '5+',
                        distance: '${p.city}, ${p.area}',
                        skills: p.skills,
                        available: p.available ? 'Available Now' : 'Currently Busy',
                        availableBg: p.available ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                        availableCol: p.available ? const Color(0xFF10B981) : const Color(0xFF64748B),
                        uid: p.uid,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String label, bool isSelected, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.white,
        border: Border.all(color: isSelected ? color : const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildSavedCard(
    BuildContext context, {
    required String name,
    required String title,
    required double rating,
    required int reviews,
    required String exp,
    required String distance,
    required List<String> skills,
    required String available,
    required Color availableBg,
    required Color availableCol,
    required String uid,
  }) {
    final Color primary = const Color(0xFF1D4ED8);
    final Color outline = const Color(0xFFCBD5E1);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 28, backgroundColor: Colors.grey.shade200, backgroundImage: const NetworkImage('https://via.placeholder.com/150')),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.verified, color: Color(0xFF10B981), size: 14))),
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
                          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          const Icon(Icons.favorite, color: Color(0xFFEF4444), size: 20),
                        ],
                      ),
                      Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 4),
                          Text('$rating ($reviews reviews)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const Text(' • ', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                          Text('$exp yrs exp', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(distance, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Text(s, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: availableBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(available, style: TextStyle(fontSize: 10, color: availableCol, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {}, // Would navigate to profile details normally
                    style: OutlinedButton.styleFrom(side: BorderSide(color: outline), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('View Profile', style: TextStyle(color: Color(0xFF64748B))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pushNamed('customer-request'),
                    style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
