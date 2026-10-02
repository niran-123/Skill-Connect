import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class NoProsAvailableScreen extends StatelessWidget {
  const NoProsAvailableScreen({super.key});

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
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: const [
              Icon(LucideIcons.search, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Expanded(child: Text('Emergency Gas Pipe Repair • Thillai Nagar', style: TextStyle(fontSize: 13, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
              Icon(LucideIcons.x, size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Hero Visual
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(color: const Color(0xFFDBEAFE).withValues(alpha: 0.5), shape: BoxShape.circle),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(LucideIcons.search_x, size: 48, color: Color(0xFF1D4ED8)),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFCA5A5))),
                      child: Row(
                        children: const [
                          Icon(LucideIcons.info, size: 12, color: Color(0xFFDC2626)),
                          SizedBox(width: 4),
                          Text('0 Active Pros in 15 km', style: TextStyle(color: Color(0xFF991B1B), fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('No Trade Specialists Available Nearby', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('All certified gas and pipeline specialists in Thillai Nagar are currently engaged on active jobs or outside operating hours.', style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4), textAlign: TextAlign.center),
            const SizedBox(height: 32),

            // Solution 1: Expand Radius
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expand Search Radius', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)), child: const Text('+3 pros in 45 mins', style: TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w600))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Search up to 25 km (Cantonment, KK Nagar, Srirangam)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  Slider(value: 25, min: 15, max: 50, activeColor: const Color(0xFF1D4ED8), inactiveColor: const Color(0xFFE2E8F0), onChanged: (v) {}),
                ],
              ),
            ),

            // Solution 2: Schedule
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Schedule for Later / Tomorrow', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(LucideIcons.calendar_clock, size: 16, color: Color(0xFF64748B)),
                      SizedBox(width: 8),
                      Expanded(child: Text('First available slot: Tomorrow, 8:30 AM with Vijay Kumar (★4.8)', style: TextStyle(color: Color(0xFF475569), fontSize: 13))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                    child: const Text('Pre-Book Slot', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // Solution 3: Notify Me
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Notify Me When a Pro Goes Online', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                        SizedBox(height: 4),
                        Text('Instant ping via WhatsApp or SMS as soon as a technician opens their dispatch radar.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(value: false, onChanged: (v) {}, activeThumbColor: Colors.white, activeTrackColor: const Color(0xFF1D4ED8)),
                ],
              ),
            ),

            // Emergency Hotline
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFCA5A5))),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle), child: const Icon(LucideIcons.phone_call, color: Colors.white, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Need Immediate Urgent Dispatch?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF991B1B))),
                        SizedBox(height: 4),
                        Text('Call SkillConnect Emergency Dispatch Helpline 1800-SKILL (Toll-Free 24/7)', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {},
              child: const Text('Modify Search Category', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
