import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class OfflineModeScreen extends StatelessWidget {
  const OfflineModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top status pill
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.wifi_off, size: 14, color: Color(0xFF94A3B8)),
                      SizedBox(width: 8),
                      Text('Offline Mode • Local Cache Active', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              
              // Hero
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 8),
                ),
                child: Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.cloud_off, size: 40, color: Color(0xFF64748B)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('You\'re Currently Offline', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              const SizedBox(height: 12),
              const Text('SkillConnect couldn\'t establish a secure connection to the live dispatch network. Don\'t worry—your active booking details and emergency contacts are saved locally on this device.', style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5), textAlign: TextAlign.center),
              
              const SizedBox(height: 32),

              // Cached Data
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cached Active Job Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    const Text('#BK-78210: Kitchen Sink Pipe Leakage', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8), fontSize: 14)),
                    const SizedBox(height: 8),
                    const Text('Assigned Pro: Vijay Kumar (Master Plumber)', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                    const SizedBox(height: 8),
                    const Text('Service Address: 42, West Boulevard Rd, Thillai Nagar', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                      child: const Text('Technician OTP: Code 7419 (Ready for verification)', style: TextStyle(color: Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.phone),
                      label: const Text('Call Technician via GSM Call'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Troubleshooting
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('1. Check your Wi-Fi or cellular network settings', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    SizedBox(height: 6),
                    Text('2. Turn Airplane mode ON and OFF', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
              ),

              const Spacer(flex: 2),
              
              // Actions
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.refresh_cw),
                label: const Text('Retry Connection', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text('View Offline Cached Bookings', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
