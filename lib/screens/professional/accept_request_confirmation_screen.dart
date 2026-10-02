import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AcceptRequestConfirmationScreen extends StatelessWidget {
  const AcceptRequestConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.9), // Dark overlay backdrop
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Accept Request',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Confirmation Modal Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
                      child: const Icon(LucideIcons.handshake, size: 32, color: Color(0xFF1D4ED8)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Accept this service request?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'By accepting, you commit to arriving at the scheduled time with the necessary trade equipment.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Job Recap Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _buildRecapRow('Customer', 'Rahul Kumar (Thillai Nagar • 2.4 km)'),
                          const Divider(height: 16, color: Color(0xFFE2E8F0)),
                          _buildRecapRow('Service', 'Ceiling Fan Regulator Replacement'),
                          const Divider(height: 16, color: Color(0xFFE2E8F0)),
                          _buildRecapRow('Scheduled', 'Today, 24 Oct • 3:30 PM - 5:00 PM'),
                          const Divider(height: 16, color: Color(0xFFE2E8F0)),
                          _buildRecapRow('Address', '42 West Boulevard Rd, Thillai Nagar'),
                          const Divider(height: 16, color: Color(0xFFE2E8F0)),
                          _buildRecapRow('Earnings', '₹300 - ₹450', isEarnings: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pro Responsibilities
                    Column(
                      children: [
                        _buildResponsibilityItem('Arrive within designated arrival window (3:30 PM)'),
                        _buildResponsibilityItem('Carry safety tools and standard replacement parts'),
                        _buildResponsibilityItem('Wear SkillConnect trade partner uniform or ID badge'),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Actions
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Confirm & Accept Job', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF475569),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Cancel / Go Back', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Success State Toast / Banner Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('🎉', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Service Request Accepted! Dispatched notifications sent to customer Rahul Kumar. Job added to Active Jobs.',
                            style: TextStyle(color: Color(0xFF166534), fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Proceed to Active Job Tracker →', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecapRow(String label, String value, {bool isEarnings = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isEarnings ? const Color(0xFF10B981) : const Color(0xFF0F172A),
              fontWeight: isEarnings ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibilityItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Color(0xFF475569), fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
