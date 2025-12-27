import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/password_item.dart';
import '../providers/password_provider.dart';

class PasswordAddEditScreen extends StatefulWidget {
  final PasswordItem? password;

  const PasswordAddEditScreen({
    Key? key,
    this.password,
  }) : super(key: key);

  @override
  State<PasswordAddEditScreen> createState() => _PasswordAddEditScreenState();
}

class _PasswordAddEditScreenState extends State<PasswordAddEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;
  bool _showPassword = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.password?.title ?? '');
    _usernameController =
        TextEditingController(text: widget.password?.username ?? '');
    _passwordController =
        TextEditingController(text: widget.password?.password ?? '');
    _notesController = TextEditingController(text: widget.password?.notes ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _savePassword() async {
    setState(() {
      _errorMessage = null;
    });

    if (_titleController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a title';
      });
      return;
    }

    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username or email';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final passwordProvider = context.read<PasswordProvider>();
    bool success;

    if (widget.password == null) {
      // Add new password
      final newPassword = PasswordItem(
        title: _titleController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      success = await passwordProvider.addPassword(newPassword);
    } else {
      // Update existing password
      final updatedPassword = widget.password!.copyWith(
        title: _titleController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      success = await passwordProvider.updatePassword(updatedPassword);
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.password == null
                ? 'Password added successfully'
                : 'Password updated successfully',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to save password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.password == null ? 'Add Password' : 'Edit Password',
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Gmail, Twitter, etc.',
                prefixIcon: const Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username or Email',
                hintText: 'e.g., user@example.com',
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any additional notes...',
                prefixIcon: const Icon(Icons.note_outlined),
                alignLabelWithHint: true,
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 24),
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
                onPressed: _isLoading ? null : _savePassword,
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
                    : Text(
                        widget.password == null ? 'Add Password' : 'Update Password',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
