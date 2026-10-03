import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/job_provider.dart';
import '../../providers/session_provider.dart';
import '../../models/match_result.dart';

class BookingRequestScreen extends StatefulWidget {
  final MatchResult match;
  const BookingRequestScreen({super.key, required this.match});

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  final _descCtrl = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    final jobProvider = context.read<JobProvider>();
    _descCtrl.text = jobProvider.currentJob?.description ?? '';
  }

  void _sendRequest() async {
    final jobProvider = context.read<JobProvider>();
    final user = context.read<SessionProvider>().userModel;
    if (user == null) return;
    
    // In a real app, we'd also read the selected date/time from the UI state
    // But for this demo, we'll just process it directly
    final success = await jobProvider.bookProfessional(
      match: widget.match,
      customerId: user.uid,
      customerName: user.name,
    );
    
    if (success && mounted) {
      context.goNamed('customer-booking-sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pro = widget.match.professional;
    
    final jobProvider = context.watch<JobProvider>();
    final analysis = jobProvider.currentJob?.analysis ?? {};
    
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
        title: Text('Book Professional', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Selected Professional Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(image: NetworkImage(pro.avatarThumb ?? 'https://via.placeholder.com/150'), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(bottom: -4, right: -4, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.verified, color: Color(0xFF10B981), size: 16))),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pro.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                        const SizedBox(height: 2),
                        Text(pro.category, style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                            Text(' \$rating • ~3 km away', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Form
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Service Required', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: analysis['problemType'] ?? 'General Service',
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text('2. Schedule Date & Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChip('Today', true),
                        const SizedBox(width: 8),
                        _buildChip('Tomorrow', false),
                        const SizedBox(width: 8),
                        _buildChip('Pick Date', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChip('Immediate (Within 1 hr)', false),
                        const SizedBox(width: 8),
                        _buildChip('Anytime Today', true),
                        const SizedBox(width: 8),
                        _buildChip('Evening', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('3. Service Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: outline)),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF1D4ED8)),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Current Location', style: TextStyle(fontSize: 12, color: onSurface))),
                        Text('Change', style: TextStyle(fontSize: 12, color: primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('4. Problem Description / Special Instructions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (jobProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(jobProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: jobProvider.isLoading ? null : _sendRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: jobProvider.isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send Booking Request', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFDBEAFE) : Colors.white,
        border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF64748B), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildPriceRow(String title, String price, {String? subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A))),
            if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF10B981))),
          ],
        ),
        Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
      ],
    );
  }
}
