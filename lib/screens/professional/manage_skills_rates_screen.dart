import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_provider.dart';
import 'package:go_router/go_router.dart';

class ManageSkillsRatesScreen extends StatelessWidget {
  const ManageSkillsRatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proProvider = context.watch<ProfessionalProvider>();
    final pro = proProvider.professional;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: const Text('Skills & Services', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Summary card
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(LucideIcons.zap, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Primary Trade: ${pro?.category ?? 'Master'}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                              child: const Text('Verified', style: TextStyle(color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 8),
                            Text('${pro?.skills.length ?? 0} Active Services Offered', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Search bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Container(
                height: 44,
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(LucideIcons.search, color: Color(0xFF64748B), size: 20),
                    border: InputBorder.none,
                    hintText: 'Search service or add custom skill...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            
            // Categories
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Skills', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  if (pro != null) ...pro.skills.map((s) => _buildServiceItem(s, '₹199 / unit', true, exp: '${pro.experienceYears}+ yrs')),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.plus, size: 18),
                    label: const Text('Add New Custom Skill'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D4ED8),
                      side: const BorderSide(color: Color(0xFFCBD5E1), style: BorderStyle.solid),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('e.g. Solar panel connection, EV home charger point', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ),
                ],
              ),
            ),

            // Callout charge config
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inspection & Callout Charges', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 16),
                  _buildChargeInput('First-time emergency callout fee', '₹249'),
                  const SizedBox(height: 12),
                  _buildChargeInput('Standard hourly diagnostic labor', '₹150 / hr'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: const [
                        Icon(LucideIcons.info, size: 16, color: Color(0xFFDC2626)),
                        SizedBox(width: 8),
                        Expanded(child: Text('100% of customer payment is retained by Pro (0% platform commission).', style: TextStyle(color: Color(0xFF991B1B), fontSize: 12))),
                      ],
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
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0,
          ),
          child: const Text('Save Service Rates', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildServiceItem(String title, String rate, bool isOn, {String? exp}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOn ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOn ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isOn ? const Color(0xFF0F172A) : const Color(0xFF94A3B8))),
                    if (exp != null) ...[
                      const SizedBox(height: 4),
                      Text('Experience: $exp', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ]
                  ],
                ),
              ),
              Switch(value: isOn, onChanged: (v) {}, activeThumbColor: Colors.white, activeTrackColor: const Color(0xFF10B981)),
            ],
          ),
          if (isOn) ...[
            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: Color(0xFFE2E8F0))),
            Row(
              children: [
                const Text('Base Rate: ', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                Expanded(
                  child: TextFormField(
                    initialValue: rate,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(LucideIcons.pencil, size: 14, color: Color(0xFF94A3B8)),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildChargeInput(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 13))),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: TextFormField(
            initialValue: value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
