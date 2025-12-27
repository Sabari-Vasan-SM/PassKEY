import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  late TextEditingController _pinController;
  bool _showPin = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verifyPin() async {
    setState(() {
      _errorMessage = null;
    });

    if (_pinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyPin(_pinController.text);

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      setState(() {
        _errorMessage = 'Incorrect PIN. Please try again.';
      });
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock PassKEY'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Enter your PIN',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the 4-digit PIN to unlock your passwords',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: _pinController,
              obscureText: !_showPin,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'PIN',
                hintText: '0000',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPin ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPin = !_showPin;
                    });
                  },
                ),
              ),
              onFieldSubmitted: (_) => _verifyPin(),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyPin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Unlock'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
