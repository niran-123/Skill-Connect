import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.goNamed('login'),
                child: Text('Skip', style: TextStyle(color: onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  _buildSlide(
                    icon: Icons.handyman_outlined,
                    title: 'Find Skilled Professionals',
                    description: 'Connect with trusted local professionals for everyday service needs in minutes.',
                    chips: ['⚡ Rapid Matching', '🛡️ Verified Pros', '💬 Direct Connect'],
                  ),
                  _buildSlide(
                    icon: Icons.access_time,
                    title: 'Book Instantly',
                    description: 'Get immediate help for emergencies or schedule appointments in advance.',
                    chips: ['🕒 24/7 Availability', '📅 Flexible Scheduling'],
                  ),
                  _buildSlide(
                    icon: Icons.verified_user_outlined,
                    title: 'Quality Guaranteed',
                    description: 'Every professional is vetted and reviewed by the community.',
                    chips: ['⭐ Real Reviews', '✅ Satisfaction Guaranteed'],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < 2) {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        } else {
                          context.goNamed('login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_currentIndex == 2 ? 'Get Started' : 'Next', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Inter')),
                          if (_currentIndex < 2) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Slide \${_currentIndex + 1} of 3 — Or explore as guest', style: TextStyle(color: onSurfaceVariant, fontSize: 12, fontFamily: 'Inter')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? primary : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSlide({required IconData icon, required String title, required String description, required List<String> chips}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: primary.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 12)),
              ],
            ),
            child: Icon(icon, size: 64, color: primary),
          ),
          const SizedBox(height: 48),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
          const SizedBox(height: 16),
          Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: onSurfaceVariant, height: 1.5, fontFamily: 'Inter')),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: chips.map((chip) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
              child: Text(chip, style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
