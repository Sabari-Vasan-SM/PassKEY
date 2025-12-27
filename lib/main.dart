import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/password_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/pin_setup_screen.dart';
import 'screens/pin_verification_screen.dart';
import 'screens/password_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
      ],
      child: MaterialApp(
        title: 'PassKEY',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isInitializing) {
          return const SplashScreen();
        }

        if (!authProvider.isPinSet) {
          return const PinSetupScreen();
        }

        if (!authProvider.isAuthenticated) {
          return const PinVerificationScreen();
        }

        return const PasswordListScreen();
      },
    );
  }
}
