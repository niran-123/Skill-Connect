import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class DescribeProblemScreen extends StatelessWidget {
  const DescribeProblemScreen({super.key});

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe Your Problem',
              style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              'Step 1 of 2: AI Diagnostic',
              style: TextStyle(color: const Color(0xFF1D4ED8).withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Speak or write freely. Our AI identifies the right trade skills and matches proven specialists.',
                      style: TextStyle(color: const Color(0xFF92400E).withValues(alpha: 0.9), fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Service Category
            const Text('Service Category', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: 'Select your category',
                  icon: const Icon(LucideIcons.chevron_down, color: Color(0xFF64748B)),
                  items: ['Select your category', 'Auto Detect', 'Plumbing & Pipe Repair', 'Electrician', 'Carpentry']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 15))))
                      .toList(),
                  onChanged: (v) {},
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Specific Skill
            const Text('Specific Skill (Optional)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'e.g. Leak Detection, Tap Replacement',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
            const SizedBox(height: 20),

            // Problem Description
            const Text('Describe Problem', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
            const SizedBox(height: 8),
            Stack(
              children: [
                TextFormField(
                  initialValue: 'Kitchen sink pipe is leaking under the basin cabinet whenever the tap is turned on. Water is pooling on the wooden floor and seems to come from the U-trap joint.',
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.mic, size: 16, color: Color(0xFF1D4ED8)),
                    label: const Text('Tap to Speak', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w500)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFF1D4ED8)),
                      ),
                      backgroundColor: const Color(0xFFDBEAFE),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 16,
                  right: 16,
                  child: Text('168 / 500', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Media Attachment
            const Text('Add Photos or Video (Helps accurate AI diagnosis)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                // Uploaded thumbnail
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/80x80.png?text=Sink'), // Placeholder for sink_leak.jpg
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                        child: const Icon(LucideIcons.x, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Add button
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid), // Dashed in UI, using solid for flutter simple
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.camera, color: Color(0xFF1D4ED8), size: 24),
                      SizedBox(height: 4),
                      Text('Add', style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Preferred Date & Time
            const Text('Preferred Date & Time', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      children: const [
                        Icon(LucideIcons.calendar, size: 18, color: Color(0xFF64748B)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Today, 24 Oct', style: TextStyle(fontSize: 14, color: Color(0xFF0F172A)))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      children: const [
                        Icon(LucideIcons.clock, size: 18, color: Color(0xFF64748B)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Evening (4 PM - 7 PM)', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Color(0xFF0F172A)))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Service Location
            const Text('Service Location', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Text('📍', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('42, West Boulevard Rd, Thillai Nagar, Trichy', style: TextStyle(fontSize: 14, color: Color(0xFF0F172A))),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: const Text('Change', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Additional Notes
            const Text('Additional Notes', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'e.g. Guard at gate, call before arriving',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
            const SizedBox(height: 32),

            // Primary CTA
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Analyze Problem with AI ✨', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Analyzing state banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1D4ED8))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Analyzing your problem...', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E40AF), fontSize: 13)),
                        Text('Analyzing problem severity & matching required skills...', style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
