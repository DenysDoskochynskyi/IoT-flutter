import 'package:flutter/material.dart';

import 'package:my_project/app/app_routes.dart';
import 'package:my_project/app/di.dart';
import 'package:my_project/domain/common/result.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/widgets/app_scaffold.dart';
import 'package:my_project/widgets/app_text_field.dart';
import 'package:my_project/widgets/editable_section.dart';
import 'package:my_project/widgets/key_value_row.dart';
import 'package:my_project/widgets/section_card.dart';
import 'package:my_project/widgets/user_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final user = await AppDi.userRepository.readUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _isLoading = false;
    });
    _syncControllersFromUser();
  }

  void _syncControllersFromUser() {
    final user = _user;
    if (user == null) return;
    _name.text = user.name;
    _email.text = user.email;
    _pass.text = user.password;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      _errorText = null;
    });
    if (_isEditing) {
      _syncControllersFromUser();
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final result = AppDi.validators.validateRegister(
      name: _name.text,
      email: _email.text,
      password: _pass.text,
    );
    if (!mounted) return;

    if (result is Err<void>) {
      final message = result.failure.message;
      setState(() {
        _isSaving = false;
        _errorText = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    final updated = User(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _pass.text,
    );

    await AppDi.userRepository.saveUser(updated);
    if (!mounted) return;

    setState(() {
      _user = updated;
      _isSaving = false;
      _isEditing = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  Future<void> _logout() async {
    await AppDi.sessionStorage.logout();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> route) => false);
  }

  Future<void> _deleteUser() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete user?'),
          content: const Text(
            'This will remove your saved account from the device.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await AppDi.userRepository.deleteUser();
    await AppDi.sessionStorage.logout();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            onPressed: _isLoading ? null : _toggleEdit,
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            tooltip: _isEditing ? 'Cancel' : 'Edit',
          ),
        ],
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                UserHeader(
                  title: user?.name ?? 'No user',
                  subtitle: user?.email ?? '',
                  trailing: OutlinedButton(
                    onPressed: _logout,
                    child: const Text('Log out'),
                  ),
                ),
                const SizedBox(height: 16),
                EditableSection(
                  title: 'Account',
                  isEditing: _isEditing,
                  readChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      KeyValueRow(title: 'Name', value: user?.name ?? ''),
                      const SizedBox(height: 8),
                      KeyValueRow(title: 'Email', value: user?.email ?? ''),
                    ],
                  ),
                  editChild: Column(
                    children: <Widget>[
                      AppTextField(label: 'Name', controller: _name),
                      const SizedBox(height: 12),
                      AppTextField(label: 'Email', controller: _email),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: 'Password',
                        obscure: true,
                        controller: _pass,
                      ),
                    ],
                  ),
                  footer: !_isEditing
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            FilledButton(
                              onPressed: _isSaving ? null : _save,
                              child: Text(_isSaving ? 'Saving...' : 'Save'),
                            ),
                            if (_errorText != null) ...<Widget>[
                              const SizedBox(height: 8),
                              Text(
                                _errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: 'Danger zone',
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Delete local user',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: _deleteUser,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
