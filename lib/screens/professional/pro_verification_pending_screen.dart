import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ProVerificationPendingScreen extends StatelessWidget {
  const ProVerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Account Verification', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            // Header Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(40)),
                    child: const Icon(LucideIcons.user, size: 40, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Arun Kumar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  const Text('Master Electrician • Partner Application #TN-8921', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFFDE68A))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(LucideIcons.hourglass, size: 14, color: Color(0xFFD97706)),
                        SizedBox(width: 8),
                        Text('Under Review • Typically takes 2-4 hours', style: TextStyle(color: Color(0xFFB45309), fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Milestone Tracker
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verification Progress', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 16),
                  _buildMilestone(true, 'Application & Profile Submitted', 'Completed Today, 10:15 AM', isLastCompleted: false),
                  _buildMilestone(true, 'Government ID (Aadhaar/PAN)', 'DigiLocker check passed', isLastCompleted: true),
                  _buildMilestone(false, 'Trade Certificate & Experience Audit', 'Expert trade board reviewing ITI credentials', isCurrent: true),
                  _buildMilestone(false, 'Police Background Verification', 'City jurisdiction check underway'),
                  _buildMilestone(false, 'Dispatch Radar Activation', 'Account ready to receive leads', isFinal: true),
                ],
              ),
            ),

            // What Can You Do
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What Can You Do While Waiting?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _buildEngagementCard(
                    LucideIcons.graduation_cap,
                    'Complete Onboarding Academy (10 mins)',
                    'Watch 3 quick video modules on SkillConnect customer etiquette, safety protocols, and surge pricing.',
                    '+15% match priority on launch',
                  ),
                  _buildEngagementCard(
                    LucideIcons.settings,
                    'Configure Your Availability & Service Rates',
                    'Pre-configure your calendar, hourly rates, and coverage radius so you hit the ground running.',
                    null,
                  ),
                  _buildEngagementCard(
                    LucideIcons.smartphone,
                    'Test Mock Booking Demo',
                    'Practice accepting a simulated emergency call.',
                    null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Support Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Need Urgent Fast-Track Review?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  const Text('If you have an active commercial trade license or trade association membership, contact our Pro Onboarding Desk via WhatsApp (+91 94421 99000) or phone.', style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.message_circle, size: 16),
                    label: const Text('Contact Support'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D4ED8),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh Verification Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0F172A), side: const BorderSide(color: Color(0xFFCBD5E1)), minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Edit Uploaded Documents', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestone(bool isCompleted, String title, String subtitle, {bool isCurrent = false, bool isFinal = false, bool isLastCompleted = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF10B981) : (isCurrent ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? const Icon(LucideIcons.check, size: 12, color: Colors.white)
                      : (isCurrent ? const Icon(LucideIcons.loader, size: 12, color: Colors.white) : null),
                ),
                if (!isFinal)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted && !isLastCompleted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: isCompleted || isCurrent ? FontWeight.w600 : FontWeight.w500, fontSize: 14, color: isCompleted || isCurrent ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementCard(IconData icon, String title, String desc, String? reward) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFF1D4ED8), size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A)))),
            ],
          ),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
          if (reward != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.zap, size: 12, color: Color(0xFF16A34A)),
                  const SizedBox(width: 4),
                  Text('Unlocks: $reward', style: const TextStyle(color: Color(0xFF166534), fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
