import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/password_item.dart';
import 'password_add_edit_screen.dart';

class PasswordDetailScreen extends StatefulWidget {
  final PasswordItem password;

  const PasswordDetailScreen({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  bool _showPassword = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
    
    // Auto-clear clipboard after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PasswordAddEditScreen(
                    password: widget.password,
                  ),
                ),
              );
            },
            tooltip: 'Edit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.password.title,
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_outlined),
                          onPressed: () {
                            _copyToClipboard(
                                widget.password.title, 'Title');
                          },
                          tooltip: 'Copy Title',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Username Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username / Email',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.password.username,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_outlined),
                          onPressed: () {
                            _copyToClipboard(
                                widget.password.username, 'Username');
                          },
                          tooltip: 'Copy Username',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _showPassword
                                ? widget.password.password
                                : '•' * widget.password.password.length,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          tooltip: _showPassword ? 'Hide' : 'Show',
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_outlined),
                          onPressed: () {
                            _copyToClipboard(
                                widget.password.password, 'Password');
                          },
                          tooltip: 'Copy Password',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Notes Card
            if (widget.password.notes != null &&
                widget.password.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.password.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Metadata
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Information',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Created',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _formatDate(widget.password.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Updated',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _formatDate(widget.password.updatedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
