import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/session_provider.dart';
import '../../models/booking.dart';

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() => _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<SessionProvider>().userModel;
      if (user != null) {
        context.read<JobProvider>().loadCustomerBookings(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final bookings = jobProvider.customerBookings;
    
    final activeBookings = bookings.where((b) => b.status == 'pending' || b.status == 'accepted' || b.status == 'arrived' || b.status == 'ready_to_start' || b.status == 'in_progress').toList();
    final upcomingBookings = bookings.where((b) => b.status == 'scheduled').toList();
    final completedBookings = bookings.where((b) => b.status == 'completed').toList();
    final cancelledBookings = bookings.where((b) => b.status == 'cancelled').toList();

    final Color primary = const Color(0xFF1D4ED8);
    final Color surface = const Color(0xFFF7F9FB);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: surface,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('My Bookings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurface)),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: primary,
            unselectedLabelColor: onSurfaceVariant,
            indicatorColor: primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: jobProvider.isLoading
            ? Center(child: CircularProgressIndicator(color: primary))
            : TabBarView(
                children: [
                  _buildList(activeBookings, _buildActiveCard, onSurfaceVariant),
                  _buildList(upcomingBookings, _buildUpcomingCard, onSurfaceVariant),
                  _buildList(completedBookings, _buildCompletedCard, onSurfaceVariant),
                  _buildList(cancelledBookings, _buildCancelledCard, onSurfaceVariant),
                ],
              ),
      ),
    );
  }
  
  Widget _buildList(List<BookingModel> list, Widget Function(BuildContext, BookingModel) builder, Color onSurfaceVariant) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No bookings found', style: TextStyle(fontSize: 16, color: onSurfaceVariant)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: builder(context, list[index]),
        );
      }
    );
  }

  Widget _buildActiveCard(BuildContext context, BookingModel booking) {
    final Color primary = const Color(0xFF1D4ED8);
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    
    
    final isArrived = booking.status == 'arrived';
    final statusColor = (isArrived || booking.status == 'ready_to_start') ? const Color(0xFF10B981) : const Color(0xFF1D4ED8);
    final statusText = isArrived ? 'Active • Pro Arrived' : (booking.status == 'ready_to_start' ? 'Active • Confirmed' : 'Active • \${booking.status.toUpperCase()}');

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFCBD5E1).withValues(alpha: 0.5)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(), // ID removed
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(statusText, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey.shade200, radius: 24, backgroundImage: NetworkImage(booking.professionalThumb ?? 'https://via.placeholder.com/150')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.professionalName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface)),
                    Text(booking.jobSnapshot['analysis']?['problemType'] ?? 'Service Request', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: onSurfaceVariant),
              const SizedBox(width: 6),
              Text('Requested Recently', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.pushNamed('customer-booking-details', pathParameters: {'id': booking.id}),
                  style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('View Live Details', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.phone, color: primary),
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFDBEAFE), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, BookingModel booking) {
    // Very similar to active for now
    return _buildActiveCard(context, booking);
  }

  Widget _buildCompletedCard(BuildContext context, BookingModel booking) {
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFCBD5E1).withValues(alpha: 0.5))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(), // ID removed
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                child: const Text('Completed', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(booking.professionalName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
          Text(booking.jobSnapshot['analysis']?['problemType'] ?? 'Service Request', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
          const SizedBox(height: 16),
          if (booking.reviewed != true)
            ElevatedButton(
              onPressed: () => context.pushNamed('customer-review', pathParameters: {'id': booking.id}, extra: booking),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Leave Review', style: TextStyle(color: Colors.black)),
            )
          else
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('View Invoice'),
            ),
        ],
      ),
    );
  }

  Widget _buildCancelledCard(BuildContext context, BookingModel booking) {
    final Color onSurface = const Color(0xFF0F172A);
    final Color onSurfaceVariant = const Color(0xFF64748B);
    
    
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFCBD5E1).withValues(alpha: 0.5))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(), // ID removed
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
                child: const Text('Cancelled', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(booking.professionalName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface)),
          Text(booking.jobSnapshot['analysis']?['problemType'] ?? 'Service Request', style: TextStyle(fontSize: 12, color: onSurfaceVariant)),
        ],
      ),
    );
  }
}
