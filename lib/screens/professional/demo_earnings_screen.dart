import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class DemoEarningsScreen extends StatelessWidget {
  const DemoEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Earnings', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 20)),
        actions: [
          IconButton(icon: const Icon(LucideIcons.info, color: Color(0xFF0F172A)), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Earnings Hero Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFF1D4ED8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 4),
                        const Text('₹14,850', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Available to Withdraw', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                SizedBox(height: 4),
                                Text('₹2,450', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('This Month (Oct)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(LucideIcons.trending_up, size: 14, color: Color(0xFF34D399)),
                                    SizedBox(width: 4),
                                    Text('₹8,920', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1D4ED8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: const Text('Withdraw to Bank', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Icon(LucideIcons.download, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Period Filter Strip
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill('This Week'),
                        _buildFilterPill('This Month (Oct)', isActive: true),
                        _buildFilterPill('Last 30 Days'),
                        _buildFilterPill('Custom Range'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Financial Metrics Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: [
                      _buildMetricCard('Total Jobs', '128', LucideIcons.briefcase),
                      _buildMetricCard('Avg Earnings / Job', '₹395', LucideIcons.wallet),
                      _buildMetricCard('Tips Received', '₹1,200', LucideIcons.heart),
                      _buildMetricCard('Platform Fee', '₹0', LucideIcons.percent, isZero: true),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Weekly Performance Chart
                  const Text('Weekly Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar('Mon', 65, false),
                        _buildChartBar('Tue', 85, false),
                        _buildChartBar('Wed', 120, false),
                        _buildChartBar('Thu', 78, false),
                        _buildChartBar('Fri', 145, false),
                        _buildChartBar('Sat', 190, true), // Highlighted
                        _buildChartBar('Sun', 120, false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recent Payouts & Transaction Ledger
                  const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        _buildTxRow('Fan Regulator Job #BK-78210', '24 Oct', '+₹380', 'Cash Collected', const Color(0xFF10B981)),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildTxRow('MCB Breaker Job #BK-77984', '23 Oct', '+₹520', 'Cash Collected', const Color(0xFF3B82F6)),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildTxRow('Weekly Bank Transfer', '22 Oct', '-₹4,500', 'Transferred to HDFC ****4912', const Color(0xFF64748B), isNegative: true),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildTxRow('Customer Tip (Rahul K)', '21 Oct', '+₹100', 'Direct Pro Tip', const Color(0xFFF59E0B), isStar: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bank & Payout Method Card
                  const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: const Icon(LucideIcons.landmark, color: Color(0xFF1D4ED8), size: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text('HDFC Bank', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                                      SizedBox(width: 4),
                                      Icon(LucideIcons.badge_check, size: 14, color: Color(0xFF10B981)),
                                    ],
                                  ),
                                  const Text('Acc ending 4912', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: Color(0xFFF1F5F9)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Bank Account linked', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              child: const Text('Manage', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w500, fontSize: 13)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)),
      ),
      child: Text(
        label,
        style: TextStyle(color: isActive ? Colors.white : const Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, {bool isZero = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: const Color(0xFF64748B))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isZero ? const Color(0xFF10B981) : const Color(0xFF0F172A))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double height, bool isHighlight) {
    return Column(
      children: [
        if (isHighlight)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(color: const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(4)),
            child: const Text('₹1.9k', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            color: isHighlight ? const Color(0xFF1D4ED8) : const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 12, fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400, color: isHighlight ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildTxRow(String title, String date, String amount, String subtitle, Color iconColor, {bool isNegative = false, bool isStar = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(isStar ? LucideIcons.star : (isNegative ? LucideIcons.arrow_up_right : LucideIcons.arrow_down_left), color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const Text(' • ', style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
                    Expanded(child: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(amount, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: isNegative ? const Color(0xFF0F172A) : const Color(0xFF10B981))),
        ],
      ),
    );
  }
}
