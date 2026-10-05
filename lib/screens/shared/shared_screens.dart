import 'package:flutter/material.dart';
import 'faq_screen.dart';
import 'legal_screen.dart';

// HelpSupportScreen is defined in legal_screen.dart
export 'legal_screen.dart' show HelpSupportScreen;

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});
  @override Widget build(BuildContext context) => const FAQScreen();
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override Widget build(BuildContext context) => const LegalScreen(
    title: 'Terms of Service',
    content: 'Welcome to SkillConnect!\n\n1. Acceptance of Terms\nBy accessing and using this app, you accept and agree to be bound by the terms and provision of this agreement.\n\n2. Service Provision\nSkillConnect acts as a marketplace to connect customers with trade professionals. We do not directly employ the professionals.\n\n3. Payments\nAll payments must be made through the platform. Cash payments are outside the scope of our protection.\n\n4. Liability\nSkillConnect is not liable for any damages that occur during the service provision, but we provide a dispute resolution center.',
  );
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override Widget build(BuildContext context) => const LegalScreen(
    title: 'Privacy Policy',
    content: 'SkillConnect Privacy Policy\n\n1. Information Collection\nWe collect personal information such as name, phone number, and location to provide you with local matches.\n\n2. Use of Information\nYour data is only shared with verified professionals when you explicitly book them.\n\n3. Data Security\nWe use industry-standard encryption to protect your data. We do not sell your personal data to third parties.\n\n4. Location Data\nLocation data is collected to match you with nearby professionals and track arrival times.',
  );
}

class NotificationDetailsScreen extends StatelessWidget {
  final String id;
  const NotificationDetailsScreen({super.key, required this.id});
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FB),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFDBEAFE), shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_active, color: Color(0xFF1D4ED8)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('New Update', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Text('#$id', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('This is a notification update regarding your account or booking. Please check your active bookings or profile for more details.',
                style: TextStyle(height: 1.5, color: Color(0xFF475569)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
