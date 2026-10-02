import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? _selectedReason;

  final List<String> _reasons = [
    'Problem already resolved / Fixed myself',
    'Technician running late / Need service sooner',
    'Found alternative local professional',
    'Scheduled wrong date or time slot',
    'Change in personal schedule / Not at home',
    'Other reasons',
  ];

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
        title: const Text('Cancel Booking Request', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            // Booking Context Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('#BK-78210', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('Today, 3:30 PM (in 45 mins)', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Ceiling Fan Regulator Replacement', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(LucideIcons.user, size: 14, color: Color(0xFF64748B)),
                      SizedBox(width: 4),
                      Text('Arun Kumar (Master Electrician)', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Cancellation Policy
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBBF7D0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(LucideIcons.shield_check, color: Color(0xFF16A34A), size: 18),
                      SizedBox(width: 8),
                      Text('Free Cancellation Available', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF166534), fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Cancelling more than 30 minutes before the arrival window is 100% FREE. If cancelled after technician dispatch/arrival, a nominal ₹100 travel convenience fee applies to compensate the pro.', style: TextStyle(color: Color(0xFF166534), fontSize: 12, height: 1.4)),
                ],
              ),
            ),

            // Retention Alternative
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1D4ED8).withValues(alpha: 0.3)), boxShadow: [BoxShadow(color: const Color(0xFF1D4ED8).withValues(alpha: 0.05), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Wait! Would you rather Reschedule instead?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  const Text('Keep your assigned pro Arun Kumar and move your appointment to this evening (6:00 PM) or tomorrow without losing your slot.', style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.calendar),
                    label: const Text('Reschedule Appointment'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D4ED8),
                      side: const BorderSide(color: Color(0xFF1D4ED8)),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Questionnaire
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Please tell us why you are cancelling:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  ..._reasons.map((reason) => _buildReasonRadio(reason)),
                  if (_selectedReason == 'Other reasons')
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 32),
                      child: TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Help us improve our service...',
                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          filled: true, fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        ),
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
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: const Text('Keep Booking', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _selectedReason == null ? null : () {},
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626), minimumSize: const Size(double.infinity, 48)),
              child: const Text('Confirm Cancellation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonRadio(String reason) {
    bool isSelected = _selectedReason == reason;
    return InkWell(
      onTap: () => setState(() => _selectedReason = reason),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF94A3B8), width: isSelected ? 6 : 1.5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(reason, style: TextStyle(fontSize: 14, color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569), fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400))),
          ],
        ),
      ),
    );
  }
}
