import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.leading,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        leading ?? const CircleAvatar(radius: 28, child: Icon(Icons.person)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
