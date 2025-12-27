import 'package:flutter/foundation.dart';
import '../models/password_item.dart';
import '../services/database_service.dart';

class PasswordProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<PasswordItem> _passwords = [];
  bool _isLoading = false;

  List<PasswordItem> get passwords => _passwords;
  bool get isLoading => _isLoading;

  PasswordProvider() {
    loadPasswords();
  }

  /// Load all passwords from database
  Future<void> loadPasswords() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _passwords = await _databaseService.getAllPasswords();
    } catch (e) {
      print('Error loading passwords: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new password
  Future<bool> addPassword(PasswordItem passwordItem) async {
    try {
      final id = await _databaseService.addPassword(passwordItem);
      final newItem = passwordItem.copyWith(id: id);
      _passwords.insert(0, newItem);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error adding password: $e');
      return false;
    }
  }

  /// Update an existing password
  Future<bool> updatePassword(PasswordItem passwordItem) async {
    try {
      await _databaseService.updatePassword(
        passwordItem.copyWith(updatedAt: DateTime.now()),
      );
      final index = _passwords.indexWhere((p) => p.id == passwordItem.id);
      if (index != -1) {
        _passwords[index] = passwordItem.copyWith(updatedAt: DateTime.now());
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Error updating password: $e');
      return false;
    }
  }

  /// Delete a password
  Future<bool> deletePassword(int id) async {
    try {
      await _databaseService.deletePassword(id);
      _passwords.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting password: $e');
      return false;
    }
  }

  /// Get password by ID
  PasswordItem? getPasswordById(int id) {
    try {
      return _passwords.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
