import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/booking.dart';
import '../../models/professional.dart';
import '../../providers/professional_provider.dart';
import '../../providers/session_provider.dart';
import '../../core/booking_status.dart';

class ProfessionalDashboard extends StatefulWidget {
  const ProfessionalDashboard({super.key});

  @override
  State<ProfessionalDashboard> createState() => _ProfessionalDashboardState();
}

class _ProfessionalDashboardState extends State<ProfessionalDashboard> {
  bool? _isAvailable;

  final Color primary = const Color(0xFF1D4ED8);
  final Color surface = const Color(0xFFF7F9FB);
  final Color onSurface = const Color(0xFF0F172A);
  final Color onSurfaceVariant = const Color(0xFF64748B);
  final Color badgeBlue = const Color(0xFFDBEAFE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = context.read<SessionProvider>();
      if (session.userModel != null) {
        context.read<ProfessionalProvider>().loadDashboard(session.userModel!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final proProvider = context.watch<ProfessionalProvider>();


    final pendingCount = proProvider.bookings.where((b) => b.status == BookingStatus.requestCreated).length;
    final activeCount = proProvider.bookings.where((b) => [BookingStatus.customerConfirmed, BookingStatus.professionalArrived, BookingStatus.jobStarted].contains(b.status)).length;
    final completedCount = proProvider.bookings.where((b) => b.status == BookingStatus.jobCompleted).length;
    final cancelledCount = proProvider.bookings.where((b) => b.status == BookingStatus.cancelled).length;
    

    
    final activeJob = proProvider.bookings.firstWhere(
      (b) => [BookingStatus.customerConfirmed, BookingStatus.professionalArrived, BookingStatus.jobStarted].contains(b.status),
      orElse: () => BookingModel(id: '', jobId: '', customerId: '', professionalId: '', customerName: '', professionalName: '', jobSnapshot: {}, match: {}),
    );

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        title: Text('SkillConnect Pro', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Inter')),
        actions: [],
      ),
      body: SafeArea(
        child: proProvider.isLoading
            ? Center(child: CircularProgressIndicator(color: primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting & Availability Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Good Morning, ${proProvider.professional?.name.split(' ').first ?? 'Professional'} 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                      const SizedBox(width: 6),
                                      Text('${proProvider.professional?.area ?? 'Area'}, ${proProvider.professional?.city ?? 'City'}', style: TextStyle(fontSize: 13, color: onSurfaceVariant, fontFamily: 'Inter')),
                                    ],
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: badgeBlue,
                                child: Text((proProvider.professional?.name.isNotEmpty == true) ? proProvider.professional!.name[0].toUpperCase() : 'P', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 20)),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Available for Jobs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: (_isAvailable ?? proProvider.professional?.available ?? true) ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                        child: Text((_isAvailable ?? proProvider.professional?.available ?? true) ? 'Online • Receiving Requests' : 'Offline • Not visible', style: TextStyle(color: (_isAvailable ?? proProvider.professional?.available ?? true) ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isAvailable ?? proProvider.professional?.available ?? true,
                                activeThumbColor: Colors.white,
                                activeTrackColor: Colors.green,
                                onChanged: (val) async {
                                  setState(() {
                                    _isAvailable = val;
                                  });
                                  final pro = proProvider.professional;
                                  if (pro != null) {
                                    final updatedPro = ProfessionalModel(
                                      uid: pro.uid, name: pro.name, category: pro.category, city: pro.city, area: pro.area,
                                      lat: pro.lat, lng: pro.lng, bio: pro.bio, serviceDescription: pro.serviceDescription,
                                      experienceYears: pro.experienceYears, serviceRadiusKm: pro.serviceRadiusKm,
                                      skills: pro.skills, available: val, schedule: pro.schedule,
                                      verificationStatus: pro.verificationStatus, verificationNote: pro.verificationNote,
                                      certificates: pro.certificates, avatarThumb: pro.avatarThumb,
                                      stats: pro.stats, skillStats: pro.skillStats, searchTokens: pro.searchTokens,
                                      createdAt: pro.createdAt,
                                    );
                                    await proProvider.updateSettings(updatedPro);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('You are visible to nearby customers within 15 km', style: TextStyle(fontSize: 11, color: onSurfaceVariant, fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: _buildMetricCard('Active', '$activeCount', badge: activeCount > 0 ? 'In Progress' : 'Idle', badgeColor: Colors.orange)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetricCard('Completed', '$completedCount', badge: 'Done', badgeColor: Colors.green)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetricCard('Cancelled', '$cancelledCount', badge: 'Cancelled', badgeColor: Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Active Job Banner
                    if (activeJob.id.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: badgeBlue.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: primary.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.directions_car, color: primary, size: 20),
                                const SizedBox(width: 8),
                                const Text('Current Active Job', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(activeJob.jobSnapshot['analysis']?['category'] ?? 'Service Job', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                            const SizedBox(height: 4),
                            Text('for ${activeJob.customerName} • Status: ${activeJob.status}', style: TextStyle(fontSize: 13, color: onSurfaceVariant, fontFamily: 'Inter')),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pushNamed('job-execution', extra: activeJob);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('Open Active Job Tracker →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (activeJob.id.isNotEmpty)
                      const SizedBox(height: 24),

                    // New Requests
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('New Service Requests ($pendingCount)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface, fontFamily: 'Inter')),
                        GestureDetector(
                          onTap: () => context.pushNamed('service-requests'),
                          child: Text('View All', style: TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...proProvider.bookings.where((b) => b.status == BookingStatus.requestCreated).take(3).map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildRequestCard(
                        b.customerName,
                        b.jobSnapshot['analysis']?['category'] ?? 'Service Request',
                        b.jobSnapshot['description'] ?? '',
                        'New',
                        'Now',
                        'N/A',
                        '₹250 - ₹500',
                      ),
                    )),
                    if (pendingCount == 0)
                      const Center(child: Text('No pending requests currently.')),
                    const SizedBox(height: 8),

                    // Performance Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified, color: primary, size: 20),
                              const SizedBox(width: 8),
                              const Text('SkillConnect Pro Standing', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('${proProvider.professional?.stats['acceptanceRate'] ?? 98}%', 'Acceptance'),
                              _buildStatItem('${proProvider.professional?.stats['onTimeRate'] ?? 100}%', 'On-Time'),
                              _buildStatItem(proProvider.professional?.verificationStatus == 'verified' ? 'Verified' : 'Pending', 'Partner'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, {required String badge, required Color badgeColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: onSurfaceVariant, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
      ],
    );
  }

  Widget _buildRequestCard(String name, String service, String problem, String match, String time, String distance, String pay) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: badgeBlue, borderRadius: BorderRadius.circular(12)),
                child: Text('$match Match', style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(service, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(problem, style: TextStyle(fontSize: 13, color: onSurfaceVariant)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('$distance km away', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Earnings', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(pay, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reject', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('View Request', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

