# PassKEY - Secure Local Password Manager

A secure Flutter-based password manager that stores all data locally on your device with a PIN-protected interface.

## Features

🔐 **Security**
- 4-digit PIN protection
- Secure local storage using device-level encryption
- SHA-256 PIN hashing
- No cloud storage or internet required

📱 **Password Management**
- Add, view, edit, and delete passwords
- Secure password storage in local database
- One-tap clipboard copy with auto-clear
- Support for usernames, emails, and notes

💾 **Storage**
- Persistent local database
- Data survives app closure and restart
- Works offline completely

🎨 **User Interface**
- Material 3 (Material You) design
- Dark and light theme support
- Smooth animations and transitions
- Mobile-first responsive layout
- Friendly empty states

## Getting Started

### Prerequisites
- Flutter SDK (Latest stable)
- Android SDK (for Android development)

### Installation

1. **Clone the repository**
```bash
cd PassKEY
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Build for Release

**Android**
```bash
flutter build apk --release
```

Or for App Bundle:
```bash
flutter build appbundle --release
```

## Architecture

### Project Structure
```
lib/
├── main.dart                           # App entry point
├── screens/
│   ├── splash_screen.dart             # Splash/Loading screen
│   ├── pin_setup_screen.dart          # Initial PIN setup
│   ├── pin_verification_screen.dart   # PIN verification
│   ├── password_list_screen.dart      # Main password list
│   ├── password_add_edit_screen.dart  # Add/Edit password
│   └── password_detail_screen.dart    # View password details
├── providers/
│   ├── auth_provider.dart             # Authentication logic
│   └── password_provider.dart         # Password management logic
├── models/
│   └── password_item.dart             # Password data model
├── services/
│   ├── secure_storage_service.dart    # PIN secure storage
│   └── database_service.dart          # Password database
└── theme/
    └── app_theme.dart                 # Material 3 theme
```

### State Management
- **Provider**: Used for reactive state management
- **AuthProvider**: Manages authentication state and PIN verification
- **PasswordProvider**: Manages password CRUD operations

### Storage
- **flutter_secure_storage**: Secure PIN storage
- **sqflite**: Local SQLite database for passwords

## Usage

### First Launch
1. App displays PIN setup screen
2. Set a 4-digit numeric PIN
3. Confirm PIN
4. App unlocks and shows empty password list

### Adding a Password
1. Tap the **+** button
2. Fill in Title, Username/Email, and Password
3. Optionally add Notes
4. Tap "Add Password"

### Viewing/Copying Passwords
1. Tap on a password entry to view details
2. Tap copy icons to copy values to clipboard
3. Clipboard auto-clears after 30 seconds for security

### Editing a Password
1. Tap on a password entry
2. Tap the edit icon
3. Modify details as needed
4. Tap "Update Password"

### Deleting a Password
1. Long-press or tap menu on password entry
2. Select "Delete"
3. Confirm deletion

## Security Considerations

✅ **What's Secure**
- PIN stored using SHA-256 hashing with salt
- Passwords stored in encrypted local database
- No network calls
- Device-level encryption via `flutter_secure_storage`

⚠️ **Important Notes**
- Keep your PIN confidential
- App lock only provides PIN-level security
- Does not prevent physical device access attacks
- Regular backups recommended

## Dependencies

- **flutter**: Core Flutter framework
- **provider**: State management
- **flutter_secure_storage**: Secure PIN storage
- **sqflite**: Local database
- **path_provider**: Database path access
- **pointycastle**: Cryptography support
- **convert**: Data conversion utilities
- **crypto**: Hash functions

## Technical Details

### PIN Hashing
```
hash = SHA-256(PIN + SALT)
```

### Password Storage
- Stored in SQLite database
- Database file location: `/data/data/com.example.passkey/databases/passkey.db`
- No additional encryption layer (relies on device security)

### Data Persistence
- Survives app closure
- Survives app removal from recent apps
- Survives device restart

## Performance
- Fast app launch with splash screen
- Smooth animations (60 FPS)
- Efficient database queries with proper indexing

## Future Enhancements
- [ ] Biometric authentication (fingerprint)
- [ ] Password strength indicator
- [ ] Password generation tool
- [ ] Search and filter capabilities
- [ ] Export/Import functionality
- [ ] Multiple PIN attempts lockout
- [ ] Auto-lock timer

## License
This project is provided as-is for educational and personal use.

## Support
For issues or feature requests, please create an issue in the repository.
