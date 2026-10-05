import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/push_notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await PushNotificationService().initialize();
  } catch (e) {
    debugPrint("Firebase initialization error (possibly using dummy options): $e");
  }

  runApp(const SkillConnectApp());
}
