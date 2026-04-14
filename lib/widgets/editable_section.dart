import 'package:flutter/material.dart';

import 'package:my_project/widgets/section_card.dart';

class EditableSection extends StatelessWidget {
  const EditableSection({
    required this.title,
    required this.isEditing,
    required this.readChild,
    required this.editChild,
    this.footer,
    super.key,
  });

  final String title;
  final bool isEditing;
  final Widget readChild;
  final Widget editChild;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isEditing) editChild else readChild,
          if (footer != null) ...<Widget>[const SizedBox(height: 12), footer!],
        ],
      ),
    );
  }
}
