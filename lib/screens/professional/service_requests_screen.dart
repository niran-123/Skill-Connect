import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/professional_provider.dart';
import '../../models/booking.dart';

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
            style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 20),
          ),
          actions: [],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF1D4ED8),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF1D4ED8),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Consumer<ProfessionalProvider>(
          builder: (context, proProvider, child) {
            final pending = proProvider.bookings.where((b) => b.status == 'pending' || b.status == 'proposed').toList();
            final accepted = proProvider.bookings.where((b) => b.status == 'accepted').toList();
            final active = proProvider.bookings.where((b) => b.status == 'in_progress' || b.status == 'arrived' || b.status == 'ready_to_start').toList();
            final completed = proProvider.bookings.where((b) => b.status == 'completed').toList();

            return TabBarView(
              children: [
                _buildList(context, pending, 'No Pending Requests'),
                _buildList(context, accepted, 'No Accepted Requests'),
                _buildList(context, active, 'No Active Jobs'),
                _buildList(context, completed, 'No Completed Jobs'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<BookingModel> filtered, String emptyMsg) {
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.inbox, size: 48, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            Text(emptyMsg, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text('Check back later for updates.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B))),
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
          child: _buildRequestCard(
            matchText: 'Direct Request',
            matchColor: const Color(0xFF1D4ED8),
            matchBg: const Color(0xFFDBEAFE),
            distance: "\${b.jobSnapshot['lat'] ?? 'N/A'}", 
            customerName: b.customerName,
            customerRating: 'New',
            isVerified: true,
            service: b.jobSnapshot['analysis']?['category'] ?? 'Service',
            problem: b.jobSnapshot['description'] ?? 'No Description',
            skills: [],
            dateTime: 'Requested',
            earnings: 'Est. ₹250 - ₹500',
            b: b,
            context: context,
          ),
        );
      },
    );
  }

  Widget _buildRequestCard({
    required String matchText,
    required Color matchColor,
    required Color matchBg,
    required String distance,
    required String customerName,
    required String customerRating,
    required bool isVerified,
    required String service,
    required String problem,
    required List<String> skills,
    required String dateTime,
    required String earnings,
    required BookingModel b,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 4, offset: Offset(0, 2))],
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
                  decoration: BoxDecoration(color: matchBg, borderRadius: BorderRadius.circular(4)),
                  child: Text(matchText, style: TextStyle(color: matchColor, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
                Text(distance, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
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
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(LucideIcons.user, size: 20, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                              if (isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
                              ]
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 4),
                              Text(customerRating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
                              if (isVerified) ...[
                                const Text(' • ', style: TextStyle(color: Color(0xFFCBD5E1))),
                                const Text('Verified Resident', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              ]
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(service, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                if (problem.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(problem, style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
                ],
                if (skills.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                      child: Text(s, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
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
                              Text(dateTime, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(LucideIcons.wallet, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 6),
                              Text('Est. Earnings: $earnings', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
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
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              children: [
                if (b.status == 'proposed')
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text('Waiting for customer to accept...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, textAlign: TextAlign.center)),
                  ),
                if (b.status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            // Reject logic
                            final provider = context.read<ProfessionalProvider>();
                            final success = await provider.updateBookingStatus(b.id, 'rejected', b.professionalId);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Rejected')));
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
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                final amountCtrl = TextEditingController();
                                final dateCtrl = TextEditingController(text: 'Today');
                                final timeCtrl = TextEditingController(text: 'As soon as possible');
                                return AlertDialog(
                                  title: const Text('Submit Proposal'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
                                      TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date')),
                                      TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Time Slot')),
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
                                          b.id, 'proposed', b.professionalId,
                                          extraData: {'estimatedCharge': amount, 'scheduledDate': dateCtrl.text, 'timeSlot': timeCtrl.text}
                                        );
                                        if (success && mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proposal Sent!')));
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
                          child: const Text('Submit Proposal', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                if (b.status == 'accepted')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final provider = context.read<ProfessionalProvider>();
                            final success = await provider.updateBookingStatus(b.id, 'arrived', b.professionalId);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Arrived on location!')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Arrived', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                if (b.status == 'arrived')
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text('Waiting for customer confirmation...', textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                if (b.status == 'ready_to_start')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final provider = context.read<ProfessionalProvider>();
                            final success = await provider.updateBookingStatus(b.id, 'in_progress', b.professionalId);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job Started!')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Start Job', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                if (b.status == 'pending' || b.status == 'proposed' || b.status == 'accepted' || b.status == 'arrived' || b.status == 'ready_to_start')
                  const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View Full Details →', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w500, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
