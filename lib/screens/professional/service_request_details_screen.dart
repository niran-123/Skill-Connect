import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/booking.dart';
import '../../providers/professional_provider.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final BookingModel booking;
  const ServiceRequestDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Request Details',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // 1. Customer Profile Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(28)),
                        child: const Icon(LucideIcons.user, size: 28, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.security, size: 14, color: Color(0xFF10B981)),
                                SizedBox(width: 4),
                                Text('Verified Customer', style: TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.w500)),
                                Text(' • Sep 2023', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking.address ?? 'Location not provided',
                          style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: booking.status == 'accepted' ? () async {
                            final Uri uri = Uri(scheme: 'tel', path: booking.customerPhone ?? '1234567890');
                            if (await canLaunchUrl(uri)) await launchUrl(uri);
                          } : null,
                          icon: const Icon(LucideIcons.phone, size: 16),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: booking.status == 'accepted' ? const Color(0xFF1D4ED8) : const Color(0xFFF1F5F9),
                            foregroundColor: booking.status == 'accepted' ? Colors.white : const Color(0xFF94A3B8),
                            disabledBackgroundColor: const Color(0xFFF1F5F9),
                            disabledForegroundColor: const Color(0xFF94A3B8),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: booking.status == 'accepted' ? () async {
                            final Uri uri = Uri(scheme: 'sms', path: booking.customerPhone ?? '1234567890');
                            if (await canLaunchUrl(uri)) await launchUrl(uri);
                          } : null,
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: booking.status == 'accepted' ? const Color(0xFF1D4ED8) : const Color(0xFFF1F5F9),
                            foregroundColor: booking.status == 'accepted' ? Colors.white : const Color(0xFF94A3B8),
                            disabledBackgroundColor: const Color(0xFFF1F5F9),
                            disabledForegroundColor: const Color(0xFF94A3B8),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (booking.status != 'accepted') ...[
                    const SizedBox(height: 8),
                    const Text('Contact available upon acceptance', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ]
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sections
            _buildSection(
              title: 'Job Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.jobSnapshot['analysis']?['problemType'] ?? 'Service Request', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Text(
                    booking.jobSnapshot['description'] ?? 'No description provided.',
                    style: const TextStyle(color: Color(0xFF475569), fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  const Text('Customer Photos (2)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.image, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.image, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _buildSection(
              title: 'Scheduling & Location',
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.edit_calendar, size: 18, color: Color(0xFF64748B)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\${booking.scheduledDate ?? 'Date not set'} • \${booking.timeSlot ?? 'Time not set'}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                            const Text('Window confirmed by customer', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF64748B)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.address ?? 'Location not provided', style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _buildSection(
              title: 'Estimate & Terms',
              child: Column(
                children: [
                  _buildTermRow('Estimated Fee', "₹\${booking.estimatedCharge?.toStringAsFixed(0) ?? '300'}", isBold: true),
                  _buildTermRow('Platform Cut', '₹0 (Zero Commission)'),
                  _buildTermRow('Payment Mode', 'Cash on Completion'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomSheet: booking.status == 'pending' ? Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  foregroundColor: const Color(0xFFDC2626),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFFCA5A5))),
                  elevation: 0,
                ),
                child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      final amountCtrl = TextEditingController();
                      final dateCtrl = TextEditingController(text: 'Today');
                      final timeCtrl = TextEditingController(text: 'As soon as possible');
                      return AlertDialog(
                        title: const Text('Submit Proposal'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: amountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Estimated Amount (₹)'),
                            ),
                            TextField(
                              controller: dateCtrl,
                              decoration: const InputDecoration(labelText: 'Date'),
                            ),
                            TextField(
                              controller: timeCtrl,
                              decoration: const InputDecoration(labelText: 'Time Slot'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () async {
                              final amount = double.tryParse(amountCtrl.text);
                              if (amount == null || amount < 0) return;
                              Navigator.pop(ctx);
                              final provider = context.read<ProfessionalProvider>();
                              final success = await provider.updateBookingStatus(
                                booking.id, 
                                'proposed', 
                                booking.professionalId,
                                extraData: {
                                  'estimatedCharge': amount,
                                  'scheduledDate': dateCtrl.text,
                                  'timeSlot': timeCtrl.text,
                                }
                              );
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proposal Sent!')));
                                context.goNamed('professional-dashboard');
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      );
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Submit Proposal', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ],
        ),
      ) : null,
    );
  }



  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTermRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: isBold ? const Color(0xFF10B981) : const Color(0xFF0F172A),
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
