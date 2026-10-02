import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../repositories/user_repo.dart';
import '../../models/user_model.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _selectedCity;
  final List<String> _tnDistricts = [
    'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Erode',
    'Thanjavur', 'Vellore', 'Dindigul', 'Thoothukudi', 'Tiruppur', 'Kanyakumari',
    'Sivaganga', 'Virudhunagar', 'Ramanathapuram', 'Cuddalore', 'Nagapattinam',
    'Karur', 'Namakkal'
  ];
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _agreedToTerms = true;
  bool _isPasswordVisible = false;
  String? _localError;

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF191C1E);
  final Color onSurfaceVariant = const Color(0xFF434655);
  final Color outline = const Color(0xFF747686);

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String placeholder,
    required IconData prefixIcon,
    bool isPassword = false,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: onSurfaceVariant,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: outline.withValues(alpha: 0.5), fontSize: 14),
            prefixIcon: Icon(prefixIcon, color: outline),
            prefix: prefix,
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
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: outline,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String hint, IconData icon, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: 'Inter')),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: outline.withValues(alpha: 0.5), fontSize: 14)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: outline),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline.withValues(alpha: 0.3))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline.withValues(alpha: 0.3))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primary, width: 2)),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _handleSignup() async {
    setState(() => _localError = null);
    if (!_agreedToTerms) {
      setState(() => _localError = 'You must agree to the Terms and Conditions.');
      return;
    }
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmPassCtrl.text;
    final session = context.read<SessionProvider>();
    final bool isGoogleAuth = session.authUser != null;

    if (email.isEmpty || _nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || _selectedCity == null || (!isGoogleAuth && pass.isEmpty)) {
      setState(() => _localError = 'Please fill all required fields.');
      return;
    }
    if (!isGoogleAuth && pass != confirm) {
      setState(() => _localError = 'Passwords do not match.');
      return;
    }
    
    if (isGoogleAuth) {
      final userRepo = UserRepo();
      await userRepo.createUser(
        UserModel(
          uid: session.authUser!.uid,
          role: 'customer',
          name: _nameCtrl.text.trim(),
          email: session.authUser!.email ?? email,
          phone: _phoneCtrl.text.trim(),
          address: _selectedCity,
        ),
      );
      if (mounted) {
        await session.refreshUserModel();
      }
    } else {
      final auth = context.read<AuthProvider>();
      final cred = await auth.signUpWithEmail(email, pass);
      if (cred != null && cred.user != null) {
        final userRepo = UserRepo();
        await userRepo.createUser(
          UserModel(
            uid: cred.user!.uid,
            role: 'customer',
            name: _nameCtrl.text.trim(),
            email: email,
            phone: _phoneCtrl.text.trim(),
            address: _selectedCity,
          ),
        );
        if (mounted) {
          await session.refreshUserModel();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    final bool isGoogleAuth = session.authUser != null;
    final auth = context.watch<AuthProvider>();

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
          'Create Customer Account',
          style: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join SkillConnect to find and book certified local trade professionals',
                style: TextStyle(fontSize: 14, color: onSurfaceVariant, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameCtrl,
                labelText: 'Full Name',
                placeholder: 'e.g. Rahul Kumar',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailCtrl,
                labelText: 'Email Address',
                placeholder: 'e.g. rahul@example.com',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneCtrl,
                labelText: 'Phone Number',
                placeholder: '98765 43210',
                prefixIcon: Icons.phone_outlined,
                prefix: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'City / Location',
                'Select your city',
                Icons.location_city_outlined,
                _selectedCity,
                _tnDistricts,
                (val) => setState(() => _selectedCity = val),
              ),
              const SizedBox(height: 16),
              if (!isGoogleAuth) _buildTextField(
                controller: _passCtrl,
                labelText: 'Password',
                placeholder: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              if (!isGoogleAuth) const SizedBox(height: 4),
              if (!isGoogleAuth) Text('Password must be at least 8 characters', style: TextStyle(fontSize: 11, color: onSurfaceVariant, fontFamily: 'Inter')),
              if (!isGoogleAuth) const SizedBox(height: 6),
              if (!isGoogleAuth) // Password strength indicator
              if (!isGoogleAuth) Row(
                children: [
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
                ],
              ),
              if (!isGoogleAuth) const SizedBox(height: 16),
              if (!isGoogleAuth) _buildTextField(
                controller: _confirmPassCtrl,
                labelText: 'Confirm Password',
                placeholder: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      activeColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) {
                        setState(() {
                          _agreedToTerms = val ?? true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'I agree to the Terms and Conditions and Privacy Policy',
                      style: TextStyle(fontSize: 12, color: onSurfaceVariant, fontFamily: 'Inter'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (auth.errorMessage != null || _localError != null) ...[
                Text(auth.errorMessage ?? _localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: auth.isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Inter'),
                        ),
                ),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

