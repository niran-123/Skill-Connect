import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/booking.dart';

class BookingSentScreen extends StatelessWidget {
  final BookingModel booking;
  const BookingSentScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    final Color outline = const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check_circle, color: Color(0xFF10B981), size: 64),
                ),
              ),
              const SizedBox(height: 24),
              
              Text('Booking Request Sent!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface)),
              const SizedBox(height: 12),
              Text(
                'Your service request has been transmitted directly to ${booking.professionalName}. You\'ll receive a response within 10 minutes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 24),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 16, color: Color(0xFFD97706)),
                    SizedBox(width: 8),
                    Text('Status: Pending Professional Acceptance', style: TextStyle(fontSize: 12, color: Color(0xFFB45309), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: outline.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Booking ID', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                        Text('#${booking.id.substring(0, 8)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: onSurface)),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildRow('Service', booking.jobSnapshot['categoryChosen'] ?? 'Service', onSurface, onSurfaceVariant),
                    const SizedBox(height: 8),
                    _buildRow('Professional', booking.professionalName, onSurface, onSurfaceVariant),
                    const SizedBox(height: 8),
                    _buildRow('Date & Time', '${booking.scheduledDate ?? 'Anytime'} • ${booking.timeSlot ?? 'Anytime'}', onSurface, onSurfaceVariant),
                    const SizedBox(height: 8),
                    _buildRow('Status', 'Pending', onSurface, onSurfaceVariant),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Buttons

              ElevatedButton(
                onPressed: () => context.goNamed('customer-bookings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Go to My Bookings', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.goNamed('customer-home'),
                child: Text('Back to Home', style: TextStyle(color: onSurfaceVariant)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color textCol, Color labelCol) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(label, style: TextStyle(fontSize: 12, color: labelCol))),
        Expanded(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textCol), textAlign: TextAlign.right)),
      ],
    );
  }
}
