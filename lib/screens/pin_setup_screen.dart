import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({Key? key}) : super(key: key);

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  late TextEditingController _pinController;
  late TextEditingController _confirmPinController;
  bool _showPin = false;
  bool _showConfirmPin = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _validateAndSetup() async {
    setState(() {
      _errorMessage = null;
    });

    if (_pinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a PIN';
      });
      return;
    }

    if (_pinController.text.length != 4) {
      setState(() {
        _errorMessage = 'PIN must be exactly 4 digits';
      });
      return;
    }

    if (!RegExp(r'^\d+$').hasMatch(_pinController.text)) {
      setState(() {
        _errorMessage = 'PIN must contain only numbers';
      });
      return;
    }

    if (_confirmPinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please confirm your PIN';
      });
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      setState(() {
        _errorMessage = 'PINs do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.setupPin(_pinController.text);

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      setState(() {
        _errorMessage = 'Failed to set PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your PIN'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Create a 4-digit PIN',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This PIN will be used to unlock your passwords',
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
                labelText: 'Enter PIN',
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
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _confirmPinController,
              obscureText: !_showConfirmPin,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                hintText: '0000',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPin ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPin = !_showConfirmPin;
                    });
                  },
                ),
              ),
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
                onPressed: _isLoading ? null : _validateAndSetup,
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
                    : const Text('Create PIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
