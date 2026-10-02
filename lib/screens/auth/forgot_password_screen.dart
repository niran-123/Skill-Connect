import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController(text: 'rahul.kumar@example.com');
  bool _isSent = false;
  String? _localError;

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);
  final Color outline = const Color(0xFF747686);

  Future<void> _handleReset() async {
    setState(() => _localError = null);
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _localError = 'Please enter a valid email address.');
      return;
    }
    final auth = context.read<AuthProvider>();
    await auth.sendPasswordReset(email);
    if (auth.errorMessage == null) {
      setState(() => _isSent = true);
    }
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_outline, color: primary, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email address and we\'ll send you a secure link to reset your password.',
                style: TextStyle(fontSize: 14, color: onSurfaceVariant, height: 1.5, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 32),
              // Email Input
              Text(
                'Email Address',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: outline),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: outline.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: outline.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (context.watch<AuthProvider>().errorMessage != null) Text(context.watch<AuthProvider>().errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              if (_localError != null) Text(_localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 8),
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: context.watch<AuthProvider>().isLoading ? null : _handleReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Send Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Inter')),
                ),
              ),
              const SizedBox(height: 24),
              // Success Notification
              if (_isSent)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Password reset link sent successfully! Check your inbox for instructions to reset your password.',
                              style: TextStyle(fontSize: 13, color: Colors.green.shade800, fontFamily: 'Inter'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Didn\'t receive email? Resend in 45s',
                        style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              // Footer
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
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
