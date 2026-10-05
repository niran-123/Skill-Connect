import 'package:flutter/material.dart';
import 'faq_screen.dart';
import 'legal_screen.dart';

// HelpSupportScreen is defined in legal_screen.dart
export 'legal_screen.dart' show HelpSupportScreen;

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});
  @override Widget build(BuildContext context) => const FAQScreen();
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override Widget build(BuildContext context) => const LegalScreen(
    title: 'Terms of Service',
    content: 'Welcome to SkillConnect!\n\n1. Acceptance of Terms\nBy accessing and using this app, you accept and agree to be bound by the terms and provision of this agreement.\n\n2. Service Provision\nSkillConnect acts as a marketplace to connect customers with trade professionals. We do not directly employ the professionals.\n\n3. Payments\nAll payments must be made through the platform. Cash payments are outside the scope of our protection.\n\n4. Liability\nSkillConnect is not liable for any damages that occur during the service provision, but we provide a dispute resolution center.',
  );
}

const String _privacyPolicyText = '''
SkillConnect Privacy Policy
Last Updated: October 5, 2026

1. APP OWNER / DEVELOPER INFORMATION
Developer/Company Name: SkillConnect Inc.
App Name: SkillConnect
Contact Email: support@skillconnect.com
Website: https://skillconnect.com
Address: 123 Skill Street, Tech City, IN

2. INFORMATION WE COLLECT
We collect personal information that you provide to us and data that is necessary for the core functionality of the SkillConnect platform. We do not collect unnecessary data.

ACCOUNT INFORMATION:
• Name, email address, and phone number
• Address and physical location coordinates
• Password/authentication credentials (managed securely via Firebase)
• User role (Customer or Professional)
• Profile photo (Avatar)

PROFESSIONAL INFORMATION (For Professional Users):
• Skills, service categories, and experience years
• Service radius and scheduling availability
• Business location (city, area, lat/lng)
• Professional bio and service description
• Verification status and uploaded certificates/documents
• Job performance statistics and ratings

SERVICE REQUEST INFORMATION:
• Service requested and problem descriptions (Job Snapshot)
• Scheduled date and time slots
• Estimated and final service charges
• Service status history and timestamps
• Job completion notes and images

DEVICE / TECHNICAL INFORMATION:
• Push notification tokens (FCM tokens) to send relevant service updates
• Device location (only if permission is granted)

3. HOW WE USE INFORMATION
We use the collected information solely to operate and improve the SkillConnect platform:
• Create and manage Customer and Professional accounts.
• Authenticate users securely.
• Connect Customers with appropriate local Professionals based on distance and skills.
• Facilitate service requests, proposals, and bookings.
• Provide real-time service status updates and timestamps (e.g., job started, arrived).
• Process profile images and completion photos.
• Send essential push notifications regarding job requests and account events.
• Troubleshoot technical problems and provide customer support.

4. CUSTOMER DATA
Customer data is used to create service requests and match you with Professionals. We only share necessary service-request information (such as your name, phone number, address, and job details) with the specific Professional assigned to fulfill your service request. 

5. PROFESSIONAL DATA
Professional data is used to build a public profile that Customers can view. We display your name, category, skills, bio, experience, ratings, and service radius so Customers can make informed booking decisions. Your exact coordinates are used internally to calculate distance to jobs.

6. CUSTOMER AND PROFESSIONAL COMMUNICATION
Information is exchanged between the Customer and the assigned Professional to successfully complete the requested service. Customers can see the Professional's profile, and Professionals can see the Customer's name, phone number, and service address once a booking request is initiated.

7. FIREBASE / THIRD-PARTY SERVICES
We use third-party service providers to facilitate our Service. These providers have access to your Personal Information only to perform tasks on our behalf and are obligated not to disclose or use it for any other purpose:
• Firebase Authentication: For secure user sign-in and identity management.
• Cloud Firestore: As our primary database to store user profiles, professional data, and bookings.
• Firebase Storage: To securely store profile pictures, completion images, and verification documents.
• Firebase Cloud Messaging: To send push notifications for job updates.
• Google/Apple Geocoding API: To convert addresses to geographic coordinates.

8. DATA SHARING
We do not sell your personal data to advertisers or third parties. We only share information in the following circumstances:
• SERVICE PROFESSIONALS: Necessary Customer information is shared with the Professional assigned to the job.
• SERVICE CUSTOMERS: Professional profiles are visible to Customers.
• SERVICE PROVIDERS: Information is processed by our secure backend infrastructure (Firebase).
• LEGAL REQUIREMENTS: Information may be disclosed when required by applicable law, regulation, or legal process.
• SECURITY: To detect, prevent, or address fraud or security issues.

9. DATA SECURITY
We take reasonable technical and organizational measures to protect personal information. We utilize Firebase's robust security rules, secure HTTPS communication, and encrypted data storage. However, no method of transmission over the internet or method of electronic storage is 100% secure, and we cannot guarantee absolute security.

10. DATA RETENTION
We retain personal information for as long as reasonably necessary to provide the services, maintain accounts and service history, comply with legal obligations, and resolve disputes.

11. ACCOUNT DELETION
Users may request deletion of their account and associated personal data at any time. To request account deletion, please send an email to support@skillconnect.com from the email address associated with your SkillConnect account. We will process your deletion request in accordance with applicable laws.

12. CHILDREN'S PRIVACY
The Service is not intended for children under the applicable minimum age required by law. We do not knowingly collect personal information from children. If we discover that a child has provided us with personal information, we immediately delete this from our servers.

13. LOCATION DATA
Location data (latitude and longitude) is a core component of SkillConnect. 
• Why it is needed: To match Customers with Professionals who are within their service radius and calculate travel distance.
• When it is accessed: When setting your address or requesting a service.
• Location sharing: Your location is shared with the Professional to enable them to reach your address for the service. We do not continuously track background location unless you explicitly authorize it during a job.

14. NOTIFICATIONS
We use Firebase Cloud Messaging to send essential transactional notifications related to service requests, professional responses, job status updates, and account-related events.

15. COOKIES / TRACKING
The SkillConnect mobile application does not use cookies or advertising trackers. 

16. USER RIGHTS
Depending on your jurisdiction, you may have rights under applicable privacy laws, including the right to access, correct, or request deletion of your personal information. To exercise these rights, contact us at support@skillconnect.com.

17. CHANGES TO PRIVACY POLICY
We may update this Privacy Policy from time to time. When we make changes, we will update the "Last Updated" date at the top of this policy and, where appropriate, provide additional notice.

18. CONTACT US
Developer/Company: SkillConnect Inc.
Email: support@skillconnect.com
Address: 123 Skill Street, Tech City, IN
''';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override Widget build(BuildContext context) => const LegalScreen(
    title: 'Privacy Policy',
    content: _privacyPolicyText,
  );
}

class NotificationDetailsScreen extends StatelessWidget {
  final String id;
  const NotificationDetailsScreen({super.key, required this.id});
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FB),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFDBEAFE), shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_active, color: Color(0xFF1D4ED8)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('New Update', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Text('#$id', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('This is a notification update regarding your account or booking. Please check your active bookings or profile for more details.',
                style: TextStyle(height: 1.5, color: Color(0xFF475569)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
