import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/session_provider.dart';
import '../../models/booking.dart';
import '../../models/review.dart' as import_review;

class ReviewScreen extends StatefulWidget {
  final BookingModel? booking; // Accept optional for testing

  const ReviewScreen({super.key, this.booking});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);
  final Color outline = const Color(0xFFCBD5E1);
  
  int _rating = 5;
  final Set<String> _selectedCompliments = {'Fixed Right First Time', 'Clean Work Area', 'Polite & Courteous', 'On Time'};
  
  final _feedbackCtrl = TextEditingController(text: 'Vijay arrived right on schedule, quickly identified the worn U-trap gasket under my kitchen sink, replaced it neatly, and tested the line twice before leaving. Very respectful and skilled!');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Rate Your Professional', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pro Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.grey.shade200, radius: 24, backgroundImage: const NetworkImage('https://via.placeholder.com/150')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.booking?.professionalName ?? 'Professional', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: Color(0xFF10B981), size: 14),
                          ],
                        ),
                        Text('Master ${widget.booking?.jobSnapshot['analysis']?['category'] ?? 'Craftsman'}', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text('Completed: ${widget.booking?.jobSnapshot['analysis']?['problemType'] ?? 'Service'}', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
                        Text('Job ID #${widget.booking?.id.substring(0, 8).toUpperCase() ?? '00000'}', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text('How was your experience?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: onSurface)),
            const SizedBox(height: 8),
            Text('Your rating helps local homeowners find the right craftsman and rewards top trade talent.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: onSurfaceVariant, height: 1.5)),
            const SizedBox(height: 24),
            
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(index < _rating ? Icons.star : Icons.star_border, size: 40, color: const Color(0xFFFDE047)),
                  onPressed: () => setState(() => _rating = index + 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              }),
            ),
            const SizedBox(height: 8),
            const Text('Excellent Service!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
            
            const SizedBox(height: 32),
            
            // Sub-metrics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Column(
                children: [
                  _buildMetricRow('Professionalism & Conduct', 5),
                  const SizedBox(height: 12),
                  _buildMetricRow('Workmanship & Skill Quality', 5),
                  const SizedBox(height: 12),
                  _buildMetricRow('Communication & Transparency', 4),
                  const SizedBox(height: 12),
                  _buildMetricRow('Punctuality & Timeliness', 5),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text('Compliments', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                _buildComplimentChip('Fixed Right First Time'),
                _buildComplimentChip('Clean Work Area'),
                _buildComplimentChip('Polite & Courteous'),
                _buildComplimentChip('Fair Pricing'),
                _buildComplimentChip('On Time'),
                _buildComplimentChip('Explained Problem Well'),
              ],
            ),
            
            const SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text('Write your feedback (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface))),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline.withValues(alpha: 0.5))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline.withValues(alpha: 0.5))),
              ),
            ),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: Text('184 / 500', style: TextStyle(fontSize: 11, color: onSurfaceVariant))),
            
            const SizedBox(height: 24),
            // Photos placeholder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: outline.withValues(alpha: 0.5))),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.image, color: onSurfaceVariant),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: outline, style: BorderStyle.solid)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: onSurfaceVariant, size: 20),
                        Text('Add Photo', style: TextStyle(fontSize: 9, color: onSurfaceVariant)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Tip Prompt
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard, color: Color(0xFF1D4ED8)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tip Professional?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
                        Text('Optional tip for great service', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Add Tip'),
                  ),
                ],
              ),
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
            onPressed: () async {
              if (widget.booking != null) {
                final jobProvider = context.read<JobProvider>();
                final user = context.read<SessionProvider>().userModel;
                if (user != null) {
                  final reviewModel = import_review.ReviewModel(
                    bookingId: widget.booking!.id,
                    customerId: user.uid,
                    professionalId: widget.booking!.professionalId,
                    rating: _rating.toInt(),
                    problemSolved: true,
                    professionalism: _rating.toInt(),
                    skillQuality: _rating.toInt(),
                    communication: _rating.toInt(),
                    timeliness: _rating.toInt(),
                    comment: _feedbackCtrl.text,
                    complaint: false,
                    createdAt: DateTime.now(),
                  );
                  await jobProvider.submitReview(reviewModel);
                }
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you! Your feedback has been published.')));
                context.goNamed('customer-bookings');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Submit Review', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String title, int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
        Row(
          children: List.generate(5, (i) => Icon(i < stars ? Icons.star : Icons.star_border, size: 16, color: const Color(0xFFFDE047))),
        )
      ],
    );
  }

  Widget _buildComplimentChip(String label) {
    final bool isSelected = _selectedCompliments.contains(label);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCompliments.remove(label);
          } else {
            _selectedCompliments.add(label);
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDBEAFE) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF64748B), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
