import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ProNotificationsScreen extends StatelessWidget {
  const ProNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Pro Notifications', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 20)),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.bell_off, size: 48, color: const Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            const Text('No new notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text('You\'re all caught up!', style: TextStyle(color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

}
