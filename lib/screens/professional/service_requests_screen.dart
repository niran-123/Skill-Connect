import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/professional_provider.dart';
import '../../models/booking.dart';
import '../../core/booking_status.dart';

/// Professional-side Service Requests screen with 4 tabs:
/// Incoming | Awaiting Confirmation | Active | Completed
///
/// Tab mapping to new 6-step workflow:
///   Incoming → REQUEST_CREATED (professional needs to accept & set amount)
///   Awaiting  → PROFESSIONAL_ACCEPTED (waiting for customer to confirm)
///   Active    → CUSTOMER_CONFIRMED, PROFESSIONAL_ARRIVED, JOB_STARTED
///   Completed → JOB_COMPLETED
class ServiceRequestsScreen extends StatelessWidget {
  const ServiceRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Service Requests',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          actions: const [],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF1D4ED8),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF1D4ED8),
            tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Awaiting'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Consumer<ProfessionalProvider>(
          builder: (context, proProvider, child) {
            // Incoming: professional needs to review and set amount
            final incoming = proProvider.bookings
                .where((b) => b.status == BookingStatus.requestCreated)
                .toList();

            // Awaiting: professional submitted proposal, waiting for customer confirmation
            final awaiting = proProvider.bookings
                .where((b) => b.status == BookingStatus.professionalAccepted)
                .toList();

            // Active: customer confirmed → professional arrived → job started
            final activeStatuses = [
              BookingStatus.customerConfirmed,
              BookingStatus.professionalArrived,
              BookingStatus.jobStarted,
            ];
            final active = proProvider.bookings
                .where((b) => activeStatuses.contains(b.status))
                .toList();

            // Completed: job marked completed by customer
            final completed = proProvider.bookings
                .where((b) => b.status == BookingStatus.jobCompleted)
                .toList();

            return TabBarView(
              children: [
                _buildList(context, incoming, 'No Incoming Requests'),
                _buildList(context, awaiting, 'No Awaiting Requests'),
                _buildList(context, active, 'No Active Jobs'),
                _buildList(context, completed, 'No Completed Jobs'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<BookingModel> filtered,
    String emptyMsg,
  ) {
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.inbox, size: 48, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            Text(
              emptyMsg,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for updates.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (c, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final b = filtered[index];
        return GestureDetector(
          onTap: () => context.pushNamed('service-request-details', extra: b),
          child: _RequestCard(booking: b),
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BookingModel booking;
  const _RequestCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final status = b.status;

    final service = b.jobSnapshot['analysis']?['category'] ?? 'Service';
    final problem = b.jobSnapshot['description'] ?? 'No Description';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x080F172A), blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    BookingStatus.label(status),
                    style: const TextStyle(
                      color: Color(0xFF1D4ED8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'Direct Request',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(LucideIcons.user, size: 20, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                b.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
                            ],
                          ),
                          const Text(
                            'Verified Customer',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  service,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (problem.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    problem,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit_calendar, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 6),
                              Text(
                                b.scheduledDate ?? 'Date TBD',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(LucideIcons.wallet, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 6),
                              Text(
                                b.estimatedCharge != null
                                    ? 'Amount: ₹${b.estimatedCharge!.toStringAsFixed(0)}'
                                    : 'Amount: TBD',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              children: [
                _buildActions(context, b, status),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        context.pushNamed('service-request-details', extra: b),
                    child: const Text(
                      'View Full Details →',
                      style: TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, BookingModel b, String status) {
    // ── STEP 1: REQUEST_CREATED — Professional accepts and sets amount/date/time ──
    if (status == BookingStatus.requestCreated) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final provider = context.read<ProfessionalProvider>();
                final success = await provider.updateBookingStatus(
                  b.id,
                  BookingStatus.cancelled,
                  b.professionalId,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request Rejected')),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF475569),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _showAcceptDialog(context, b),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Accept & Set Amount',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    // ── STEP 2: PROFESSIONAL_ACCEPTED — Waiting for customer ──
    if (status == BookingStatus.professionalAccepted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFED7AA)),
        ),
        child: const Text(
          '⏳ Waiting for customer to confirm your proposal...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF92400E),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // ── STEP 3: CUSTOMER_CONFIRMED — Professional should head to location ──
    if (status == BookingStatus.customerConfirmed) {
      return ElevatedButton(
        onPressed: () async {
          final provider = context.read<ProfessionalProvider>();
          final success = await provider.updateBookingStatus(
            b.id,
            BookingStatus.professionalArrived,
            b.professionalId,
          );
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Marked as Arrived!'),
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
        child: const Text(
          'Once Vendor Arrived',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    // ── STEP 4: PROFESSIONAL_ARRIVED — Professional starts the job ──
    if (status == BookingStatus.professionalArrived) {
      return ElevatedButton(
        onPressed: () async {
          final provider = context.read<ProfessionalProvider>();
          final success = await provider.updateBookingStatus(
            b.id,
            BookingStatus.jobStarted,
            b.professionalId,
          );
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
        child: const Text(
          'Job Started',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    // ── STEP 5: JOB_STARTED — Waiting for customer to mark completed ──
    if (status == BookingStatus.jobStarted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF6EE7B7)),
        ),
        child: const Text(
          '🛠️ Job is in progress. Waiting for customer to mark as completed...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF065F46),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // ── STEP 6: JOB_COMPLETED ──
    if (status == BookingStatus.jobCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          '✅ Job Completed',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF065F46),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showAcceptDialog(BuildContext context, BookingModel b) {
    showDialog(
      context: context,
      builder: (ctx) {
        final amountCtrl = TextEditingController();
        final dateCtrl = TextEditingController(text: 'Today');
        final timeCtrl = TextEditingController(text: 'As soon as possible');
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Accept & Set Proposal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set the service amount, date and time before accepting.',
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
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Time Slot',
                      border: OutlineInputBorder(),
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

                    final provider = context.read<ProfessionalProvider>();
                    final success = await provider.updateBookingStatus(
                      b.id,
                      BookingStatus.professionalAccepted,
                      b.professionalId,
                      extraData: {
                        'estimatedCharge': amount,
                        'scheduledDate': dateCtrl.text.trim(),
                        'timeSlot': timeCtrl.text.trim(),
                      },
                    );
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proposal sent to customer! ✅'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
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
      },
    );
  }
}
