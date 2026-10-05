import 'package:flutter/material.dart';
import 'package:skill_connect/core/booking_status.dart';

import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_provider.dart';

class JobHistoryScreen extends StatefulWidget {
  const JobHistoryScreen({super.key});

  @override
  State<JobHistoryScreen> createState() => _JobHistoryScreenState();
}

class _JobHistoryScreenState extends State<JobHistoryScreen> {
  String _currentTab = 'Completed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Job History',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.transparent),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Stats Banner
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _buildStatChip('Total Completed', '0 Jobs')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatChip('Completion Rate', '-')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatChip('Total Earnings', '₹0')),
              ],
            ),
          ),

          // Search & Filter Controls
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(LucideIcons.search, color: Color(0xFF64748B), size: 20),
                      border: InputBorder.none,
                      hintText: 'Search customer, booking ID, or trade...',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterTab('Completed'),
                            const SizedBox(width: 8),
                            _buildFilterTab('Cancelled'),
                            const SizedBox(width: 8),
                            _buildFilterTab('Disputed'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // History Job Cards List
          Expanded(
            child: Consumer<ProfessionalProvider>(
              builder: (context, proProvider, child) {
                final filteredJobs = proProvider.bookings.where((b) {
                  if (_currentTab == 'Completed') return b.status == BookingStatus.jobCompleted;
                  if (_currentTab == 'Cancelled') return b.status == BookingStatus.cancelled;
                  if (_currentTab == 'Disputed') return b.status == 'disputed';
                  return false;
                }).toList();

                if (filteredJobs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.history, size: 64, color: Color(0xFFCBD5E1)),
                        const SizedBox(height: 16),
                        Text('No  jobs yet', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(' jobs will appear here', style: const TextStyle(color: Color(0xFF64748B))),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredJobs.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final b = filteredJobs[index];
                    return _buildJobCard(
                      bookingId: b.jobId.isNotEmpty ? b.jobId : 'Service Request',
                      dateTime: 'Completed',
                      customer: b.customerName,
                      location: 'Service Location',
                      service: b.jobSnapshot['analysis']?['category'] ?? 'Service',
                      payout: '₹${b.finalCharge?.toInt() ?? b.estimatedCharge?.toInt() ?? 350}', 
                      paymentMethod: 'Paid on Completion',
                      rating: '★ 5.0',
                      ratingReview: b.completionNotes ?? '',
                      statusText: 'Completed ✓',
                      statusColor: const Color(0xFF10B981),
                      statusBg: const Color(0xFFDCFCE7),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    final isActive = _currentTab == label;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF475569),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required String bookingId,
    required String dateTime,
    required String customer,
    required String location,
    required String service,
    required String payout,
    required String paymentMethod,
    required String rating,
    required String ratingReview,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x050F172A), blurRadius: 4, offset: Offset(0, 2))],
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
                Text(bookingId, style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600, fontSize: 13)),
                Text(dateTime, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$customer • $location', style: const TextStyle(color: Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(service, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
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
                          Text('Payout: $payout', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text(paymentMethod, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                      if (rating.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(rating, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
                            if (ratingReview.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              SizedBox(
                                width: 100,
                                child: Text('"$ratingReview"', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
                              ),
                            ]
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('View Receipt', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600, fontSize: 13)),
                ),
                if (statusColor == const Color(0xFF10B981)) // Completed
                  TextButton(
                    onPressed: () {},
                    child: const Text('Customer Details', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
