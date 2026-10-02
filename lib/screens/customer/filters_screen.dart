import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  double _distance = 10;
  bool _verifiedOnly = true;
  String _selectedCategory = 'Electrician';
  final List<String> _selectedSkills = ['House Wiring', 'MCB Repair'];
  String _minExp = '5+ Years';
  String _minRating = '4.5+ ★';
  final List<String> _availability = ['Available Today'];
  String _chargeRange = 'Standard Rates';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1D4ED8),
              textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Service Category'),
            _buildHorizontalScrollChips(
              ['All', 'Electrician', 'Plumber', 'AC Repair', 'Carpentry', 'Painting', 'Cleaning'],
              selected: _selectedCategory,
              onSelect: (val) => setState(() => _selectedCategory = val),
            ),
            _buildDivider(),

            _buildSectionTitle('Specialized Skills'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: ['House Wiring', 'MCB Repair', 'Appliance Repair', 'Inverter', 'Fan Installation']
                    .map((skill) => _buildMultiSelectChip(
                          skill,
                          isSelected: _selectedSkills.contains(skill),
                          onToggle: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSkills.add(skill);
                              } else {
                                _selectedSkills.remove(skill);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            _buildDivider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Distance Radius', padding: EdgeInsets.zero),
                  Text(
                    'Within ${_distance.toInt()} km',
                    style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF1D4ED8),
                inactiveTrackColor: const Color(0xFFE2E8F0),
                thumbColor: Colors.white,
                overlayColor: const Color(0x331D4ED8),
                valueIndicatorTextStyle: const TextStyle(color: Colors.white),
              ),
              child: Slider(
                value: _distance,
                min: 1,
                max: 30,
                divisions: 29,
                label: '${_distance.toInt()} km',
                onChanged: (val) => setState(() => _distance = val),
              ),
            ),
            _buildDivider(),

            _buildSectionTitle('Minimum Experience'),
            _buildHorizontalScrollChips(
              ['Any', '3+ Years', '5+ Years', '8+ Years'],
              selected: _minExp,
              onSelect: (val) => setState(() => _minExp = val),
            ),
            _buildDivider(),

            _buildSectionTitle('Minimum Customer Rating'),
            _buildHorizontalScrollChips(
              ['Any', '4.0+ ★', '4.5+ ★', '4.8+ ★'],
              selected: _minRating,
              onSelect: (val) => setState(() => _minRating = val),
            ),
            _buildDivider(),

            _buildSectionTitle('Availability'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: ['Available Today', 'Available within 2 hours', 'Weekend Available']
                    .map((time) => _buildMultiSelectChip(
                          time,
                          isSelected: _availability.contains(time),
                          onToggle: (selected) {
                            setState(() {
                              if (selected) {
                                _availability.add(time);
                              } else {
                                _availability.remove(time);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            _buildDivider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.shield_check, color: Color(0xFF10B981), size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Verified Professionals Only',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _verifiedOnly,
                    onChanged: (val) => setState(() => _verifiedOnly = val),
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF1D4ED8),
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                    inactiveThumbColor: Colors.white,
                  ),
                ],
              ),
            ),
            _buildDivider(),

            _buildSectionTitle('Service Charge Range'),
            _buildHorizontalScrollChips(
              ['Budget Friendly', 'Standard Rates', 'Any'],
              selected: _chargeRange,
              onSelect: (val) => setState(() => _chargeRange = val),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Apply Filters (14 Pros Found)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(16, 0, 16, 12)}) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
    );
  }

  Widget _buildHorizontalScrollChips(List<String> options, {required String selected, required Function(String) onSelect}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFDBEAFE) : Colors.white,
                  border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultiSelectChip(String label, {required bool isSelected, required Function(bool) onToggle}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onToggle,
      showCheckmark: true,
      checkmarkColor: const Color(0xFF1D4ED8),
      selectedColor: const Color(0xFFDBEAFE),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    );
  }
}
