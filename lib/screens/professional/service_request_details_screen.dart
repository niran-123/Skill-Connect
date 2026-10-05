import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/booking.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repo.dart';
import '../../providers/professional_provider.dart';
import '../../core/booking_status.dart';

/// Professional-side detail view for a service request.
/// Uses real-time booking stream so it auto-updates when the customer confirms.
class ServiceRequestDetailsScreen extends StatefulWidget {
  final BookingModel booking;
  const ServiceRequestDetailsScreen({super.key, required this.booking});

  @override
  State<ServiceRequestDetailsScreen> createState() =>
      _ServiceRequestDetailsScreenState();
}

class _ServiceRequestDetailsScreenState
    extends State<ServiceRequestDetailsScreen> {
  BookingModel? _liveBooking;
  UserModel? _customer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _liveBooking = widget.booking;
    _fetchCustomer();
    // Listen to real-time updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscribeToLiveUpdates();
    });
  }

  Future<void> _fetchCustomer() async {
    final repo = UserRepo();
    final user = await repo.getUser(widget.booking.customerId);
    if (mounted) {
      setState(() {
        _customer = user;
      });
    }
  }

  Stream<BookingModel?>? _stream;

  void _subscribeToLiveUpdates() {
    final proProvider = context.read<ProfessionalProvider>();
    _stream = proProvider.streamBooking(widget.booking.id);
    _stream?.listen((updated) {
      if (mounted && updated != null) {
        setState(() => _liveBooking = updated);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = _liveBooking ?? widget.booking;
    final status = booking.status;

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
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              BookingStatus.label(status),
              style: TextStyle(
                color: _statusColor(status),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            // Customer Profile Card
            _buildCustomerCard(context, booking, status),

            const SizedBox(height: 8),

            // Job Details Section
            _buildSection(
              title: 'Job Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.jobSnapshot['analysis']?['problemType'] ?? 'Service Request',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.jobSnapshot['description'] ?? 'No description provided.',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Scheduling & Estimate
            _buildSection(
              title: 'Scheduling & Estimate',
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
                            Text(
                              '${booking.scheduledDate ?? 'Date not set'} • ${booking.timeSlot ?? 'Time not set'}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              booking.estimatedCharge != null
                                  ? 'Amount: ₹${booking.estimatedCharge!.toStringAsFixed(0)}'
                                  : 'Amount: Not set yet',
                              style: TextStyle(
                                color: booking.estimatedCharge != null
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF94A3B8),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
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
                      const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF64748B)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          booking.address ?? 'Location not provided',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(context, booking, status),
    );
  }

  Widget _buildCustomerCard(BuildContext context, BookingModel booking, String status) {
    // Contact is available after customer confirmation
    final canContact = status == BookingStatus.customerConfirmed ||
        status == BookingStatus.professionalArrived ||
        status == BookingStatus.jobStarted ||
        status == BookingStatus.jobCompleted;

    return Container(
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
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: _customer?.avatarThumb != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.network(
                          _customer!.avatarThumb!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(LucideIcons.user, size: 28, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _customer?.name ?? booking.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.security, size: 14, color: Color(0xFF10B981)),
                        SizedBox(width: 4),
                        Text(
                          'Verified Customer',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canContact
                      ? () async {
                          final Uri uri = Uri(
                            scheme: 'tel',
                            path: _customer?.phone ?? booking.customerPhone ?? '1234567890',
                          );
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        }
                      : null,
                  icon: const Icon(LucideIcons.phone, size: 16),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canContact
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFFF1F5F9),
                    foregroundColor: canContact ? Colors.white : const Color(0xFF94A3B8),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canContact
                      ? () async {
                          final Uri uri = Uri(
                            scheme: 'sms',
                            path: _customer?.phone ?? booking.customerPhone ?? '1234567890',
                          );
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        }
                      : null,
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canContact
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFFF1F5F9),
                    foregroundColor: canContact ? Colors.white : const Color(0xFF94A3B8),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
          if (!canContact) ...[
            const SizedBox(height: 8),
            const Text(
              'Contact available after customer confirms your proposal',
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget? _buildBottomSheet(BuildContext context, BookingModel booking, String status) {
    // ── REQUEST_CREATED: Accept with amount/date/time ──
    if (status == BookingStatus.requestCreated) {
      return Container(
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
                onPressed: () async {
                  setState(() => _isLoading = true);
                  final provider = context.read<ProfessionalProvider>();
                  final success = await provider.updateBookingStatus(
                    booking.id,
                    BookingStatus.cancelled,
                    booking.professionalId,
                  );
                  setState(() => _isLoading = false);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request Rejected')),
                    );
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  foregroundColor: const Color(0xFFDC2626),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _showAcceptDialog(context, booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Accept & Set Amount',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      );
    }

    // ── PROFESSIONAL_ACCEPTED: Waiting for customer ──
    if (status == BookingStatus.professionalAccepted) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: const BoxDecoration(color: Colors.white),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: const Text(
            '⏳ Proposal sent. Waiting for customer to confirm...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF92400E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // ── CUSTOMER_CONFIRMED: Professional should head to location ──
    if (status == BookingStatus.customerConfirmed) {
      return Container(
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
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  final provider = context.read<ProfessionalProvider>();
                  final success = await provider.updateBookingStatus(
                    booking.id,
                    BookingStatus.professionalArrived,
                    booking.professionalId,
                  );
                  setState(() => _isLoading = false);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Marked as Arrived! ✅'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Once Vendor Arrived',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
        ),
      );
    }

    // ── PROFESSIONAL_ARRIVED: Start the job ──
    if (status == BookingStatus.professionalArrived) {
      return Container(
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
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  final provider = context.read<ProfessionalProvider>();
                  final success = await provider.updateBookingStatus(
                    booking.id,
                    BookingStatus.jobStarted,
                    booking.professionalId,
                  );
                  setState(() => _isLoading = false);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Job Started! 🛠️'),
                        backgroundColor: Color(0xFFF59E0B),
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Job Started',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
        ),
      );
    }

    // ── JOB_STARTED: Waiting for customer to mark complete ──
    if (status == BookingStatus.jobStarted) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: const BoxDecoration(color: Colors.white),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6EE7B7)),
          ),
          child: const Text(
            '🛠️ Job in progress. Waiting for customer to confirm completion...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF065F46),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // ── JOB_COMPLETED ──
    if (status == BookingStatus.jobCompleted) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: const BoxDecoration(color: Colors.white),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '✅ Job Completed Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF065F46),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return null;
  }

  void _showAcceptDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (ctx) {
        final amountCtrl = TextEditingController();
        final dateCtrl = TextEditingController(text: 'Today');
        final timeCtrl = TextEditingController(text: 'As soon as possible');

        return AlertDialog(
          title: const Text('Accept & Set Proposal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the service amount, scheduled date and time.',
                style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Service Amount (₹) *',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dateCtrl,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    dateCtrl.text = "\${date.day}/\${date.month}/\${date.year}";
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeCtrl,
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: ctx,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null && ctx.mounted) {
                    timeCtrl.text = time.format(ctx);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Time Slot',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountCtrl.text.trim());
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                setState(() => _isLoading = true);
                final provider = context.read<ProfessionalProvider>();
                final success = await provider.updateBookingStatus(
                  booking.id,
                  BookingStatus.professionalAccepted,
                  booking.professionalId,
                  extraData: {
                    'estimatedCharge': amount,
                    'scheduledDate': dateCtrl.text.trim(),
                    'timeSlot': timeCtrl.text.trim(),
                  },
                );
                setState(() => _isLoading = false);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proposal sent! ✅'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                  context.pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Accept & Send'),
            ),
          ],
        );
      },
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case BookingStatus.requestCreated:
        return const Color(0xFF1D4ED8);
      case BookingStatus.professionalAccepted:
        return const Color(0xFFF59E0B);
      case BookingStatus.customerConfirmed:
        return const Color(0xFF10B981);
      case BookingStatus.professionalArrived:
        return const Color(0xFF10B981);
      case BookingStatus.jobStarted:
        return const Color(0xFFF59E0B);
      case BookingStatus.jobCompleted:
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF64748B);
    }
  }
}
