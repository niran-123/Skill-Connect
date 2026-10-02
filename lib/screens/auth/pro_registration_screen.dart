import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../repositories/user_repo.dart';
import '../../repositories/professional_repo.dart';
import '../../models/user_model.dart';
import '../../models/professional.dart';

class ProRegistrationScreen extends StatefulWidget {
  const ProRegistrationScreen({super.key});

  @override
  State<ProRegistrationScreen> createState() => _ProRegistrationScreenState();
}

class _ProRegistrationScreenState extends State<ProRegistrationScreen> {
  int _currentStep = 0; // 0, 1, 2
  final PageController _pageController = PageController();

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);
  final Color outline = const Color(0xFF747686);
  final Color inactiveColor = const Color(0xFFCBD5E1);

  // Step 1
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  
  // Step 2
  final _businessNameCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  String? _selectedCategory;
  String? _selectedCity;
  
  final List<String> _categories = [
    '❄️ AC Technician / AC Mechanic',
    '🔧 Plumber',
    '⚡ Electrician',
    '🪚 Carpenter',
    '🎨 Painter',
    '🧱 Mason / Construction Worker',
    '🔩 Welder',
    '🛵 Two-Wheeler Mechanic',
    '🚗 Car Mechanic',
    '🧹 Cleaning / Housekeeping Professional',
    '🧰 Appliance Repair Technician',
    '🔑 Locksmith',
    '📱 Mobile Phone Technician',
    '🏠 Roofing / Waterproofing Worker',
    '🌿 Gardener / Landscaping Professional',
    '🧼 Car/Bike Washing Professional',
    '🪟 Glass & Aluminium Worker',
    '🛋️ Furniture Repair Technician',
    '🔧 RO Water Purifier Technician',
    '📺 TV & Electronics Repair Technician'
  ];
  
  final List<String> _tnDistricts = [
    'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Erode',
    'Thanjavur', 'Vellore', 'Dindigul', 'Thoothukudi', 'Tiruppur', 'Kanyakumari',
    'Sivaganga', 'Virudhunagar', 'Ramanathapuram', 'Cuddalore', 'Nagapattinam',
    'Karur', 'Namakkal'
  ];

  // Step 3
  final _bioCtrl = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final List<bool> _availableDays = [true, true, true, true, true, true, false]; // M-Sun
  bool _agreedToTerms = false;
  
  String? _localError;

  void _nextStep() async {
    setState(() => _localError = null);
    
    final isGoogleAuth = context.read<SessionProvider>().authUser != null;
    if (_currentStep == 0) {
      if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || (!isGoogleAuth && _passCtrl.text.isEmpty)) {
        setState(() => _localError = 'Please fill all fields');
        return;
      }
      if (!isGoogleAuth && _passCtrl.text != _confirmPassCtrl.text) {
        setState(() => _localError = 'Passwords do not match');
        return;
      }
    } else if (_currentStep == 1) {
      if (_selectedCategory == null || _selectedCity == null) {
        setState(() => _localError = 'Category and City are required');
        return;
      }
    } else if (_currentStep == 2) {
      if (!_agreedToTerms) {
        setState(() => _localError = 'You must agree to the guidelines');
        return;
      }
      
      final session = context.read<SessionProvider>();
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
        
        await proRepo.createProfessional(ProfessionalModel(
          uid: uid,
          name: _nameCtrl.text.trim(),
          category: _selectedCategory ?? '',
          city: _selectedCity ?? '',
          area: '',
          bio: _bioCtrl.text.trim(),
          experienceYears: int.tryParse(_experienceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
          serviceRadiusKm: 15.0,
          skills: [],
          available: true,
          verificationStatus: 'unsubmitted',
        ));
        
        if (mounted) {
          await session.refreshUserModel();
        }
      }
      return;
    }

    if (_currentStep < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    setState(() => _localError = null);
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              _buildStepNode('1. Account', 0),
              _buildStepLine(0),
              _buildStepNode('2. Skills', 1),
              _buildStepLine(1),
              _buildStepNode('3. Verify', 2),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(
              _currentStep == 0 
                ? 'STEP 1 OF 3 • BASIC ACCOUNT' 
                : _currentStep == 1 
                  ? 'STEP 2 OF 3 • SKILLS & TRADE' 
                  : 'STEP 3 OF 3 • VERIFICATION & BIO',
              style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(String label, int stepIndex) {
    bool isActive = _currentStep == stepIndex;
    bool isCompleted = _currentStep > stepIndex;
    Color color = isActive || isCompleted ? primary : inactiveColor;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: isCompleted 
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : Center(child: Text('\${stepIndex + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isActive ? onSurface : onSurfaceVariant, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildStepLine(int index) {
    bool isCompleted = _currentStep > index;
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? primary : inactiveColor,
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder, IconData icon, TextEditingController controller, {bool isPassword = false, String suffix = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: 'Inter')),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: outline.withValues(alpha: 0.5), fontSize: 14),
            prefixIcon: Icon(icon, color: outline),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline.withValues(alpha: 0.3))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline.withValues(alpha: 0.3))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primary, width: 2)),
          ),
        ),
        if (suffix.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(suffix, style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
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

  Widget _buildTimePickerField(String label, IconData icon, TimeOfDay? time, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: 'Inter')),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: outline.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: outline),
                const SizedBox(width: 12),
                Text(
                  time != null ? time.format(context) : 'Select Time',
                  style: TextStyle(
                    color: time != null ? onSurface : outline.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMsg() {
    if (_localError == null && context.watch<AuthProvider>().errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(context.watch<AuthProvider>().errorMessage ?? _localError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }

  Widget _buildStep1() {
    final isGoogleAuth = context.watch<SessionProvider>().authUser != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create Your Pro Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface)),
          const SizedBox(height: 8),
          Text('Enter your personal contact details to start offering your trade services', style: TextStyle(fontSize: 14, color: onSurfaceVariant)),
          const SizedBox(height: 24),
          _buildTextField('Full Name', 'e.g. Arun Kumar', Icons.person_outline, _nameCtrl),
          const SizedBox(height: 16),
          _buildTextField('Professional Email', 'e.g. arun.electrician@example.com', Icons.mail_outline, _emailCtrl),
          const SizedBox(height: 16),
          _buildTextField('Phone Number', 'e.g. 98421 54321', Icons.phone_outlined, _phoneCtrl),
          const SizedBox(height: 16),
          if (!isGoogleAuth) _buildTextField('Password', '••••••••••••', Icons.lock_outline, _passCtrl, isPassword: true),
          if (!isGoogleAuth) const SizedBox(height: 4),
          if (!isGoogleAuth) Text('Password must be at least 8 characters', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
          if (!isGoogleAuth) const SizedBox(height: 16),
          if (!isGoogleAuth) _buildTextField('Confirm Password', '••••••••••••', Icons.lock_outline, _confirmPassCtrl, isPassword: true),
          const SizedBox(height: 32),
          _buildErrorMsg(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Next: Skill Details →', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => context.goNamed('login'),
              child: Text('Already registered as a pro? Login here', style: TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(radius: 40, backgroundColor: primary.withValues(alpha: 0.1), child: Icon(Icons.camera_alt, color: primary, size: 32)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField('Trade Name / Business Name', 'e.g. Arun Electrical Works', Icons.business_center_outlined, _businessNameCtrl),
          const SizedBox(height: 16),
          _buildTextField('Years of Experience', 'e.g. 6', Icons.history, _experienceCtrl),
          const SizedBox(height: 16),
          _buildDropdown('Primary Service Category', 'Select Category', Icons.category_outlined, _selectedCategory, _categories, (val) => setState(() => _selectedCategory = val)),
          const SizedBox(height: 16),
          _buildDropdown('City', 'Select City', Icons.location_city_outlined, _selectedCity, _tnDistricts, (val) => setState(() => _selectedCity = val)),
          const SizedBox(height: 32),
          _buildErrorMsg(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(0, 48)),
                  child: const Text('Back', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(0, 48)),
                  child: const Text('Next: Verification →', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Short Professional Bio', 'e.g. Certified master electrician...', Icons.edit_note, _bioCtrl),
          Align(alignment: Alignment.centerRight, child: Text('\${_bioCtrl.text.length}/300 chars', style: TextStyle(fontSize: 10, color: onSurfaceVariant))),
          const SizedBox(height: 16),
          Text('Available Days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].asMap().entries.map((entry) {
              bool isSelected = _availableDays[entry.key];
              return GestureDetector(
                onTap: () => setState(() => _availableDays[entry.key] = !_availableDays[entry.key]),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: isSelected ? primary : Colors.white, border: Border.all(color: isSelected ? primary : outline.withValues(alpha: 0.3)), shape: BoxShape.circle),
                  child: Center(child: Text(entry.value, style: TextStyle(color: isSelected ? Colors.white : onSurfaceVariant, fontWeight: FontWeight.bold))),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTimePickerField('Start Time', Icons.access_time, _startTime, () => _selectTime(context, true))),
              const SizedBox(width: 16),
              Expanded(child: _buildTimePickerField('End Time', Icons.access_time, _endTime, () => _selectTime(context, false))),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(value: _agreedToTerms, activeColor: primary, onChanged: (v) => setState(() => _agreedToTerms = v ?? false)),
              const Expanded(child: Text('I agree to SkillConnect Pro Guidelines and Service Standards', style: TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 24),
          _buildErrorMsg(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(0, 48)),
                  child: const Text('Back', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: context.watch<AuthProvider>().isLoading ? null : _nextStep,
                  style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(0, 48)),
                  child: context.watch<AuthProvider>().isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Create Account', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
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
        leading: IconButton(icon: Icon(Icons.arrow_back, color: onSurface), onPressed: _prevStep),
        title: Text('Pro Registration', style: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
