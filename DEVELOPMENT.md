# PassKEY Development Guide

## Architecture Overview

PassKEY follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────┐
│         UI Layer (Screens)          │
├─────────────────────────────────────┤
│      State Management (Provider)    │
├─────────────────────────────────────┤
│        Business Logic (Providers)   │
├─────────────────────────────────────┤
│     Services (Storage, Database)    │
├─────────────────────────────────────┤
│      Models (Data Structures)       │
└─────────────────────────────────────┘
```

## Layer Descriptions

### 1. UI Layer (Screens)
**Files**: `lib/screens/*.dart`

Responsible for:
- User interface rendering
- User input handling
- Navigation between screens
- Displaying state from providers

**Screens**:
- `splash_screen.dart` - Animated splash with app logo
- `pin_setup_screen.dart` - Initial PIN setup (first launch)
- `pin_verification_screen.dart` - PIN login (subsequent launches)
- `password_list_screen.dart` - Main password list with FAB
- `password_add_edit_screen.dart` - Create/edit password form
- `password_detail_screen.dart` - Full password details view

### 2. State Management (Provider)
**Files**: `lib/providers/*.dart`

Uses `Provider` pattern for reactive state management:

#### AuthProvider
```dart
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated;      // User logged in?
  bool _isPinSet;             // PIN configured?
  bool _isInitializing;       // App starting up?
  
  setupPin(String pin)        // Set initial PIN
  verifyPin(String pin)       // Verify PIN
  logout()                    // Lock app
}
```

#### PasswordProvider
```dart
class PasswordProvider extends ChangeNotifier {
  List<PasswordItem> _passwords;
  bool _isLoading;
  
  loadPasswords()             // Fetch from DB
  addPassword(PasswordItem)   // Create
  updatePassword(PasswordItem) // Update
  deletePassword(int id)      // Delete
  getPasswordById(int id)     // Read single
}
```

### 3. Services Layer
**Files**: `lib/services/*.dart`

#### SecureStorageService
Handles PIN storage securely:
```dart
setPIN(String pin)           // Hash & store
verifyPIN(String pin)        // Verify hash
isPinSet()                   // Check existence
```

#### DatabaseService
SQLite operations:
```dart
addPassword(PasswordItem)    // INSERT
getAllPasswords()            // SELECT all
updatePassword(PasswordItem) // UPDATE
deletePassword(int id)       // DELETE
getPasswordById(int id)      // SELECT one
```

### 4. Models
**Files**: `lib/models/*.dart`

#### PasswordItem
```dart
class PasswordItem {
  int? id;                   // Database ID
  String title;              // App/service name
  String username;           // Username or email
  String password;           // Actual password
  String? notes;             // Optional notes
  DateTime createdAt;        // Creation timestamp
  DateTime updatedAt;        // Last update timestamp
  
  toMap()                    // → Database
  fromMap()                  // ← Database
  copyWith()                 // Create modified copy
}
```

## Data Flow Patterns

### Adding a Password
```
User Input (Form)
    ↓
Validation (PasswordAddEditScreen)
    ↓
PasswordProvider.addPassword()
    ↓
DatabaseService.addPassword()
    ↓
SQLite Database
    ↓
Update PasswordProvider._passwords
    ↓
UI Rebuilds (Consumer widget)
    ↓
Show Success SnackBar
```

### Authentication Flow
```
App Launch
    ↓
main.dart (AuthGate)
    ↓
Check AuthProvider.isInitializing
    ├─ Yes → Show SplashScreen
    └─ No → Check AuthProvider.isPinSet
           ├─ No → Show PinSetupScreen
           └─ Yes → Check AuthProvider.isAuthenticated
                  ├─ No → Show PinVerificationScreen
                  └─ Yes → Show PasswordListScreen
```

### PIN Verification Flow
```
User Enters PIN
    ↓
Validate Input (4 digits, numeric)
    ↓
SecureStorageService.verifyPIN()
    ↓
Retrieve stored hash & salt
    ↓
Hash input with salt
    ↓
Compare hashes
    ├─ Match → AuthProvider.isAuthenticated = true
    └─ No Match → Show error, clear input
```

## Key Implementation Details

### Secure PIN Storage
```dart
// PIN Hashing Algorithm
SHA256(PIN + SALT) = STORED_HASH

// Verification
SHA256(INPUT_PIN + SALT) == STORED_HASH
```

**Why SHA-256?**
- Fast one-way hashing
- Collision-resistant
- Industry standard
- Available in Dart crypto package

### Database Schema
```sql
CREATE TABLE passwords (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  notes TEXT,
  createdAt INTEGER NOT NULL,  -- milliseconds since epoch
  updatedAt INTEGER NOT NULL   -- milliseconds since epoch
)
```

### Clipboard Auto-Clear
```dart
// Copy password
Clipboard.setData(ClipboardData(text: password))

// Auto-clear after 30 seconds
Future.delayed(Duration(seconds: 30), () {
  Clipboard.setData(ClipboardData(text: ''))
})
```

## State Management Patterns

### Consumer Pattern (Read State)
```dart
Consumer<PasswordProvider>(
  builder: (context, passwordProvider, _) {
    return ListView(
      children: passwordProvider.passwords
          .map((p) => PasswordCard(password: p))
          .toList()
    );
  }
)
```

### Provider.of Pattern (Multiple Reads)
```dart
final passwords = context.read<PasswordProvider>().passwords;
final isLoading = context.watch<PasswordProvider>().isLoading;
```

### Notifying Listeners
```dart
class PasswordProvider extends ChangeNotifier {
  Future<void> addPassword(PasswordItem item) async {
    // ... database operation ...
    notifyListeners();  // Trigger UI rebuild
  }
}
```

## Styling & Theme

### Material 3 Theme Configuration
Located in `lib/theme/app_theme.dart`:

```dart
// Light theme primary colors
Color(0xFF6366F1)   // Indigo
Color(0xFF8B5CF6)   // Purple
Color(0xFFEC4899)   // Pink

// Consistent application across app
ThemeData.light(
  colorScheme: ColorScheme.light(
    primary: _lightPrimary,
    secondary: _lightSecondary,
    // ...
  )
)
```

### Material Components Used
- AppBar with custom styling
- Card widgets with elevation
- ElevatedButton with custom shape
- TextFormField with custom decoration
- FloatingActionButton
- PopupMenuButton
- AlertDialog

## Performance Optimizations

### Database
- Ordered queries: `orderBy: 'updatedAt DESC'`
- Efficient filtering in SQL
- Single database instance

### UI Rendering
- `Consumer` widgets for selective rebuilds
- Lazy list building with `ListView.builder`
- Cached animations in `StatefulWidget`

### State Management
- Providers only rebuild necessary consumers
- `read()` vs `watch()` for non-reactive reads
- Single source of truth per provider

## Error Handling

### Database Errors
```dart
try {
  await _databaseService.addPassword(item);
} catch (e) {
  print('Error adding password: $e');
  setState(() {
    _errorMessage = 'Failed to add password';
  });
}
```

### Validation Errors
```dart
if (_pinController.text.isEmpty) {
  setState(() {
    _errorMessage = 'Please enter a PIN';
  });
  return;
}
```

## Testing Considerations

### Unit Tests (Not Included - Add These)
```dart
test('SecureStorageService hashes PIN correctly', () {
  // Test PIN hashing
});

test('PasswordProvider loads passwords from DB', () {
  // Test password loading
});
```

### Integration Tests
```dart
testWidgets('PIN setup flow', (WidgetTester tester) async {
  // Test complete PIN setup
});

testWidgets('Add password flow', (WidgetTester tester) async {
  // Test password addition
});
```

## Extending the App

### Adding a New Feature

1. **Create Model** (if needed)
   ```dart
   // lib/models/new_model.dart
   ```

2. **Create Service** (if needed)
   ```dart
   // lib/services/new_service.dart
   ```

3. **Create Provider**
   ```dart
   // lib/providers/new_provider.dart
   class NewProvider extends ChangeNotifier { }
   ```

4. **Create UI**
   ```dart
   // lib/screens/new_screen.dart
   ```

5. **Wire in main.dart**
   ```dart
   MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (_) => NewProvider()),
     ]
   )
   ```

### Example: Adding Search Feature

1. Add search logic to `PasswordProvider`:
```dart
List<PasswordItem> get filteredPasswords {
  if (_searchQuery.isEmpty) return _passwords;
  return _passwords.where((p) => 
    p.title.toLowerCase().contains(_searchQuery.toLowerCase())
  ).toList();
}

void updateSearchQuery(String query) {
  _searchQuery = query;
  notifyListeners();
}
```

2. Add SearchBar to `PasswordListScreen`
3. Use `filteredPasswords` instead of `passwords`

## Common Issues & Solutions

### Issue: Widget not rebuilding
**Solution**: Use `Consumer` instead of `Provider.of` with `listen: false`

### Issue: Database locked
**Solution**: Ensure only one instance of `DatabaseService` (it's a singleton)

### Issue: Secure storage returns null
**Solution**: Check Android API level >= 16, check permissions

### Issue: Memory leaks
**Solution**: Always dispose `TextEditingController` in `dispose()`

## Best Practices

✅ **Do:**
- Use `Consumer` for reactive UI updates
- Dispose resources in `dispose()`
- Use meaningful variable names
- Validate all user input
- Handle all exceptions
- Use const constructors where possible
- Keep providers focused (single responsibility)

❌ **Don't:**
- Directly modify provider state without notifyListeners()
- Create multiple instances of DatabaseService
- Store sensitive data in plaintext
- Ignore database errors
- Create memory leaks with controllers
- Use print() for debugging (use logger)

## Debugging Tips

```dart
// Enable Flutter DevTools
flutter pub global activate devtools
devtools

// Run with DevTools
flutter run --dart-devtools-uri=http://localhost:9100

// Check widget tree
flutter run --verbose

// Profile app
flutter run --profile

// Memory checking
flutter run --track-widget-creation
```

## Build Variants

### Debug Build
```bash
flutter run
```

### Profile Build
```bash
flutter run --profile
```

### Release Build
```bash
flutter build apk --release
```

---

**This guide provides the foundation. Happy developing! 🚀**
