import os

def main():
    filepath = 'd:/MAD/Skill-connect/lib/screens/auth/signup_screen.dart'
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Hide password fields in UI if already logged in via Google
    content = content.replace(
        "Widget build(BuildContext context) {",
        "Widget build(BuildContext context) {\n    final session = context.watch<SessionProvider>();\n    final bool isGoogleAuth = session.authUser != null;"
    )
    
    # Hide the password field
    content = content.replace(
        "              _buildTextField(\n                controller: _passCtrl,",
        "              if (!isGoogleAuth) _buildTextField(\n                controller: _passCtrl,"
    )
    content = content.replace(
        "              const SizedBox(height: 6),\n              // Password strength indicator",
        "              if (!isGoogleAuth) const SizedBox(height: 6),\n              if (!isGoogleAuth) // Password strength indicator"
    )
    content = content.replace(
        "              Row(\n                children: [\n                  Expanded(child: Container",
        "              if (!isGoogleAuth) Row(\n                children: [\n                  Expanded(child: Container"
    )
    content = content.replace(
        "                ],\n              ),\n              const SizedBox(height: 16),\n              _buildTextField(\n                controller: _confirmPassCtrl,",
        "                ],\n              ),\n              if (!isGoogleAuth) const SizedBox(height: 16),\n              if (!isGoogleAuth) _buildTextField(\n                controller: _confirmPassCtrl,"
    )

    # 2. Update logic
    old_logic = """    if (email.isEmpty || pass.isEmpty || _nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
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
    }"""
    
    new_logic = """    final session = context.read<SessionProvider>();
    final bool isGoogleAuth = session.authUser != null;

    if (email.isEmpty || _nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || (!isGoogleAuth && pass.isEmpty)) {
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
          ),
        );
        if (mounted) {
          await session.refreshUserModel();
        }
      }
    }"""
    
    content = content.replace(old_logic, new_logic)

    # Make sure text fields display email if google auth is already there
    # It's okay to just leave it empty if the user wants to enter it.
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
        
if __name__ == '__main__':
    main()
