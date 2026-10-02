import os

def main():
    filepath = 'd:/MAD/Skill-connect/lib/screens/auth/pro_registration_screen.dart'
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    content = content.replace(
        "  Widget _buildStep1() {",
        "  Widget _buildStep1() {\n    final isGoogleAuth = context.watch<SessionProvider>().authUser != null;"
    )

    # Hide password fields
    content = content.replace(
        "          _buildTextField('Password', '••••••••••••', Icons.lock_outline, _passCtrl, isPassword: true, suffix: 'Strong'),\n          const SizedBox(height: 16),\n          _buildTextField('Confirm Password', '••••••••••••', Icons.lock_outline, _confirmPassCtrl, isPassword: true),",
        "          if (!isGoogleAuth) _buildTextField('Password', '••••••••••••', Icons.lock_outline, _passCtrl, isPassword: true, suffix: 'Strong'),\n          if (!isGoogleAuth) const SizedBox(height: 16),\n          if (!isGoogleAuth) _buildTextField('Confirm Password', '••••••••••••', Icons.lock_outline, _confirmPassCtrl, isPassword: true),"
    )

    # Update logic
    old_logic = """    if (_currentStep == 0) {
      if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
        setState(() => _localError = 'Please fill all fields');
        return;
      }
      if (_passCtrl.text != _confirmPassCtrl.text) {
        setState(() => _localError = 'Passwords do not match');
        return;
      }
    }"""
    
    new_logic = """    final isGoogleAuth = context.read<SessionProvider>().authUser != null;
    if (_currentStep == 0) {
      if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || (!isGoogleAuth && _passCtrl.text.isEmpty)) {
        setState(() => _localError = 'Please fill all fields');
        return;
      }
      if (!isGoogleAuth && _passCtrl.text != _confirmPassCtrl.text) {
        setState(() => _localError = 'Passwords do not match');
        return;
      }
    }"""
    
    content = content.replace(old_logic, new_logic)

    old_logic_2 = """      final auth = context.read<AuthProvider>();
      final cred = await auth.signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
      if (cred != null && cred.user != null) {
        final uid = cred.user!.uid;
        final userRepo = UserRepo();
        final proRepo = ProfessionalRepo();
        
        await userRepo.createUser(UserModel(
          uid: uid,
          role: 'professional',
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        ));
        
        final cityParts = _cityAreaCtrl.text.split('—');
        final city = cityParts.isNotEmpty ? cityParts[0].trim() : _cityAreaCtrl.text;
        final area = cityParts.length > 1 ? cityParts[1].trim() : _cityAreaCtrl.text;
        
        await proRepo.createProfessional(ProfessionalModel(
          uid: uid,
          name: _nameCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          city: city,
          area: area,
          bio: _bioCtrl.text.trim(),
          experienceYears: int.tryParse(_experienceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
          serviceRadiusKm: double.tryParse(_radiusCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 15.0,
          skills: _selectedSkills.toList(),
          available: true,
          verificationStatus: 'unsubmitted',
        ));
        
        if (mounted) {
          await context.read<SessionProvider>().refreshUserModel();
          // Router handles redirect
        }
      }"""
      
    new_logic_2 = """      final session = context.read<SessionProvider>();
      String? uid;
      if (isGoogleAuth) {
        uid = session.authUser!.uid;
      } else {
        final auth = context.read<AuthProvider>();
        final cred = await auth.signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
        uid = cred?.user?.uid;
      }
      
      if (uid != null) {
        final userRepo = UserRepo();
        final proRepo = ProfessionalRepo();
        
        await userRepo.createUser(UserModel(
          uid: uid,
          role: 'professional',
          name: _nameCtrl.text.trim(),
          email: isGoogleAuth ? (session.authUser!.email ?? _emailCtrl.text.trim()) : _emailCtrl.text.trim(),
        ));
        
        final cityParts = _cityAreaCtrl.text.split('—');
        final city = cityParts.isNotEmpty ? cityParts[0].trim() : _cityAreaCtrl.text;
        final area = cityParts.length > 1 ? cityParts[1].trim() : _cityAreaCtrl.text;
        
        await proRepo.createProfessional(ProfessionalModel(
          uid: uid,
          name: _nameCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          city: city,
          area: area,
          bio: _bioCtrl.text.trim(),
          experienceYears: int.tryParse(_experienceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
          serviceRadiusKm: double.tryParse(_radiusCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 15.0,
          skills: _selectedSkills.toList(),
          available: true,
          verificationStatus: 'unsubmitted',
        ));
        
        if (mounted) {
          await session.refreshUserModel();
        }
      }"""
      
    content = content.replace(old_logic_2, new_logic_2)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == '__main__':
    main()
