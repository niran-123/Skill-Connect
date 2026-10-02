import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_provider.dart';
import '../../providers/session_provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/professional.dart';
import '../../repositories/user_repo.dart';

class EditProProfileScreen extends StatefulWidget {
  const EditProProfileScreen({super.key});

  @override
  State<EditProProfileScreen> createState() => _EditProProfileScreenState();
}

class _EditProProfileScreenState extends State<EditProProfileScreen> {
  final TextEditingController _businessNameCtrl = TextEditingController();
  final TextEditingController _bioCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  
  String _selectedCategory = '❄️ AC Technician / AC Mechanic';
  String _selectedCity = 'Coimbatore';
  List<String> _selectedSkills = [];
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _categories = [
    '❄️ AC Technician / AC Mechanic', '🔧 Plumber', '⚡ Electrician', '🪚 Carpenter', '🎨 Painter',
    '🧱 Mason / Construction Worker', '🔩 Welder', '🛵 Two-Wheeler Mechanic', '🚗 Car Mechanic',
    '🧹 Cleaning / Housekeeping Professional', '🧰 Appliance Repair Technician', '🔑 Locksmith',
    '📱 Mobile Phone Technician', '🏠 Roofing / Waterproofing Worker', '🌿 Gardener / Landscaping Professional',
    '🧼 Car/Bike Washing Professional', '🪟 Glass & Aluminium Worker', '🛋️ Furniture Repair Technician',
    '🔧 RO Water Purifier Technician', '📺 TV & Electronics Repair Technician'
  ];

  final List<String> _tnDistricts = [
    'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Erode',
    'Thanjavur', 'Vellore', 'Dindigul', 'Thoothukudi', 'Tiruppur', 'Kanyakumari',
    'Sivaganga', 'Virudhunagar', 'Ramanathapuram', 'Cuddalore', 'Nagapattinam',
    'Karur', 'Namakkal'
  ];

  List<String> _getSubServices(String category) {
    if (category.contains('AC Technician')) return ['Split AC Installation', 'Window AC Service', 'Gas Refill', 'Compressor Repair'];
    if (category.contains('Plumber')) return ['Pipe Fitting', 'Leak Repair', 'Tank Cleaning', 'Tap & Shower Installation'];
    if (category.contains('Electrician')) return ['Wiring', 'Switchboard Repair', 'Fan Installation', 'Inverter Setup'];
    if (category.contains('Carpenter')) return ['Furniture Repair', 'Door/Window Fixing', 'Wood Polish', 'Modular Kitchen Setup'];
    if (category.contains('Painter')) return ['Interior Painting', 'Exterior Painting', 'Wall Putty', 'Texture Painting'];
    if (category.contains('Mason')) return ['Wall Construction', 'Floor Tiling', 'Plastering', 'Concrete Work'];
    if (category.contains('Welder')) return ['Arc Welding', 'Gate Repair', 'Grill Work', 'Fabrication'];
    if (category.contains('Two-Wheeler')) return ['General Service', 'Engine Work', 'Tyre Puncture', 'Oil Change'];
    if (category.contains('Car Mechanic')) return ['Engine Diagnostics', 'Brake Service', 'AC Service', 'Battery Replacement'];
    if (category.contains('Cleaning')) return ['Deep Cleaning', 'Sofa Cleaning', 'Bathroom Cleaning', 'Floor Scrubbing'];
    if (category.contains('Appliance')) return ['Washing Machine', 'Refrigerator', 'Microwave Repair', 'Water Heater'];
    if (category.contains('Locksmith')) return ['Door Lock Opening', 'Key Duplication', 'Digital Lock Setup', 'Safe Unlocking'];
    if (category.contains('Mobile Phone')) return ['Screen Replacement', 'Battery Change', 'Software Flashing', 'Water Damage Repair'];
    if (category.contains('Roofing')) return ['Waterproofing', 'Leak Fixing', 'Tile Roofing', 'Sheet Roofing'];
    if (category.contains('Gardener')) return ['Lawn Mowing', 'Plant Pruning', 'Landscaping', 'Pest Control'];
    if (category.contains('Car/Bike Washing')) return ['Foam Wash', 'Interior Vacuum', 'Polishing', 'Detailing'];
    if (category.contains('Glass & Aluminium')) return ['Window Partition', 'Door Installation', 'Glass Replacement', 'Sliding Windows'];
    if (category.contains('Furniture Repair')) return ['Sofa Repair', 'Chair Fixing', 'Bed Assembly', 'Upholstery Change'];
    if (category.contains('RO Water')) return ['Filter Change', 'Machine Installation', 'Pump Repair', 'AMC Service'];
    if (category.contains('TV & Electronics')) return ['LED TV Repair', 'Home Theater Setup', 'PCB Repair', 'Display Issue'];
    return ['General Service', 'Maintenance', 'Inspection', 'Consultation'];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pro = context.read<ProfessionalProvider>().professional;
      final user = context.read<SessionProvider>().userModel;
      
      if (pro != null) {
        _businessNameCtrl.text = pro.name;
        _bioCtrl.text = pro.bio ?? 'Certified professional.';
        
        if (_categories.contains(pro.category)) {
          _selectedCategory = pro.category;
        } else {
          _selectedCategory = _categories.first;
        }
        
        if (_tnDistricts.contains(pro.city)) {
          _selectedCity = pro.city;
        } else {
          _selectedCity = _tnDistricts.first;
        }
        
        _selectedSkills = List.from(pro.skills);
        
        final sched = pro.schedule;
        if (sched.containsKey('availableFrom')) {
           final parts = sched['availableFrom'].toString().split(':');
           if (parts.length >= 2) {
             _startTime = TimeOfDay(hour: int.tryParse(parts[0]) ?? 8, minute: int.tryParse(parts[1]) ?? 0);
           }
        }
        if (sched.containsKey('availableTo')) {
           final parts = sched['availableTo'].toString().split(':');
           if (parts.length >= 2) {
             _endTime = TimeOfDay(hour: int.tryParse(parts[0]) ?? 17, minute: int.tryParse(parts[1]) ?? 0);
           }
        }
      }
      
      if (user != null) {
        _phoneCtrl.text = user.phone ?? '';
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final proProvider = context.read<ProfessionalProvider>();
    final session = context.read<SessionProvider>();
    final pro = proProvider.professional;
    final user = session.userModel;

    if (pro == null || user == null) return;

    // Update User Phone
    if (_phoneCtrl.text.trim() != user.phone) {
       await UserRepo().updateUser(user.uid, {'phone': _phoneCtrl.text.trim()});
       await session.refreshUserModel();
    }

    // Update Pro
    final schedule = Map<String, dynamic>.from(pro.schedule);
    if (_startTime != null) {
       schedule['availableFrom'] = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
    }
    if (_endTime != null) {
       schedule['availableTo'] = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';
    }

    final updatedPro = ProfessionalModel(
       uid: pro.uid,
       name: _businessNameCtrl.text.trim(),
       category: _selectedCategory,
       city: _selectedCity,
       area: pro.area,
       bio: _bioCtrl.text.trim(),
       skills: _selectedSkills,
       schedule: schedule,
       // retain other fields
       lat: pro.lat, lng: pro.lng, serviceDescription: pro.serviceDescription,
       experienceYears: pro.experienceYears, serviceRadiusKm: pro.serviceRadiusKm,
       available: pro.available, verificationStatus: pro.verificationStatus,
       verificationNote: pro.verificationNote, certificates: pro.certificates,
       avatarThumb: pro.avatarThumb, stats: pro.stats, skillStats: pro.skillStats,
       searchTokens: pro.searchTokens, createdAt: pro.createdAt,
    );

    await proProvider.updateSettings(updatedPro);

    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
       context.pop();
    }
  }
  
  Future<void> _selectTime(bool isStart) async {
    final initialTime = isStart 
      ? (_startTime ?? const TimeOfDay(hour: 8, minute: 0)) 
      : (_endTime ?? const TimeOfDay(hour: 17, minute: 0));
      
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial, // Analog style clock
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

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    final user = session.userModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Pro Profile', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
        actions: [], // Removed top app bar save button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar Editor
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 96, height: 96,
                    decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(48)),
                    child: const Icon(LucideIcons.user, size: 48, color: Color(0xFF94A3B8)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFF1D4ED8), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(LucideIcons.camera, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Change Photo (Max 5MB)', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            const SizedBox(height: 24),

            // Basic Info
            _buildSection(
              title: 'Basic Professional Info',
              child: Column(
                children: [
                  _buildLockedInput('Full Name', user?.name ?? 'Unknown', true),
                  const SizedBox(height: 16),
                  _buildControllerInput('Trade Business Name', _businessNameCtrl),
                  const SizedBox(height: 16),
                  
                  // Category Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Primary Trade Category', style: TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedCategory,
                            icon: const Icon(LucideIcons.chevron_down, color: Color(0xFF64748B)),
                            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))))).toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() {
                                  _selectedCategory = v;
                                  _selectedSkills.clear(); // Reset skills on category change
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Location (City)', style: TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedCity,
                            icon: const Icon(LucideIcons.chevron_down, color: Color(0xFF64748B)),
                            items: _tnDistricts.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))))).toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() {
                                  _selectedCity = v;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildLockedInput('Professional Email', user?.email ?? 'N/A', true, isVerified: true),
                  const SizedBox(height: 16),
                  _buildControllerInput('Phone Number', _phoneCtrl, keyboardType: TextInputType.phone),
                ],
              ),
            ),

            // Bio
            _buildSection(
              title: 'Professional Bio',
              child: Stack(
                children: [
                  TextFormField(
                    controller: _bioCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),
                  const Positioned(
                    bottom: 8, right: 12,
                    child: Text('Max 300 chars', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ),
                ],
              ),
            ),

            // Skills & Services
            _buildSection(
              title: 'Select Sub-Services Offered',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tap to select/deselect services you offer:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _getSubServices(_selectedCategory).map((s) => _buildSkillChip(s, _selectedSkills.contains(s))).toList(),
                  ),
                ],
              ),
            ),

            // Hours (Analog Time Picker)
            _buildSection(
              title: 'Working Hours',
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Time', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 4),
                            Text(_startTime?.format(context) ?? '08:00 AM', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('End Time', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 4),
                            Text(_endTime?.format(context) ?? '05:00 PM', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(minimumSize: const Size(0, 48), foregroundColor: const Color(0xFF475569)),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0,
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildControllerInput(String label, TextEditingController controller, {IconData? icon, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, size: 18, color: const Color(0xFF64748B)) : null,
            filled: true, fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          ),
          style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildLockedInput(String label, String value, bool isLocked, {bool isVerified = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Row(
            children: [
              Expanded(child: Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF475569), fontWeight: FontWeight.w500))),
              if (isVerified) const Icon(LucideIcons.badge_check, color: Color(0xFF10B981), size: 18)
              else if (isLocked) const Icon(LucideIcons.lock, color: Color(0xFF94A3B8), size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label, bool isActive) {
    return GestureDetector(
      onTap: () => _toggleSkill(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFDBEAFE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFFCBD5E1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive) ...[
              const Icon(LucideIcons.check, size: 12, color: Color(0xFF1D4ED8)),
              const SizedBox(width: 4),
            ],
            Text(label, style: TextStyle(fontSize: 13, color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFF475569), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
