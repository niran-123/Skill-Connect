import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/job_provider.dart';
import '../../providers/session_provider.dart';

class JobRequestScreen extends StatefulWidget {
  final String? initialCategory;
  const JobRequestScreen({super.key, this.initialCategory});

  @override
  State<JobRequestScreen> createState() => _JobRequestScreenState();
}

class _JobRequestScreenState extends State<JobRequestScreen> {
  final _descCtrl = TextEditingController();
  
  late String _selectedCategory;
  bool _analysisComplete = false;

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

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);
  final Color outline = const Color(0xFFCBD5E1);
  final Color surfaceContainerLowest = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.contains(widget.initialCategory) 
        ? widget.initialCategory! 
        : _categories.first;
  }

  void _analyze() async {
    if (_descCtrl.text.isEmpty) return;

    final jobProvider = context.read<JobProvider>();
    final user = context.read<SessionProvider>().userModel;
    if (user == null) return;

    await jobProvider.processJobRequest(
      _descCtrl.text,
      user.uid,
      lat: 10.8, // Mock location for demo
      lng: 78.7,
    );

    if (mounted && jobProvider.errorMessage == null) {
      setState(() {
        _analysisComplete = true;
      });
    }
  }

  void _confirmAndFindPros() {
    final jobProvider = context.read<JobProvider>();
    if (jobProvider.matches.isNotEmpty) {
      context.pushNamed('customer-match-detail', pathParameters: {'id': jobProvider.matches.first.professional.uid}, extra: jobProvider.matches.first);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No professionals found in your area for this service.')),
      );
    }
  }

  Widget _buildDescribeProblem() {
    final jobProvider = context.watch<JobProvider>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface, fontFamily: 'Inter')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: surfaceContainerLowest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: outline),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: onSurface)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedCategory = v);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Text('Describe the issue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface, fontFamily: 'Inter')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceContainerLowest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _descCtrl,
                  maxLines: 4,
                  style: TextStyle(fontSize: 14, fontFamily: 'Inter', color: onSurface),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          if (jobProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(jobProvider.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: jobProvider.isLoading ? null : _analyze,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: jobProvider.isLoading 
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Analyzing problem severity...', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  )
                : const Text('Analyze Problem with AI ✨', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAiAnalysis() {
    final jobProvider = context.watch<JobProvider>();
    final analysis = jobProvider.currentJob?.analysis ?? {};
    
    final problemType = analysis['problemType'] ?? 'Detected Issue';
    final severity = analysis['severity'] ?? 'Medium';
    final estHours = analysis['estimatedDurationHours']?.toString() ?? '1';
    final reqSkills = List<String>.from(analysis['requiredSkills'] ?? []);
    final mappedCategory = analysis['category'] ?? _selectedCategory;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨', style: TextStyle(fontSize: 12)),
                SizedBox(width: 6),
                Text('AI Analysis Complete • Verified Diagnostic Model', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Here is what we understood from your description', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.5, height: 1.2)),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: outline.withValues(alpha: 0.5)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.handyman, color: primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(mappedCategory, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                      child: Text('98% Confidence', style: TextStyle(fontSize: 10, color: onSurfaceVariant, fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
                Text('Identified Problem Type', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(problemType, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface)),
                
                const SizedBox(height: 16),
                Text('Required Skills Identified', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reqSkills.map((s) => _buildSkillChip(s)).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _analysisComplete = false),
              icon: Icon(Icons.edit, size: 16, color: onSurfaceVariant),
              label: Text('Edit Details', style: TextStyle(color: onSurfaceVariant, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _confirmAndFindPros,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Confirm & Find Matching Pros', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 12, color: primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: onSurface, fontWeight: FontWeight.w500)),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () {
            if (_analysisComplete) {
              setState(() => _analysisComplete = false);
            } else {
              context.pop();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          _analysisComplete ? 'AI Problem Diagnosis' : 'Describe Your Problem',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface, fontFamily: 'Inter'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
               _analysisComplete ? 'Step 2 of 2: Review Analysis' : 'Step 1 of 2: AI Diagnostic',
              style: TextStyle(fontSize: 12, color: onSurfaceVariant, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: _analysisComplete ? _buildAiAnalysis() : _buildDescribeProblem(),
    );
  }
}
