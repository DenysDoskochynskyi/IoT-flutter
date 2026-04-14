import 'package:flutter/material.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.prompt,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String prompt;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(prompt),
        TextButton(onPressed: onTap, child: Text(actionText)),
      ],
    );
  }
}
