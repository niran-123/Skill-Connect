import 'package:flutter/material.dart';
import '../../models/booking.dart';

class PaymentFailedScreen extends StatefulWidget {
  final BookingModel? booking; // Accept booking model

  const PaymentFailedScreen({super.key, this.booking});

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen> {
  String _selectedMethod = 'Instant UPI Intent (Google Pay / PhonePe / Paytm)';

  final List<String> _methods = [
    'Instant UPI Intent (Google Pay / PhonePe / Paytm)',
    'Scan Pro\'s Direct QR Code',
    'Pay Cash at Doorstep',
    'Credit/Debit Card or Net Banking',
  ];

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
        title: const Text('Payment Status', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150),
        child: Column(
          children: [
            // Error Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(color: Color(0xFFFEF2F2), shape: BoxShape.circle),
                    child: const Icon(Icons.warning_amber_rounded, size: 32, color: Color(0xFFDC2626)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Payment Could Not Be Processed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Your UPI transaction of ₹350 for Job #${widget.booking?.id.substring(0, 8).toUpperCase() ?? '00000'} was declined by your issuing bank or timed out.', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Ref: TXN-9028192 • Error Code: UPI_EXP_TIMEOUT', style: TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            
            // Security Note
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBBF7D0))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.security, color: Color(0xFF16A34A), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Zero Risk Guarantee: If money was debited from your account, it will automatically reverse within 24-48 business hours per RBI guidelines.', style: TextStyle(color: Color(0xFF166534), fontSize: 12, height: 1.4)),
                  ),
                ],
              ),
            ),

            // Invoice Breakdown
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Unsettled Invoice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildInvoiceRow('Service', widget.booking?.jobSnapshot['analysis']?['problemType'] ?? 'Service Request'),
                  const SizedBox(height: 8),
                  _buildInvoiceRow('Professional', widget.booking?.professionalName ?? 'Assigned Professional'),
                  const SizedBox(height: 8),
                  _buildInvoiceRow('Labor Charge', '₹250'),
                  const SizedBox(height: 8),
                  _buildInvoiceRow('Taxes & Fees', '₹100'),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total Outstanding', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A))),
                      Text('₹350', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF1D4ED8))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alternative Payment Options', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  ..._methods.map((m) => _buildPaymentOption(m)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: const Text('Retry UPI Payment (₹380)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0F172A), side: const BorderSide(color: Color(0xFFCBD5E1)), minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Switch to Cash on Delivery', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Need help? Contact Payment Support', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildPaymentOption(String title) {
    bool isSelected = _selectedMethod == title;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0), width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF94A3B8), width: isSelected ? 6 : 1.5)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14, color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}
