import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How do I book a professional?',
      'answer': 'You can describe your problem on the home screen, and our AI will match you with the best professionals nearby. Select a professional, pick a time, and submit your request.'
    },
    {
      'question': 'How is the final price calculated?',
      'answer': 'The final price depends on the exact work required. Professionals provide an estimated charge, but the final bill is generated after the work is completed.'
    },
    {
      'question': 'Are the professionals verified?',
      'answer': 'Yes, all professionals undergo a verification process where we check their ID and qualifications before they can accept jobs on SkillConnect.'
    },
    {
      'question': 'How can I cancel a booking?',
      'answer': 'You can cancel a booking from the "My Bookings" screen before the professional starts the journey to your location.'
    },
    {
      'question': 'What if I have an issue with the service?',
      'answer': 'You can contact our support team or leave a detailed review after the job is completed. We closely monitor professional ratings to ensure high quality.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color onSurface = const Color(0xFF0F172A);
    final Color surface = const Color(0xFFF7F9FB);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Frequently Asked Questions',
          style: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: const Color(0xFF1D4ED8),
                collapsedIconColor: const Color(0xFF64748B),
                title: Text(
                  faq['question']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
