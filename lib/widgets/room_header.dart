import 'package:flutter/material.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader({
    required this.roomName,
    required this.canGoPrev,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
    super.key,
  });

  final String roomName;
  final bool canGoPrev;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: <Widget>[
        IconButton(
          onPressed: canGoPrev ? onPrev : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous room',
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text('Room', style: subtitleStyle),
              Text(roomName, style: titleStyle),
            ],
          ),
        ),
        IconButton(
          onPressed: canGoNext ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next room',
        ),
      ],
    );
  }
}
