import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final Color onSurface = const Color(0xFF0F172A);
    final Color surface = const Color(0xFFF7F9FB);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF475569),
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color onSurface = const Color(0xFF0F172A);
    final Color surface = const Color(0xFFF7F9FB);
    final Color primary = const Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.support_agent, size: 48, color: primary),
                const SizedBox(height: 16),
                Text('How can we help you?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
                const SizedBox(height: 8),
                Text(
                  'Our support team is available 24/7 to assist you with any issues related to bookings, professionals, or your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: const Color(0xFF64748B), height: 1.5),
                ),
                const SizedBox(height: 24),
                _buildContactCard(Icons.email_outlined, 'Email Support', 'support@skillconnect.com', primary),
                const SizedBox(height: 12),
                _buildContactCard(Icons.phone_outlined, 'Call Support', '+91 9876543210', primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
