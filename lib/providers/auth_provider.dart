import 'package:flutter/foundation.dart';
import '../services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isInitializing = true;
  bool _isPinSet = false;
  bool _isAuthenticated = false;

  bool get isInitializing => _isInitializing;
  bool get isPinSet => _isPinSet;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate splash screen
    _isPinSet = await SecureStorageService.isPinSet();
    _isInitializing = false;
    notifyListeners();
  }

  /// Set up a new PIN
  Future<bool> setupPin(String pin) async {
    final success = await SecureStorageService.setPIN(pin);
    if (success) {
      _isPinSet = true;
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  /// Verify PIN during login
  Future<bool> verifyPin(String pin) async {
    final success = await SecureStorageService.verifyPIN(pin);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  /// Logout (lock the app)
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
