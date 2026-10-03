import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/job_provider.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String id;
  const BookingDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<JobProvider>().customerBookings;
    final booking = bookings.firstWhere((b) => b.id == id, orElse: () => bookings.first);
    
    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    final Color outline = const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Booking Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.share, color: onSurface), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: booking.status == 'completed' ? const Color(0xFF10B981) : primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(booking.status == 'completed' ? Icons.check_circle : Icons.info, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Job \${booking.status.toUpperCase()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            
            // Professional Contact Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(backgroundColor: Colors.grey.shade200, radius: 24, backgroundImage: NetworkImage(booking.professionalThumb ?? 'https://via.placeholder.com/150')),
                          Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.verified, color: Color(0xFF10B981), size: 12))),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.professionalName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                            Text('Professional', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (booking.status != 'completed' && booking.status != 'cancelled')
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              // We'll use a dummy number for the professional if none exists in the model
                              final Uri telUri = Uri.parse('tel:+919876543210');
                              if (await canLaunchUrl(telUri)) {
                                await launchUrl(telUri);
                              }
                            },
                            icon: Icon(Icons.phone, size: 16, color: primary),
                            label: Text('Call', style: TextStyle(fontSize: 12, color: primary)),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final Uri smsUri = Uri.parse('sms:+919876543210');
                              if (await canLaunchUrl(smsUri)) {
                                await launchUrl(smsUri);
                              }
                            },
                            icon: Icon(Icons.chat_bubble_outline, size: 16, color: primary),
                            label: Text('Message', style: TextStyle(fontSize: 12, color: primary)),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Live Timeline Tracker
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Tracker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 16),
                  _buildTimelineStep(true, booking.status == 'pending', 'Request Created', 'Pending'),
                  _buildTimelineStep(booking.status != 'pending', booking.status == 'accepted', 'Professional Accepted', 'Accepted'),
                  _buildTimelineStep(booking.status == 'arrived' || booking.status == 'ready_to_start' || booking.status == 'in_progress' || booking.status == 'completed', booking.status == 'arrived', 'Professional Arrived', 'On-site'),
                  _buildTimelineStep(booking.status == 'ready_to_start' || booking.status == 'in_progress' || booking.status == 'completed', booking.status == 'ready_to_start', 'Customer Confirmed', 'Ready'),
                  _buildTimelineStep(booking.status == 'in_progress' || booking.status == 'completed', booking.status == 'in_progress', 'Job Started', 'Working'),
                  _buildTimelineStep(booking.status == 'completed', booking.status == 'completed', 'Job Completed', 'Finished', isLast: true),
                ],
              ),
            ),

            // Service Info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 16),
                  _buildInfoRow('Category', booking.jobSnapshot['analysis']?['category'] ?? 'Service', onSurface, onSurfaceVariant),
                  const SizedBox(height: 12),
                  _buildInfoRow('Identified Issue', booking.jobSnapshot['analysis']?['problemType'] ?? 'Unknown Issue', onSurface, onSurfaceVariant),
                  const SizedBox(height: 12),
                  _buildInfoRow('Date & Time', booking.scheduledDate != null ? '${booking.scheduledDate} • ${booking.timeSlot ?? ''}' : 'Requested Recently', onSurface, onSurfaceVariant),
                  const SizedBox(height: 12),
                  _buildInfoRow('Description', booking.jobSnapshot['description'] ?? 'No Description', onSurface, onSurfaceVariant),
                ],
              ),
            ),
            
            // Payment Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment & Estimate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 16),
                  _buildInfoRow('Estimate', booking.estimatedCharge != null ? '₹\${booking.estimatedCharge!.toStringAsFixed(0)}' : 'TBD', onSurface, onSurfaceVariant),
                  const SizedBox(height: 8),
                  _buildInfoRow('Method', 'Cash on Completion', onSurface, onSurfaceVariant),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.shield, color: Color(0xFF10B981), size: 16),
                      const SizedBox(width: 8),
                      Text('SkillConnect Guarantee: Verified trade quality', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (booking.status == 'completed' && booking.reviewed != true)
                ElevatedButton(
                  onPressed: () => context.pushNamed('customer-review', pathParameters: {'id': booking.id}, extra: booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Leave Review', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              if (booking.status == 'pending')
                TextButton(
                  onPressed: () async {
                    try {
                      await context.read<JobProvider>().updateBookingStatus(booking.id, 'cancelled', booking.customerId, isCustomer: true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Cancelled')));
                        context.pop();
                      }
                    } catch (e) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to cancel')));
                    }
                  },
                  child: const Text('Cancel Request', style: TextStyle(color: Colors.red)),
                ),
              if (booking.status == 'arrived')
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await context.read<JobProvider>().updateBookingStatus(booking.id, 'ready_to_start', booking.customerId, isCustomer: true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Confirmed! Job can now start.')));
                      }
                    } catch (e) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to confirm')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm to Start Job', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              if (booking.status == 'in_progress')
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await context.read<JobProvider>().updateBookingStatus(booking.id, 'completed', booking.customerId, isCustomer: true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job Completed Successfully')));
                      }
                    } catch (e) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to complete job')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Job Completed', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(bool completed, bool active, String title, String subtitle, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: completed ? const Color(0xFF1D4ED8) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: completed ? const Color(0xFF1D4ED8) : const Color(0xFFCBD5E1), width: 2),
              ),
              child: completed ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: completed ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: active ? FontWeight.bold : FontWeight.w600, color: active ? const Color(0xFF1D4ED8) : const Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: const Color(0xFF64748B))),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, Color textCol, Color labelCol) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: TextStyle(fontSize: 12, color: labelCol))),
        Expanded(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textCol))),
      ],
    );
  }
}
