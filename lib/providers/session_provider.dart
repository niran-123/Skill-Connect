import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';
import '../models/user_model.dart';
import '../services/push_notification_service.dart';

class SessionProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  final UserRepo _userRepo = UserRepo();
  
  User? _authUser;
  UserModel? _userModel;
  bool _isLoading = true;
  StreamSubscription<User?>? _authSubscription;

  User? get authUser => _authUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  SessionProvider() {
    _init();
  }

  void _init() {
    _authSubscription = _authRepo.authStateChanges.listen((User? user) async {
      _authUser = user;
      if (user != null) {
        _userModel = await _userRepo.getUser(user.uid);
        await _updateFcmToken(user.uid);
      } else {
        _userModel = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _updateFcmToken(String uid) async {
    try {
      final token = await PushNotificationService().getToken();
      if (token != null) {
        await _userRepo.updateUser(uid, {'fcmToken': token});
      }
    } catch (e) {
      debugPrint("Error updating FCM token: $e");
    }
  }

  Future<void> refreshUserModel() async {
    if (_authUser != null) {
      _userModel = await _userRepo.getUser(_authUser!.uid);
      await _updateFcmToken(_authUser!.uid);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
