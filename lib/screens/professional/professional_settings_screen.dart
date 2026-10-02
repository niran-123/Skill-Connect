import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_provider.dart';
import '../../models/professional.dart';

class ProfessionalSettingsScreen extends StatefulWidget {
  const ProfessionalSettingsScreen({super.key});

  @override
  State<ProfessionalSettingsScreen> createState() => _ProfessionalSettingsScreenState();
}

class _ProfessionalSettingsScreenState extends State<ProfessionalSettingsScreen> {
  final _skillsCtrl = TextEditingController();
  final _radiusCtrl = TextEditingController();
  bool _available = true;

  @override
  void initState() {
    super.initState();
    final pro = context.read<ProfessionalProvider>().professional;
    if (pro != null) {
      _skillsCtrl.text = pro.skills.join(', ');
      _radiusCtrl.text = pro.serviceRadiusKm.toString();
      _available = pro.available;
    }
  }

  void _save() {
    final provider = context.read<ProfessionalProvider>();
    final pro = provider.professional;
    if (pro == null) return;

    final updated = ProfessionalModel(
      uid: pro.uid,
      name: pro.name,
      category: pro.category,
      city: pro.city,
      area: pro.area,
      lat: pro.lat,
      lng: pro.lng,
      bio: pro.bio,
      experienceYears: pro.experienceYears,
      serviceRadiusKm: double.tryParse(_radiusCtrl.text) ?? 15.0,
      skills: _skillsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      available: _available,
      verificationStatus: pro.verificationStatus,
      certificates: pro.certificates,
      stats: pro.stats,
    );

    provider.updateSettings(updated).then((_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Available for jobs'),
            value: _available,
            onChanged: (val) => setState(() => _available = val),
          ),
          TextField(
            controller: _radiusCtrl,
            decoration: const InputDecoration(labelText: 'Service Radius (km)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _skillsCtrl,
            decoration: const InputDecoration(
              labelText: 'Skills (comma separated)',
              hintText: 'e.g., plumbing, pipe fitting, leak repair',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Certificate (Simulated)'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Certificate uploaded (simulated)')));
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save Settings'),
          )
        ],
      ),
    );
  }
}
