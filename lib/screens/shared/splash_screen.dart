import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Clean light background
      body: Stack(
        children: [
          // Subtle faint radial blue glow
          Positioned(
            top: -100,
            left: -100,
            right: -100,
            bottom: -100,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1D4ED8).withValues(alpha: 0.05),
                    const Color(0xFFF8FAFC).withValues(alpha: 0.0),
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Prominent SkillConnect brand logo
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1D4ED8).withValues(alpha: 0.15),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.handyman_rounded, // Placeholder for IMAGE_2
                            size: 48,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // App title
                        const Text(
                          'SkillConnect',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Color(0xFF0F172A), // text-slate-900
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Subtitle / tagline
                        const Text(
                          'Find Trusted Local Professionals',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B), // text-slate-500
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer section
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D4ED8)),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Connecting Skills with Everyday Needs',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF94A3B8), // text-slate-400
                        ),
                      ),
                    ],
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
