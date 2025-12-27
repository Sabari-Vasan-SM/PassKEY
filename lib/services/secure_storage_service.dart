import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SecureStorageService {
  static const String _pinKey = 'app_pin';
  static const String _pinSaltKey = 'pin_salt';

  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Generate a salt for PIN hashing
  static String _generateSalt() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Hash PIN with salt using SHA-256
  static String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$pin$salt')).toString();
  }

  /// Save PIN to secure storage
  static Future<bool> setPIN(String pin) async {
    try {
      final salt = _generateSalt();
      final hashedPin = _hashPin(pin, salt);

      await storage.write(key: _pinKey, value: hashedPin);
      await storage.write(key: _pinSaltKey, value: salt);
      return true;
    } catch (e) {
      print('Error saving PIN: $e');
      return false;
    }
  }

  /// Verify PIN
  static Future<bool> verifyPIN(String pin) async {
    try {
      final salt = await storage.read(key: _pinSaltKey);
      final storedPin = await storage.read(key: _pinKey);

      if (salt == null || storedPin == null) {
        return false;
      }

      final hashedPin = _hashPin(pin, salt);
      return hashedPin == storedPin;
    } catch (e) {
      print('Error verifying PIN: $e');
      return false;
    }
  }

  /// Check if PIN is already set
  static Future<bool> isPinSet() async {
    try {
      final pin = await storage.read(key: _pinKey);
      return pin != null;
    } catch (e) {
      print('Error checking PIN: $e');
      return false;
    }
  }

  /// Clear all data (for testing purposes)
  static Future<void> clearAll() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }
}
