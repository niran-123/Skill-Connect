import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class MediaUploadRetryScreen extends StatelessWidget {
  const MediaUploadRetryScreen({super.key});

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
        title: const Text('Media & Diagnosis', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step tracker
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: const Text('Step 2 of 4: Problem Diagnosis & Media', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Hero Error Alert Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFCA5A5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.info, size: 20, color: Color(0xFFDC2626)),
                      const SizedBox(width: 8),
                      const Text('Upload Interrupted • 1 of 2 Photos Failed', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF991B1B), fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Could Not Upload "switchboard_damage.heic"', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  const Text('Connection timed out while analyzing image with SkillConnect AI Engine', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 13)),
                ],
              ),
            ),

            // File Status Gallery
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Failed Item
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEF4444), width: 1.5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(LucideIcons.image_off, color: Color(0xFFEF4444)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('switchboard_damage.heic (8.4 MB)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 4),
                              const Text('File size exceeds 5MB limit or network slow', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(LucideIcons.shrink, size: 14),
                                    label: const Text('Compress & Retry', style: TextStyle(fontSize: 12)),
                                    style: TextButton.styleFrom(foregroundColor: const Color(0xFF1D4ED8), padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  ),
                                  const SizedBox(width: 16),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(LucideIcons.trash, size: 14),
                                    label: const Text('Remove File', style: TextStyle(fontSize: 12)),
                                    style: TextButton.styleFrom(foregroundColor: const Color(0xFF64748B), padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Success Item
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF86EFAC))),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(LucideIcons.image, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('u_trap_leak.jpg (1.8 MB)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(Icons.check_circle, size: 12, color: Color(0xFF16A34A)),
                                  SizedBox(width: 4),
                                  Expanded(child: Text('Uploaded & AI Diagnostics matched (PVC Drainage)', style: TextStyle(color: Color(0xFF166534), fontSize: 11))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fix Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How would you like to proceed?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _buildOption(LucideIcons.minimize, 'Auto-Compress & Retry', 'Downsamples image to 1080p (<1.5MB) for quick upload.'),
                  _buildOption(LucideIcons.camera, 'Take a Fresh Photo', 'Use built-in flash & guidance frame for best results.'),
                  _buildOption(LucideIcons.mic, 'Skip Photo & Describe', 'Proceed by giving a 20-word voice/text description instead.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tips
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tips for Clear Photos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  _buildTip('Ensure good lighting'),
                  _buildTip('Show both the defect and model label'),
                  _buildTip('Avoid extreme blurry close-ups'),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: const Text('Retry Failed Upload', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0F172A), side: const BorderSide(color: Color(0xFFCBD5E1)), minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Continue Without Failed Photo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF1D4ED8), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.check, size: 14, color: Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(child: Text(tip, style: const TextStyle(color: Color(0xFF475569), fontSize: 13))),
        ],
      ),
    );
  }
}
