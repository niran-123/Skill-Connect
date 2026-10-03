import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../providers/session_provider.dart';
import '../../repositories/user_repo.dart';

class EditCustomerProfileScreen extends StatefulWidget {
  const EditCustomerProfileScreen({super.key});

  @override
  State<EditCustomerProfileScreen> createState() => _EditCustomerProfileScreenState();
}

class _EditCustomerProfileScreenState extends State<EditCustomerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _fullAddressController;
  String? _selectedCity;
  final List<String> _tnDistricts = [
    'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Erode',
    'Thanjavur', 'Vellore', 'Dindigul', 'Thoothukudi', 'Tiruppur', 'Kanyakumari',
    'Sivaganga', 'Virudhunagar', 'Ramanathapuram', 'Cuddalore', 'Nagapattinam',
    'Karur', 'Namakkal'
  ];
  bool _isLoading = false;
  File? _imageFile;
  final UserRepo _userRepo = UserRepo();

  @override
  void initState() {
    super.initState();
    final user = context.read<SessionProvider>().userModel;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _fullAddressController = TextEditingController(text: user?.fullAddress ?? '');
    _selectedCity = user?.address;
    if (_selectedCity != null && !_tnDistricts.contains(_selectedCity)) {
      _selectedCity = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fullAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    final user = context.read<SessionProvider>().userModel;
    if (user == null) return;
    
    try {
      String? avatarUrl = user.avatarThumb;
      
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('avatars/${user.uid}.jpg');
        await storageRef.putFile(_imageFile!);
        avatarUrl = await storageRef.getDownloadURL();
      }

      final updateData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _selectedCity ?? '',
        'fullAddress': _fullAddressController.text.trim(),
      };
      if (avatarUrl != null) {
        updateData['avatarThumb'] = avatarUrl;
      }

      await _userRepo.updateUser(user.uid, updateData);

      if (mounted) {
        await context.read<SessionProvider>().refreshUserModel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile changes saved successfully.')));
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().userModel;
    
    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    final Color outline = const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: _isLoading 
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: primary, strokeWidth: 2))
              : Text('Save', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200, 
                          radius: 48, 
                          backgroundImage: _imageFile != null 
                            ? FileImage(_imageFile!) as ImageProvider
                            : NetworkImage(user?.avatarThumb ?? 'https://via.placeholder.com/150'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: outline)),
                              child: Icon(Icons.camera_alt, color: onSurfaceVariant, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Upload JPG or PNG, max 5MB', style: TextStyle(fontSize: 11, color: onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Form Fields
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Full Name *', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildFieldLabel('Email Address *', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline)),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                          child: const Text('Verified', style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildFieldLabel('Mobile Phone Number *', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Used for SMS booking updates and technician arrival OTP', style: TextStyle(fontSize: 10, color: onSurfaceVariant)),
                    const SizedBox(height: 32),
                    
                    _buildFieldLabel('Default Service Address *', onSurface),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      hint: Text('Select your city', style: TextStyle(color: outline, fontSize: 14)),
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline)),
                      ),
                      items: _tnDistricts.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCity = val),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildFieldLabel('Full Address', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fullAddressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'e.g. 123 Main St, Apartment 4B',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: outline)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), side: BorderSide(color: outline), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text('Cancel', style: TextStyle(color: onSurfaceVariant, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(backgroundColor: primary, minimumSize: const Size(0, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Save Changes', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, Color color) {
    return Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color));
  }
}
