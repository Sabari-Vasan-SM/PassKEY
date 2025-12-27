import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/password_item.dart';
import '../providers/password_provider.dart';
import 'password_add_edit_screen.dart';
import 'password_detail_screen.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({Key? key}) : super(key: key);

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  @override
  void initState() {
    super.initState();
    // Load passwords when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasswordProvider>().loadPasswords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_open),
            onPressed: () {
              context.read<PasswordProvider>().loadPasswords();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<PasswordProvider>(
        builder: (context, passwordProvider, _) {
          if (passwordProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (passwordProvider.passwords.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.key_off_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Passwords Yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Add your first password to get started',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PasswordAddEditScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Password'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: passwordProvider.passwords.length,
            itemBuilder: (context, index) {
              final password = passwordProvider.passwords[index];
              return _PasswordCard(password: password);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PasswordAddEditScreen(),
            ),
          );
        },
        tooltip: 'Add Password',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PasswordCard extends StatefulWidget {
  final PasswordItem password;

  const _PasswordCard({required this.password});

  @override
  State<_PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<_PasswordCard> {
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          widget.password.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              widget.password.username,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('View'),
              onTap: () {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PasswordDetailScreen(password: widget.password),
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              child: const Text('Copy Password'),
              onTap: () {
                _copyToClipboard(widget.password.password, 'Password');
              },
            ),
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: () {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PasswordAddEditScreen(
                        password: widget.password,
                      ),
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PasswordDetailScreen(password: widget.password),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Password?'),
        content: Text(
          'Are you sure you want to delete "${widget.password.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PasswordProvider>().deletePassword(widget.password.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password deleted'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
