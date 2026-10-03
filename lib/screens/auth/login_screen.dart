import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isCustomer = true;
  bool _isPasswordVisible = false;
  String? _localError;

  // Colors extracted from Stitch design system
  final Color primary = const Color(0xFF0037B0);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF191C1E);
  final Color onSurfaceVariant = const Color(0xFF434655);
  final Color surfaceContainerLowest = const Color(0xFFFFFFFF);
  final Color surfaceContainerHigh = const Color(0xFFE6E8EA);
  final Color secondary = const Color(0xFF516070);
  final Color secondaryContainer = const Color(0xFFD5E4F8);
  final Color onSecondaryFixed = const Color(0xFF0E1D2B);
  final Color outline = const Color(0xFF747686);

  Future<void> _handleLogin() async {
    setState(() => _localError = null);
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _localError = 'Please enter both email and password.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _localError = 'Please enter a valid email address.');
      return;
    }
    final auth = context.read<AuthProvider>();
    await auth.signInWithEmail(email, pass);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Badges & Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_pin, size: 14, color: onSecondaryFixed),
                        const SizedBox(width: 6),
                        Text(
                          _isCustomer ? 'Customer Account' : 'Professional Login',
                          style: TextStyle(color: onSecondaryFixed, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCustomer = !_isCustomer;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          _isCustomer ? 'Switch to Pro' : 'Switch to Customer',
                          style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.swap_horiz, size: 16, color: primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Header Titles
              Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.3),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your credentials to access your SkillConnect account',
                style: TextStyle(fontSize: 14, color: onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              
              // Role Switcher Segmented Control
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTab(title: 'Customer', icon: Icons.home, isSelected: _isCustomer, onTap: () => setState(() => _isCustomer = true)),
                    _buildTab(title: 'Professional', icon: Icons.handyman, isSelected: !_isCustomer, onTap: () => setState(() => _isCustomer = false)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Interactive Error Alert Demo Banner
              if (auth.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDAD6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Color(0xFFBA1A1A)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Authentication Alert',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFBA1A1A), fontSize: 12),
                            ),
                            Text(
                              auth.errorMessage!,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF93000A)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Email Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface)),
                  Text(_isCustomer ? 'Personal Login' : 'Pro Fleet Login', style: TextStyle(fontSize: 11, color: secondary)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline, color: secondary, size: 20),
                    hintText: 'name@example.com',
                    hintStyle: TextStyle(color: outline, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Password Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface)),
                  GestureDetector(
                    onTap: () => context.pushNamed('forgot-password'),
                    child: Text('Forgot Password?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: TextField(
                  controller: _passCtrl,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: secondary, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: onSurfaceVariant, size: 20),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: outline, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              if (auth.errorMessage != null || _localError != null) ...[
                Text(auth.errorMessage ?? _localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(height: 12),
              ],
              
              // Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    shadowColor: primary.withValues(alpha: 0.5),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Login', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: surface.withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed('role-selection');
          }
        },
      ),
      title: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildTab({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? surfaceContainerLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? primary : onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? primary : onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
