import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ProAvailabilityCalendarScreen extends StatelessWidget {
  const ProAvailabilityCalendarScreen({super.key});

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
        title: const Text('Availability & Hours', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Master toggle
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Accepting Instant Bookings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.3), shape: BoxShape.circle)),
                                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                              ],
                            ),
                            const SizedBox(width: 6),
                            const Text('Online & Open for Direct Requests', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Switch(value: true, onChanged: (v) {}, activeThumbColor: Colors.white, activeTrackColor: const Color(0xFF1D4ED8)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            
            // Weekly Schedule Matrix
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildDayTab('Mon'), _buildDayTab('Tue'), _buildDayTab('Wed'), _buildDayTab('Thu'),
                    _buildDayTab('Fri'), _buildDayTab('Sat', isActive: true), _buildDayTab('Sun'),
                  ],
                ),
              ),
            ),

            // Daily hours & Day Status
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Working on Saturdays', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                            Switch(value: true, onChanged: (v) {}, activeThumbColor: Colors.white, activeTrackColor: const Color(0xFF10B981)),
                          ],
                        ),
                        const Divider(height: 32, color: Color(0xFFE2E8F0)),
                        _buildTimeRow('Active Working Window', '08:00 AM', '07:00 PM'),
                        const SizedBox(height: 16),
                        _buildTimeRow('Break / Lunch Slot', '01:00 PM', '02:00 PM'),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F172A),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Apply this schedule to all weekdays (Mon-Fri)'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Time Slots Allocation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saturday Time Slots', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                        const SizedBox(height: 16),
                        _buildSlot('08:30 AM - 10:30 AM', 'Booked: #BK-78190 - Domestic wiring check', isBooked: true),
                        _buildSlot('11:00 AM - 01:00 PM', 'Available - Instant dispatch ready', isAvailable: true),
                        _buildSlot('01:00 PM - 02:00 PM', 'Break / Offline', isBreak: true),
                        _buildSlot('02:30 PM - 04:30 PM', 'Booked: #BK-78210 - Fan regulator fix', isBooked: true),
                        _buildSlot('05:00 PM - 07:00 PM', 'Available - Evening slot', isAvailable: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Vacations
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: const Icon(LucideIcons.calendar_off, color: Color(0xFF64748B))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Set Vacation Dates', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                              Text('Pause Dispatch', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevron_right, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Max limit
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Maximum Daily Jobs Limit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                            Text('4 Jobs', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8), fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Prevents overbooking on busy days.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        const SizedBox(height: 12),
                        Slider(value: 4, min: 1, max: 10, divisions: 9, activeColor: const Color(0xFF1D4ED8), inactiveColor: const Color(0xFFE2E8F0), onChanged: (v) {}),
                      ],
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
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(LucideIcons.check),
          label: const Text('Save Availability Changes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildDayTab(String day, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D4ED8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0)),
      ),
      child: Text(day, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  Widget _buildTimeRow(String label, String start, String end) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF475569), fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(start, style: const TextStyle(fontWeight: FontWeight.w500)), const Icon(LucideIcons.clock, size: 16, color: Color(0xFF94A3B8))]),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('to', style: TextStyle(color: Color(0xFF94A3B8)))),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(end, style: const TextStyle(fontWeight: FontWeight.w500)), const Icon(LucideIcons.clock, size: 16, color: Color(0xFF94A3B8))]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlot(String time, String label, {bool isBooked = false, bool isAvailable = false, bool isBreak = false}) {
    Color bgColor = const Color(0xFFF1F5F9);
    Color borderColor = const Color(0xFFE2E8F0);
    Color textColor = const Color(0xFF64748B);
    
    if (isBooked) {
      bgColor = const Color(0xFFDBEAFE);
      borderColor = const Color(0xFFBFDBFE);
      textColor = const Color(0xFF1E3A8A);
    } else if (isAvailable) {
      bgColor = Colors.white;
      borderColor = const Color(0xFF86EFAC); // green border
      textColor = const Color(0xFF166534);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isAvailable ? const Color(0xFF166534) : const Color(0xFF0F172A))),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 13)),
        ],
      ),
    );
  }
}
