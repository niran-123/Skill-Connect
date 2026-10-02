import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/job_provider.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);
  final Color badgeBlue = const Color(0xFFDBEAFE);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().userModel;
    final firstName = user?.name.split(' ').first ?? 'Customer';
    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Elements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $firstName 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text('Trichy, Tamil Nadu', style: TextStyle(fontSize: 12, color: onSurfaceVariant, fontFamily: 'Inter')),
                          const SizedBox(width: 4),
                          Icon(Icons.edit, size: 12, color: primary),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 24),

              // Prominent CTA Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primary.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(color: primary.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: primary, size: 20),
                        const SizedBox(width: 8),
                        Text('Describe Your Problem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us in your own words — our AI diagnoses your issue and matches verified specialists',
                      style: TextStyle(fontSize: 13, color: onSurfaceVariant, height: 1.4, fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed('customer-request'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Describe Problem', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Consumer<JobProvider>(
                builder: (context, jobProvider, child) {
                  final active = jobProvider.customerBookings.where((b) => b.status == 'in_progress' || b.status == 'arrived' || b.status == 'accepted').toList();
                  if (active.isEmpty) return const SizedBox.shrink();
                  final b = active.first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent Bookings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: badgeBlue.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: badgeBlue),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.build_circle, color: primary, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Active: \${b.jobSnapshot['analysis']?['category'] ?? 'Service'}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: onSurface)),
                                  const SizedBox(height: 4),
                                  Text('\${b.professionalName} • \${b.status}', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.pushNamed('customer-booking-details', pathParameters: {'id': b.id}),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                              child: Text('Track →', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceChip(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () => context.pushNamed('customer-request', extra: label),
      child: Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: primary, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    )
    );
  }

}

