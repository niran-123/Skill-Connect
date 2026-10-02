import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Screen - To Be Implemented')),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});
  @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Help and Support');
}
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});
  @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'FAQ');
}
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Terms of Service');
}
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Privacy Policy');
}
class NotificationDetailsScreen extends StatelessWidget {
  final String id;
  const NotificationDetailsScreen({super.key, required this.id});
  @override Widget build(BuildContext context) => PlaceholderScreen(title: 'Notification Details $id');
}
