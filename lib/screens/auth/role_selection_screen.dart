import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final bool _isLoading = false;
  String _selectedRole = 'customer'; // Default selected

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);

  void _selectRole(BuildContext context, String role) {
    if (role == 'customer') {
      context.pushNamed('signup');
    } else if (role == 'professional') {
      context.pushNamed('pro-registration');
    }
  }

  Widget _buildRoleCard({
    required String roleId,
    required IconData icon,
    required String title,
    required String tagline,
    required List<String> highlights,
  }) {
    final bool isSelected = _selectedRole == roleId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = roleId;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primary : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected) BoxShadow(color: primary.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
            if (!isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? primary.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: isSelected ? primary : onSurfaceVariant, size: 24),
                ),
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? primary : const Color(0xFFCBD5E1), width: 2),
                  ),
                  child: isSelected ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(color: primary, shape: BoxShape.circle))) : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text(tagline, style: TextStyle(fontSize: 13, color: onSurfaceVariant, height: 1.4, fontFamily: 'Inter')),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: highlights.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: primary),
                    const SizedBox(width: 6),
                    Text(h, style: TextStyle(fontSize: 12, color: onSurfaceVariant, fontFamily: 'Inter')),
                  ],
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: isSelected 
                ? ElevatedButton(
                    onPressed: _isLoading ? null : () => _selectRole(context, roleId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading && _selectedRole == roleId
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('Continue as ${title.replaceAll("I'm a ", "")}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  )
                : OutlinedButton(
                    onPressed: () => setState(() => _selectedRole = roleId),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Continue as ${title.replaceAll("I'm a ", "")}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primary)),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Icon(Icons.handyman_rounded, color: primary), // Mini logo placeholder
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How do you want to use SkillConnect?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your account type to customize your experience',
                style: TextStyle(fontSize: 14, color: onSurfaceVariant, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 32),
              _buildRoleCard(
                roleId: 'customer',
                icon: Icons.person_outline,
                title: "I'm a Customer",
                tagline: "Find and book skilled professionals for repairs, installations, and maintenance.",
                highlights: ["AI problem diagnosis", "Compare matched quotes", "Verified background"],
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                roleId: 'professional',
                icon: Icons.build_circle_outlined,
                title: "I'm a Professional",
                tagline: "Offer your skills, receive matched local service requests, and grow your trade business.",
                highlights: ["Skill-ranked leads", "Manage availability", "Zero listing fees"],
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'You can switch roles later from your settings.',
                  style: TextStyle(fontSize: 12, color: onSurfaceVariant, fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.goNamed('login'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: onSurfaceVariant, fontSize: 14, fontFamily: 'Inter'),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

