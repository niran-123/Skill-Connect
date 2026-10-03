import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<UserCredential?> signInWithEmail(String email, String password, {String? expectedRole}) async {
    _setLoading(true);
    _setError(null);
    try {
      final credential = await _authRepo.signInWithEmail(email, password);
      
      if (expectedRole != null && credential.user != null) {
        final userRepo = UserRepo();
        final userModel = await userRepo.getUser(credential.user!.uid);
        
        if (userModel != null && userModel.role != expectedRole) {
          await _authRepo.signOut();
          final String roleStr = userModel.role;
          final String displayRole = roleStr.isNotEmpty ? '${roleStr[0].toUpperCase()}${roleStr.substring(1)}' : 'Unknown';
          _setError('This account is registered as $displayRole. Please use $displayRole Login.');
          _setLoading(false);
          return null;
        }
      }
      
      _setLoading(false);
      return credential;
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'An error occurred during sign in');
      _setLoading(false);
      return null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final credential = await _authRepo.signUpWithEmail(email, password);
      _setLoading(false);
      return credential;
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'An error occurred during sign up');
      _setLoading(false);
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);
    try {
      final credential = await _authRepo.signInWithGoogle();
      _setLoading(false);
      return credential;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authRepo.sendPasswordReset(email);
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'An error occurred');
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
  }
}
