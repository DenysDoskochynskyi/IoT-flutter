import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({required this.title, required this.value, super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    final muted = style?.copyWith(color: Colors.grey[600]);

    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: muted)),
        Text(value, style: style),
      ],
    );
  }
}
