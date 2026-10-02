import os

def update_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    for old, new in replacements:
        content = content.replace(old, new)
        
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")
    else:
        print(f"No changes made to {filepath}")

def main():
    base = 'd:/MAD/Skill-connect/lib/screens/auth'
    
    # 1. login_screen.dart
    login = os.path.join(base, 'login_screen.dart')
    update_file(login, [
        (
            "  bool _isPasswordVisible = false;",
            "  bool _isPasswordVisible = false;\n  String? _localError;"
        ),
        (
            "  @override\n  Widget build(BuildContext context) {",
            """  Future<void> _handleLogin() async {
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
  Widget build(BuildContext context) {"""
        ),
        (
            "if (auth.errorMessage != null) ...[",
            "if (auth.errorMessage != null || _localError != null) ...["
        ),
        (
            "Text(auth.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),",
            "Text(auth.errorMessage ?? _localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),"
        ),
        (
            "onPressed: auth.isLoading ? null : () => auth.signInWithEmail(_emailCtrl.text, _passCtrl.text),",
            "onPressed: auth.isLoading ? null : _handleLogin,"
        )
    ])
    
    # 2. signup_screen.dart
    signup = os.path.join(base, 'signup_screen.dart')
    update_file(signup, [
        (
            "  bool _isPasswordVisible = false;",
            "  bool _isPasswordVisible = false;\n  String? _localError;"
        ),
        (
            "  @override\n  Widget build(BuildContext context) {",
            """  Future<void> _handleSignup() async {
    setState(() => _localError = null);
    if (!_agreedToTerms) {
      setState(() => _localError = 'You must agree to the Terms and Conditions.');
      return;
    }
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmPassCtrl.text;
    if (email.isEmpty || pass.isEmpty || _nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      setState(() => _localError = 'Please fill all required fields.');
      return;
    }
    if (pass != confirm) {
      setState(() => _localError = 'Passwords do not match.');
      return;
    }
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
        ),
      );
      if (mounted) {
        await context.read<SessionProvider>().refreshUserModel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {"""
        ),
        (
            "if (auth.errorMessage != null) ...[",
            "if (auth.errorMessage != null || _localError != null) ...["
        ),
        (
            "Text(auth.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),",
            "Text(auth.errorMessage ?? _localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),"
        ),
        (
            """onPressed: auth.isLoading
                      ? null
                      : () async {
                          final cred = await auth.signUpWithEmail(_emailCtrl.text, _passCtrl.text);
                          if (cred != null && cred.user != null) {
                            final userRepo = UserRepo();
                            await userRepo.createUser(
                              UserModel(
                                uid: cred.user!.uid,
                                role: 'customer',
                                name: _nameCtrl.text.isEmpty ? 'New Customer' : _nameCtrl.text,
                                email: _emailCtrl.text,
                              ),
                            );
                            if (mounted) {
                              await context.read<SessionProvider>().refreshUserModel();
                            }
                          }
                        },""",
            """onPressed: auth.isLoading ? null : _handleSignup,"""
        )
    ])
    
    # 3. forgot_password_screen.dart
    forgot = os.path.join(base, 'forgot_password_screen.dart')
    update_file(forgot, [
        (
            "import 'package:go_router/go_router.dart';",
            "import 'package:go_router/go_router.dart';\nimport 'package:provider/provider.dart';\nimport '../../providers/auth_provider.dart';"
        ),
        (
            "  bool _isSent = false;",
            "  bool _isSent = false;\n  String? _localError;"
        ),
        (
            "  @override\n  Widget build(BuildContext context) {",
            """  Future<void> _handleReset() async {
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
  Widget build(BuildContext context) {"""
        ),
        (
            """                  onPressed: () {
                    setState(() {
                      _isSent = true;
                    });
                  },""",
            """                  onPressed: context.watch<AuthProvider>().isLoading ? null : _handleReset,"""
        ),
        (
            "// Submit Button",
            "if (context.watch<AuthProvider>().errorMessage != null) Text(context.watch<AuthProvider>().errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),\n              if (_localError != null) Text(_localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),\n              const SizedBox(height: 8),\n              // Submit Button"
        )
    ])

if __name__ == '__main__':
    main()
