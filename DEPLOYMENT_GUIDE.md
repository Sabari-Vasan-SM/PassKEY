# PassKEY - Deployment Guide

## 📋 Pre-Deployment Checklist

### ✅ Completed Tasks
- [x] Fixed deprecated lint rules in analysis_options.yaml
- [x] Fixed code quality issues
- [x] Updated widget tests
- [x] Configured Android release build settings
- [x] Added ProGuard rules for code obfuscation
- [x] Updated .gitignore to exclude sensitive files
- [x] Added network security configuration
- [x] All tests passing

## 🔐 Step 1: Generate Signing Key

Before building for release, you need to create a keystore for signing your Android app.

### Generate a new keystore:

```bash
keytool -genkey -v -keystore ~/passkey-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias passkey
```

**Important:** 
- Store your keystore file in a safe location (outside the project directory)
- **Never commit the keystore file or passwords to version control**
- Keep a backup of your keystore and passwords in a secure location

### Create key.properties file:

Create a file named `key.properties` in the `android/` directory with the following content:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=passkey
storeFile=C:/path/to/your/passkey-release-key.jks
```

**Note:** Replace the values with your actual passwords and keystore path.

## 📱 Step 2: Update App Information

### Update version in pubspec.yaml:

```yaml
version: 1.0.0+1  # Format: major.minor.patch+buildNumber
```

### Update Android package name (if needed):

Current package: `com.passkey.app`

To change it:
1. Update in `android/app/build.gradle` (applicationId)
2. Update MainActivity.kt package name
3. Update AndroidManifest.xml

## 🏗️ Step 3: Build Release Versions

### Android APK (for testing/direct installation):

```bash
flutter build apk --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store):

```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/bundle/release/app-release.aab`

**Recommended:** Use App Bundle for Play Store as it provides:
- Smaller download sizes
- Better optimization for different device configurations

### Build with specific options:

```bash
# With obfuscation and split debug info
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

# Specific target platform
flutter build apk --release --target-platform android-arm64
```

## 🧪 Step 4: Test Release Build

### Install and test APK:

```bash
flutter install build/app/outputs/flutter-apk/app-release.apk
```

### Test checklist:
- [ ] App launches successfully
- [ ] PIN setup works correctly
- [ ] Password storage/retrieval works
- [ ] Encryption is functioning
- [ ] No sensitive debug information visible
- [ ] Performance is acceptable
- [ ] All features work as expected

## 📊 Step 5: Analyze Build Size

```bash
flutter build apk --release --analyze-size
flutter build appbundle --release --analyze-size
```

## 🚀 Step 6: Deploy to Play Store

### 1. Create Play Console Account
- Sign up at [Google Play Console](https://play.google.com/console)
- Pay one-time registration fee ($25)

### 2. Create New Application
- Choose app name and language
- Fill in store listing details

### 3. Upload App Bundle
- Go to "Release" → "Production"
- Upload the `.aab` file
- Set version name and release notes

### 4. Complete Store Listing
Required information:
- App description (short and full)
- Screenshots (phone, tablet, etc.)
- Feature graphic
- App icon
- Privacy policy URL
- Content rating
- Target audience
- App category

### 5. Complete Content Rating
- Fill out the questionnaire
- Obtain rating certificate

### 6. Set Up Pricing & Distribution
- Choose countries
- Set pricing (free/paid)
- Agree to terms

### 7. Submit for Review
- Review all sections
- Submit app for review
- Wait for approval (typically 1-7 days)

## 🔒 Security Considerations

✅ **Implemented:**
- ProGuard enabled for code obfuscation
- Network security configuration (HTTPS only)
- Secure local storage for sensitive data
- PIN-based authentication
- Auto-clipboard clearing after 30 seconds

⚠️ **Additional Recommendations:**
- Implement biometric authentication (fingerprint/face)
- Add app lock on background
- Implement master password export/backup
- Add password strength indicator
- Consider adding two-factor authentication

## 📝 Post-Deployment Tasks

1. **Monitor Crashes**
   - Set up Firebase Crashlytics
   - Monitor Play Console pre-launch reports

2. **Analytics**
   - Consider adding Google Analytics or similar
   - Track feature usage (respecting privacy)

3. **User Feedback**
   - Monitor Play Store reviews
   - Respond to user feedback
   - Implement requested features

4. **Updates**
   - Fix bugs promptly
   - Add new features based on feedback
   - Keep dependencies updated

## 🐛 Common Issues

### Issue: "App not installed"
**Solution:** Uninstall any previous version first

### Issue: Keystore password error
**Solution:** Double-check key.properties file and passwords

### Issue: Build fails with ProGuard errors
**Solution:** Update proguard-rules.pro with appropriate keep rules

### Issue: App crashes on startup
**Solution:** 
- Check ProGuard rules
- Verify all dependencies are compatible
- Test on different Android versions

## 📚 Additional Resources

- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

## 🔄 Version History

- **v1.0.0+1** - Initial release
  - PIN-based authentication
  - Secure password storage
  - Material 3 design
  - Dark/light theme support

## 📞 Support

For deployment issues or questions:
- Check Flutter documentation
- Review Android developer guidelines
- Test thoroughly before submitting

---

**Last Updated:** December 30, 2025
**Project Status:** Ready for Deployment 🚀
