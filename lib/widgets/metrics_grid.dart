import 'package:flutter/material.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final isWide = c.maxWidth >= 520;
        final crossAxisCount = isWide ? 2 : 1;

        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 110,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          children: children,
        );
      },
    );
  }
}
