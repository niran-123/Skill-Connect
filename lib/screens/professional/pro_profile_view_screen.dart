import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class ProProfileViewScreen extends StatelessWidget {
  const ProProfileViewScreen({super.key});

  List<String> _getSubServices(String category) {
    if (category.contains('AC Technician')) return ['Split AC Installation', 'Window AC Service', 'Gas Refill', 'Compressor Repair'];
    if (category.contains('Plumber')) return ['Pipe Fitting', 'Leak Repair', 'Tank Cleaning', 'Tap & Shower Installation'];
    if (category.contains('Electrician')) return ['Wiring', 'Switchboard Repair', 'Fan Installation', 'Inverter Setup'];
    if (category.contains('Carpenter')) return ['Furniture Repair', 'Door/Window Fixing', 'Wood Polish', 'Modular Kitchen Setup'];
    if (category.contains('Painter')) return ['Interior Painting', 'Exterior Painting', 'Wall Putty', 'Texture Painting'];
    if (category.contains('Mason')) return ['Wall Construction', 'Floor Tiling', 'Plastering', 'Concrete Work'];
    if (category.contains('Welder')) return ['Arc Welding', 'Gate Repair', 'Grill Work', 'Fabrication'];
    if (category.contains('Two-Wheeler')) return ['General Service', 'Engine Work', 'Tyre Puncture', 'Oil Change'];
    if (category.contains('Car Mechanic')) return ['Engine Diagnostics', 'Brake Service', 'AC Service', 'Battery Replacement'];
    if (category.contains('Cleaning')) return ['Deep Cleaning', 'Sofa Cleaning', 'Bathroom Cleaning', 'Floor Scrubbing'];
    if (category.contains('Appliance')) return ['Washing Machine', 'Refrigerator', 'Microwave Repair', 'Water Heater'];
    if (category.contains('Locksmith')) return ['Door Lock Opening', 'Key Duplication', 'Digital Lock Setup', 'Safe Unlocking'];
    if (category.contains('Mobile Phone')) return ['Screen Replacement', 'Battery Change', 'Software Flashing', 'Water Damage Repair'];
    if (category.contains('Roofing')) return ['Waterproofing', 'Leak Fixing', 'Tile Roofing', 'Sheet Roofing'];
    if (category.contains('Gardener')) return ['Lawn Mowing', 'Plant Pruning', 'Landscaping', 'Pest Control'];
    if (category.contains('Car/Bike Washing')) return ['Foam Wash', 'Interior Vacuum', 'Polishing', 'Detailing'];
    if (category.contains('Glass & Aluminium')) return ['Window Partition', 'Door Installation', 'Glass Replacement', 'Sliding Windows'];
    if (category.contains('Furniture Repair')) return ['Sofa Repair', 'Chair Fixing', 'Bed Assembly', 'Upholstery Change'];
    if (category.contains('RO Water')) return ['Filter Change', 'Machine Installation', 'Pump Repair', 'AMC Service'];
    if (category.contains('TV & Electronics')) return ['LED TV Repair', 'Home Theater Setup', 'PCB Repair', 'Display Issue'];
    return ['General Service', 'Maintenance', 'Inspection', 'Consultation'];
  }

  @override
  Widget build(BuildContext context) {
    final proProvider = context.watch<ProfessionalProvider>();
    final pro = proProvider.professional;
    final name = pro?.name ?? 'Professional Name';
    final category = pro?.category ?? 'Service Expert';
    final location = '${pro?.area ?? 'Area'}, ${pro?.city ?? 'City'}';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 20)),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Pro Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(40)),
                    child: Icon(LucideIcons.user, size: 40, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text(category, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text('$location • 15 km radius', style: const TextStyle(color: Color(0xFF475569), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => context.pushNamed('edit-pro-profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D4ED8),
                      side: const BorderSide(color: Color(0xFF1D4ED8)),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Public Trust & Stats Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                children: [
                  _buildStatCol('★ 5.0', '${proProvider.bookings.where((b) => b.status == 'completed').length} reviews', const Color(0xFFF59E0B)),
                  _buildDivider(),
                  _buildStatCol('${pro?.experienceYears ?? '0'} Yrs', 'Experience', const Color(0xFF0F172A)),
                  _buildDivider(),
                  _buildStatCol('${proProvider.bookings.where((b) => b.status == 'completed').length}', 'Jobs Done', const Color(0xFF0F172A)),
                  _buildDivider(),
                  _buildStatCol('100%', 'On-Time', const Color(0xFF10B981)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Work Capabilities
            _buildSection(
              title: 'Services & Capabilities',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _getSubServices(category).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
                        child: Text(s, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
                      )).toList(),
                  ),
                ],
              ),
            ),

            // Service Radius & Hours
            _buildSection(
              title: 'Operating Info',
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.navigation, size: 18, color: Color(0xFF64748B)),
                      SizedBox(width: 12),
                      Expanded(child: Text('15 km around $location', style: TextStyle(color: Color(0xFF0F172A), fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(LucideIcons.clock, size: 18, color: Color(0xFF64748B)),
                      SizedBox(width: 12),
                      Expanded(child: Text('Mon - Sat • ${pro?.schedule['availableFrom'] ?? '08:00'} - ${pro?.schedule['availableTo'] ?? '17:00'}', style: TextStyle(color: Color(0xFF0F172A), fontSize: 14))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                final authProvider = context.read<AuthProvider>();
                await authProvider.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: const Text('Log Out', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(String top, String bottom, Color topColor) {
    return Expanded(
      child: Column(
        children: [
          Text(top, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: topColor)),
          const SizedBox(height: 4),
          Text(bottom, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: const Color(0xFFE2E8F0));
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
