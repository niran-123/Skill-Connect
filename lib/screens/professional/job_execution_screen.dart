import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/professional_provider.dart';
import '../../providers/session_provider.dart';
import '../../models/booking.dart';
import 'package:image_picker/image_picker.dart';

class JobExecutionScreen extends StatefulWidget {
  final BookingModel booking;
  const JobExecutionScreen({super.key, required this.booking});

  @override
  State<JobExecutionScreen> createState() => _JobExecutionScreenState();
}

class _JobExecutionScreenState extends State<JobExecutionScreen> {
  final _notesCtrl = TextEditingController();
  
  Future<void> _updateStatus(String newStatus, {Map<String, dynamic>? extraData}) async {
    final proProvider = context.read<ProfessionalProvider>();
    final uid = context.read<SessionProvider>().userModel!.uid;
    await proProvider.updateBookingStatus(widget.booking.id, newStatus, uid, extraData: extraData);
    if (newStatus == 'completed' || newStatus == 'rejected' || newStatus == 'cancelled') {
      if (mounted) context.pop();
    }
  }

  void _completeJob() async {
    // Simulated picture taking
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);
    
    // Normally upload to ImageRepo here.
    String? imageId = img != null ? 'simulated_image_id' : null;

    final extra = <String, dynamic>{
      'completionNotes': _notesCtrl.text,
    };
    if (imageId != null) extra['completionImageId'] = imageId;
    _updateStatus('completed', extraData: extra);
  }

  @override
  Widget build(BuildContext context) {
    final proProvider = context.watch<ProfessionalProvider>();
    final b = proProvider.bookings.firstWhere(
      (b) => b.id == widget.booking.id,
      orElse: () => widget.booking,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: \${b.customerName}', style: Theme.of(context).textTheme.titleLarge),
            Text('Status: \${b.status}'),
            const SizedBox(height: 16),
            const Text('Job Description', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(b.jobSnapshot['description'] ?? ''),
            const SizedBox(height: 24),
            
            if (b.status == 'pending') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _updateStatus('rejected'),
                    child: const Text('Reject', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _updateStatus('accepted'),
                    child: const Text('Accept', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ] else if (b.status == 'accepted') ...[
              ElevatedButton(
                onPressed: () => _updateStatus('onTheWay'),
                child: const Text('Mark as On The Way'),
              )
            ] else if (b.status == 'onTheWay') ...[
              ElevatedButton(
                onPressed: () => _updateStatus('arrived'),
                child: const Text('Mark as Arrived'),
              )
            ] else if (b.status == 'arrived') ...[
              ElevatedButton(
                onPressed: () => _updateStatus('inProgress'),
                child: const Text('Start Work (In Progress)'),
              )
            ] else if (b.status == 'inProgress') ...[
              TextField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Completion Notes (optional)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo & Complete'),
                onPressed: _completeJob,
              )
            ] else ...[
              const Center(child: Text('This job is closed or completed.', style: TextStyle(color: Colors.grey))),
            ]
          ],
        ),
      ),
    );
  }
}
