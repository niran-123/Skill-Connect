import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    final jobProvider = context.watch<JobProvider>();
    final user = session.userModel;
    
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
        title: Text('My Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200, 
                        radius: 40, 
                        backgroundImage: user?.avatarThumb != null 
                            ? NetworkImage(user!.avatarThumb!) as ImageProvider
                            : const NetworkImage('https://via.placeholder.com/150'),
                      ),
                      Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: outline)), child: Icon(Icons.edit, color: primary, size: 14))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'Rahul Kumar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SkillConnect Member since Sep 2023 • Verified', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Color(0xFF10B981), size: 12),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(user?.email ?? 'rahul.kumar@example.com', style: TextStyle(fontSize: 12, color: onSurface)),
                  const SizedBox(height: 2),
                  Text(user?.phone ?? 'Add your mobile number', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text(user?.fullAddress?.isNotEmpty == true ? user!.fullAddress! : (user?.address ?? 'Add your address'), style: TextStyle(fontSize: 12, color: onSurfaceVariant), textAlign: TextAlign.center,),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.pushNamed('customer-profile-edit'),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: Text('Edit Profile', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Stats
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('${jobProvider.customerBookings.length}', 'Total Bookings'),
                  _buildStat('${user?.savedProfessionalIds.length ?? 0}', 'Saved Pros'),
                  _buildStat('${jobProvider.customerBookings.where((b) => b.status == 'completed').length}', 'Reviews Given'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            // Quick Shortcut
            if (session.userModel != null)
              Consumer<JobProvider>(
                builder: (context, jobProvider, child) {
                  final active = jobProvider.customerBookings.where((b) => b.status == 'in_progress' || b.status == 'arrived' || b.status == 'accepted').toList();
                  if (active.isEmpty) return const SizedBox.shrink();
                  final b = active.first;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFBFDBFE))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Active Booking in Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                              const SizedBox(height: 4),
                              Text('${b.professionalName} is ${b.status}', style: TextStyle(fontSize: 11, color: const Color(0xFF1D4ED8).withValues(alpha: 0.8))),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.pushNamed('customer-booking-details', pathParameters: {'id': b.id}),
                          style: ElevatedButton.styleFrom(backgroundColor: primary, minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: const Text('Track →', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            
            _buildSection(
              'Manage Services',
              [
                _buildListTile(Icons.calendar_month, 'My Bookings', 'Active, upcoming, and past services', trailingWidget: _buildBadge('${jobProvider.customerBookings.where((b) => b.status == 'in_progress' || b.status == 'accepted').length} Active', const Color(0xFFDBEAFE), primary), onTap: () => context.goNamed('customer-bookings')),
                _buildListTile(Icons.favorite, 'Saved Professionals', 'Your favorite certified tradespeople', trailingWidget: _buildBadge('${user?.savedProfessionalIds.length ?? 0} saved', const Color(0xFFF1F5F9), onSurfaceVariant), onTap: () => context.pushNamed('customer-saved-pros')),
                _buildListTile(Icons.location_on, 'Service Addresses', 'Primary: ${user?.address ?? 'Not set'}', onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),

            
            _buildSection(
              'Trust & Legal',
              [
                _buildListTile(Icons.help_outline, 'Help & Support', 'support@skillconnect.com | +91 9876543210', onTap: () => context.pushNamed('help')),
                _buildListTile(Icons.description, 'Terms of Service', 'Read our detailed terms of usage', onTap: () => context.pushNamed('terms')),
                _buildListTile(Icons.privacy_tip_outlined, 'Privacy Policy', 'How we protect your data', onTap: () => context.pushNamed('privacy')),
                _buildListTile(Icons.question_answer_outlined, 'FAQ', 'Frequently asked questions', onTap: () => context.pushNamed('faq')),
              ],
            ),
            const SizedBox(height: 24),
            
            Container(
              color: Colors.white,
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                    title: const Text('Log Out', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w500)),
                    onTap: () async {
                      await context.read<AuthProvider>().signOut();
                      if (context.mounted) {
                        context.goNamed('login');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(child: Text('SkillConnect v1.4.2 (College Project Build)', style: TextStyle(fontSize: 10, color: outline))),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
        Container(
          color: Colors.white,
          child: Column(
            children: children.expand((w) => [w, const Divider(height: 1)]).toList()..removeLast(),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, String? subtitle, {Widget? trailingWidget, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFF0F172A), size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingWidget != null) ...[trailingWidget, const SizedBox(width: 8)],
          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildBadge(String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 10, color: textCol, fontWeight: FontWeight.bold)),
    );
  }
}
