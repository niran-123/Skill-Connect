import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

class DocumentVerificationScreen extends StatelessWidget {
  const DocumentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: const Text('Verification & KYC', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF166534),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.shield_check, size: 32, color: Color(0xFF16A34A)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Level 2 Verified Professional', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('All mandatory government & trade verifications active. Re-check in 280 days.', style: TextStyle(color: Color(0xFFBBF7D0), fontSize: 13, height: 1.4), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
                    child: const Text('100% Compliance Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Required Documents
                  const Text('Mandatory Verifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _buildDocItem(
                    title: 'Government ID: Aadhaar Card',
                    details: 'Document Number: XXXX-XXXX-9412\nUploaded: 14 Jan 2024',
                    status: 'Biometric & OTP Authenticated',
                    actionText: 'View Uploaded Document',
                    icon: LucideIcons.eye,
                  ),
                  _buildDocItem(
                    title: 'Trade Qualification: NTC (ITI Electrician)',
                    details: 'Certificate No: NTC-TN-2018-84291\nVerified by SkillConnect Trade Panel (Grade A+)',
                    status: 'Verified Certificate',
                    actionText: 'View Certificate',
                    icon: LucideIcons.file_text,
                  ),
                  _buildDocItem(
                    title: 'Police Clearance Certificate (PCC)',
                    details: 'Issued: Trichy City Police Dept',
                    status: 'Clean Record (No pending complaints)',
                    actionText: 'Renew or Replace',
                    icon: LucideIcons.refresh_cw,
                  ),
                  _buildDocItem(
                    title: 'Bank Account & UPI VPA',
                    details: 'HDFC Bank •••• 4912\narun.electrician@okhdfcbank',
                    status: 'Active for Instant Payouts (Penny drop passed)',
                    actionText: 'Manage Accounts',
                    icon: LucideIcons.settings,
                  ),

                  const SizedBox(height: 24),
                  
                  // Optional Certifications
                  const Text('Optional Additional Certifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        _buildOptionalItem('SkillConnect Advanced Safety Protocol Badge', 'Available to take test', LucideIcons.file),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildOptionalItem('Commercial High-Voltage Certificate', 'Upload Document +', LucideIcons.cloud_upload, isAction: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Security Notice
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(LucideIcons.lock, size: 16, color: Color(0xFF64748B)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Documents are encrypted with 256-bit AES storage compliant with Digital Personal Data Protection Act.',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 12, height: 1.4),
                        ),
                      ),
                    ],
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
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0F172A),
            side: const BorderSide(color: Color(0xFFCBD5E1)),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Request Re-verification or Update ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ),
      ),
    );
  }

  Widget _buildDocItem({required String title, required String details, required String status, required String actionText, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A)))),
              const Icon(LucideIcons.badge_check, color: Color(0xFF10B981), size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(details, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 14, color: Color(0xFF16A34A)),
                const SizedBox(width: 6),
                Expanded(child: Text(status, style: const TextStyle(color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF1F5F9))),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(icon, size: 16),
            label: Text(actionText),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1D4ED8),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalItem(String title, String subtitle, IconData icon, {bool isAction = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: Icon(LucideIcons.award, size: 20, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: isAction ? const Color(0xFF1D4ED8) : const Color(0xFF64748B), fontSize: 13, fontWeight: isAction ? FontWeight.w500 : FontWeight.w400)),
              ],
            ),
          ),
          if (isAction) Icon(icon, color: const Color(0xFF1D4ED8), size: 18),
        ],
      ),
    );
  }
}
