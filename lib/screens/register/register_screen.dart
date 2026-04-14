import 'package:flutter/material.dart';

import 'package:my_project/app/app_routes.dart';
import 'package:my_project/app/di.dart';
import 'package:my_project/domain/common/result.dart';
import 'package:my_project/widgets/app_scaffold.dart';
import 'package:my_project/widgets/app_text_field.dart';
import 'package:my_project/widgets/auth_footer_link.dart';
import 'package:my_project/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final result = await AppDi.authService.register(
      name: _name.text,
      email: _email.text,
      password: _pass.text,
    );

    if (!mounted) return;

    if (result is Err<void>) {
      final message = result.failure.message;
      setState(() {
        _isLoading = false;
        _errorText = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Register')),
      maxWidth: 420,
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 12),
          const Text('Create your account'),
          const SizedBox(height: 16),
          AppTextField(label: 'Name', hint: 'John Doe', controller: _name),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Email',
            hint: 'you@mail.com',
            controller: _email,
          ),
          const SizedBox(height: 12),
          AppTextField(label: 'Password', obscure: true, controller: _pass),
          const SizedBox(height: 16),
          PrimaryButton(
            text: _isLoading ? 'Creating...' : 'Create account',
            onPressed: _submit,
          ),
          if (_errorText != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 8),
          AuthFooterLink(
            prompt: 'Already have an account?',
            actionText: 'Sign in',
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
