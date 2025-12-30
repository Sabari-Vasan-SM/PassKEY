# PassKEY - Quick Build Commands

## 🚀 Quick Reference for Building Release

### Prerequisites Check
```bash
# Verify Flutter is working
flutter doctor -v

# Ensure dependencies are up to date
flutter pub get

# Run tests
flutter test

# Run code analysis
flutter analyze
```

### Build Commands

#### 1. Build APK (Direct Installation)
```bash
flutter build apk --release
```
**Output:** `build/app/outputs/flutter-apk/app-release.apk`

#### 2. Build App Bundle (Play Store - Recommended)
```bash
flutter build appbundle --release
```
**Output:** `build/app/outputs/bundle/release/app-release.aab`

#### 3. Build with Obfuscation (Recommended for Production)
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Install & Test
```bash
# Install APK on connected device
flutter install

# Or install specific APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Clean Build
```bash
# If you encounter build issues, clean first
flutter clean
flutter pub get
flutter build apk --release
```

## ⚠️ Important Notes

1. **Signing Key Required:** Make sure `android/key.properties` is configured
2. **Never Commit:** Don't commit key.properties or .jks files
3. **Test First:** Always test the release build before submitting
4. **Version Update:** Update version in pubspec.yaml before each release

## 📱 Current App Configuration

- **Package Name:** com.passkey.app
- **Min SDK:** 23 (Android 6.0)
- **Target SDK:** 34 (Android 14)
- **Version:** 1.0.0+1

## 🔐 Security Features Enabled

✅ ProGuard code obfuscation  
✅ Resource shrinking  
✅ Network security config (HTTPS only)  
✅ Secure storage encryption  
✅ No backup allowed (android:allowBackup="false")

## 🐛 Troubleshooting

**Build fails?**
```bash
flutter clean
rm -rf build/
flutter pub get
flutter build apk --release --verbose
```

**Signing issues?**
- Check `android/key.properties` exists
- Verify keystore path is correct
- Confirm passwords are correct

**App crashes?**
- Check ProGuard rules in `android/app/proguard-rules.pro`
- Test on different devices/Android versions
- Review crash logs: `adb logcat`

---

**Ready to Deploy!** 🎉
