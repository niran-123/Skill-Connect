import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/job_provider.dart';
import '../../models/booking.dart';
import '../../core/booking_status.dart';

/// Customer-side booking details screen with Live Tracker.
/// Subscribes to real-time Firestore updates for the single booking document.
/// All status transitions go through the backend — the UI never updates locally only.
class BookingDetailsScreen extends StatefulWidget {
  final String id;
  const BookingDetailsScreen({super.key, required this.id});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Subscribe to real-time updates for this specific booking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().subscribeToBooking(widget.id);
    });
  }

  @override
  void dispose() {
    // Unsubscribe when screen is closed to prevent memory leaks
    context.read<JobProvider>().unsubscribeFromBooking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use liveBooking from the per-document subscription first,
    // fall back to the list version if not yet loaded.
    final provider = context.watch<JobProvider>();
    final liveBooking = provider.liveBooking;
    final bookings = provider.customerBookings;

    BookingModel? booking;
    if (liveBooking != null && liveBooking.id == widget.id) {
      booking = liveBooking;
    } else {
      try {
        booking = bookings.firstWhere((b) => b.id == widget.id);
      } catch (_) {
        booking = null;
      }
    }

    if (booking == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _BookingDetailsContent(booking: booking);
  }
}

class _BookingDetailsContent extends StatelessWidget {
  final BookingModel booking;
  const _BookingDetailsContent({required this.booking});

  static const Color _primary = Color(0xFF1D4ED8);
  static const Color _surface = Color(0xFFF7F9FB);
  static const Color _onSurface = Color(0xFF0F172A);
  static const Color _onSurfaceVariant = Color(0xFF64748B);
  static const Color _outline = Color(0xFFCBD5E1);
  static const Color _green = Color(0xFF10B981);
  static const Color _amber = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final status = booking.status;

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _onSurface),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share, color: _onSurface), onPressed: () {}),
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
              color: status == BookingStatus.jobCompleted ? _green : _primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status == BookingStatus.jobCompleted ? Icons.check_circle : Icons.info,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    BookingStatus.label(status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Professional Contact Card
            _buildContactCard(context, status),

            // Live Tracker
            _buildLiveTracker(status),

            // Service Info
            _buildServiceInfo(),

            // Payment Info
            _buildPaymentInfo(status),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context, status),
    );
  }

  Widget _buildContactCard(BuildContext context, String status) {
    final bool canContact = status != BookingStatus.requestCreated &&
        status != BookingStatus.jobCompleted &&
        status != BookingStatus.cancelled &&
        status != BookingStatus.cancelled;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 24,
                    backgroundImage: NetworkImage(
                      booking.professionalThumb ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.verified, color: _green, size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.professionalName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _onSurface,
                      ),
                    ),
                    const Text(
                      'Professional',
                      style: TextStyle(fontSize: 12, color: _onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (canContact) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final Uri telUri = Uri.parse('tel:+919876543210');
                      if (await canLaunchUrl(telUri)) await launchUrl(telUri);
                    },
                    icon: const Icon(Icons.phone, size: 16, color: _primary),
                    label: const Text('Call', style: TextStyle(fontSize: 12, color: _primary)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final Uri smsUri = Uri.parse('sms:+919876543210');
                      if (await canLaunchUrl(smsUri)) await launchUrl(smsUri);
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 16, color: _primary),
                    label: const Text('Message', style: TextStyle(fontSize: 12, color: _primary)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Live Tracker — driven purely by backend status.
  Widget _buildLiveTracker(String status) {
    final steps = BookingStatus.workflowOrder;
    final currentIdx = BookingStatus.workflowIndex(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Tracker',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _onSurface),
          ),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (i) {
            final isCompleted = currentIdx >= 0 && i < currentIdx;
            final isCurrent  = i == currentIdx;
            final isLast     = i == steps.length - 1;
            return _buildTimelineStep(
              completed: isCompleted,
              active:    isCurrent,
              title:     BookingStatus.label(steps[i]),
              isLast:    isLast,
            );
          }),
          if (status == BookingStatus.cancelled || status == BookingStatus.cancelled) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Request ${BookingStatus.label(status)}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required bool completed,
    required bool active,
    required String title,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: completed
                    ? _primary
                    : active
                        ? Colors.white
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: (completed || active) ? _primary : _outline,
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : active
                      ? const Icon(Icons.circle, size: 10, color: _primary)
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: completed ? _primary : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.bold : FontWeight.w600,
                  color: active ? _primary : _onSurface,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _onSurface),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Category', booking.jobSnapshot['analysis']?['category'] ?? 'Service'),
          const SizedBox(height: 12),
          _buildInfoRow(
              'Issue', booking.jobSnapshot['analysis']?['problemType'] ?? 'Unknown Issue'),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Date & Time',
            booking.scheduledDate != null
                ? '${booking.scheduledDate} • ${booking.timeSlot ?? ''}'
                : 'Awaiting Professional',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
              'Description', booking.jobSnapshot['description'] ?? 'No Description'),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(String status) {
    // Professional sets the amount in PROFESSIONAL_ACCEPTED step
    final hasAmount = booking.estimatedCharge != null;
    final amountText = hasAmount
        ? '₹${booking.estimatedCharge!.toStringAsFixed(0)}'
        : (status == BookingStatus.requestCreated ? 'Awaiting Professional' : 'TBD');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment & Estimate',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _onSurface),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Amount (set by Professional)',
            amountText,
            valueColor: hasAmount ? _green : _onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Method', 'Cash on Completion'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.shield, color: _green, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'SkillConnect Guarantee: Verified trade quality',
                  style: TextStyle(fontSize: 12, color: _onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(fontSize: 12, color: _onSurfaceVariant)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor ?? _onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomActions(BuildContext context, String status) {
    // No bottom bar for terminal states with no action needed
    if (status == BookingStatus.cancelled ||
        status == BookingStatus.cancelled ||
        status == BookingStatus.requestCreated ||
        (status == BookingStatus.jobCompleted && booking.reviewed == true)) {
      if (status == BookingStatus.requestCreated) {
        // Show waiting message
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: const Text(
                '⏳ Waiting for Professional to review your request and set the amount...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF92400E),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── PROFESSIONAL_ACCEPTED → Customer must confirm ──
            if (status == BookingStatus.professionalAccepted)
              _ProposalConfirmWidget(booking: booking),

            // ── CUSTOMER_CONFIRMED → Waiting for professional to arrive ──
            if (status == BookingStatus.customerConfirmed)
              _StatusInfoBanner(
                icon: Icons.directions_walk,
                color: _amber,
                message: 'You have confirmed! Waiting for the Professional to arrive...',
              ),

            // ── PROFESSIONAL_ARRIVED → Customer sees professional arrived ──
            if (status == BookingStatus.professionalArrived)
              _StatusInfoBanner(
                icon: Icons.location_on,
                color: _green,
                message: '✅ Professional has arrived at your location!',
              ),

            // ── JOB_STARTED → Customer can mark completed ──
            if (status == BookingStatus.jobStarted)
              ElevatedButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Mark Job Completed?'),
                      content: const Text(
                        'Please confirm that the service has been completed satisfactorily.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(backgroundColor: _green),
                          child: const Text('Yes, Completed', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    try {
                      await context.read<JobProvider>().updateBookingStatus(
                        booking.id,
                        BookingStatus.jobCompleted,
                        booking.customerId,
                        isCustomer: true,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Job Completed Successfully! 🎉'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to mark job completed')),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Job Completed',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

            // ── JOB_COMPLETED → Leave Review ──
            if (status == BookingStatus.jobCompleted && booking.reviewed != true)
              ElevatedButton(
                onPressed: () => context.pushNamed(
                  'customer-review',
                  pathParameters: {'id': booking.id},
                  extra: booking,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Leave Review',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget shown to customer when status is PROFESSIONAL_ACCEPTED.
/// Displays the amount/date/time set by the professional and lets the customer confirm.
class _ProposalConfirmWidget extends StatelessWidget {
  final BookingModel booking;
  const _ProposalConfirmWidget({required this.booking});

  static const Color _primary = Color(0xFF1D4ED8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Professional's proposal details
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Professional\'s Proposal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _primary,
                ),
              ),
              const SizedBox(height: 12),
              _infoRow(Icons.currency_rupee, 'Amount',
                  booking.estimatedCharge != null
                      ? '₹${booking.estimatedCharge!.toStringAsFixed(0)}'
                      : 'Not set'),
              const SizedBox(height: 8),
              _infoRow(Icons.calendar_today, 'Date',
                  booking.scheduledDate ?? 'Not set'),
              const SizedBox(height: 8),
              _infoRow(Icons.access_time, 'Time',
                  booking.timeSlot ?? 'Not set'),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reject Proposal?'),
                      content: const Text('Are you sure you want to reject this proposal?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Reject', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    try {
                      await context.read<JobProvider>().updateBookingStatus(
                        booking.id,
                        BookingStatus.cancelled,
                        booking.customerId,
                        isCustomer: true,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proposal rejected.')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to reject. Please try again.')),
                        );
                      }
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Reject',
                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await context.read<JobProvider>().updateBookingStatus(
                      booking.id,
                      BookingStatus.customerConfirmed,
                      booking.customerId,
                      isCustomer: true,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Confirmed! The professional will now proceed to your location.'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to confirm. Please try again.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'By accepting, you confirm the amount, date, and time set by the Professional.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _primary),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
        Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ],
    );
  }
}

class _StatusInfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  const _StatusInfoBanner({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
