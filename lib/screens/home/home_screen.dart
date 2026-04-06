import 'package:flutter/material.dart';

import 'package:my_project/app/app_routes.dart';
import 'package:my_project/widgets/app_scaffold.dart';
import 'package:my_project/widgets/metric_card.dart';
import 'package:my_project/widgets/metrics_grid.dart';
import 'package:my_project/widgets/room_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<_RoomSnapshot> _rooms = <_RoomSnapshot>[
    _RoomSnapshot(
      name: 'Living room',
      temperatureC: 22,
      humidityPercent: 45,
      isLightOn: true,
    ),
    _RoomSnapshot(
      name: 'Bedroom',
      temperatureC: 20,
      humidityPercent: 52,
      isLightOn: false,
    ),
    _RoomSnapshot(
      name: 'Kitchen',
      temperatureC: 24,
      humidityPercent: 40,
      isLightOn: true,
    ),
  ];

  int _roomIndex = 0;

  void _goPrevRoom() {
    if (_roomIndex <= 0) {
      return;
    }

    setState(() {
      _roomIndex -= 1;
    });
  }

  void _goNextRoom() {
    if (_roomIndex >= _rooms.length - 1) {
      return;
    }

    setState(() {
      _roomIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final room = _rooms[_roomIndex];
    final canGoPrev = _roomIndex > 0;
    final canGoNext = _roomIndex < _rooms.length - 1;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Room State'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.profile);
            },
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RoomHeader(
            roomName: room.name,
            canGoPrev: canGoPrev,
            canGoNext: canGoNext,
            onPrev: _goPrevRoom,
            onNext: _goNextRoom,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: MetricsGrid(
              children: <Widget>[
                MetricCard(
                  label: 'Temperature',
                  value: '${room.temperatureC}°C',
                  icon: Icons.thermostat,
                ),
                MetricCard(
                  label: 'Humidity',
                  value: '${room.humidityPercent}%',
                  icon: Icons.water_drop,
                ),
                MetricCard(
                  label: 'Light',
                  value: room.isLightOn ? 'ON' : 'OFF',
                  icon: room.isLightOn
                      ? Icons.lightbulb
                      : Icons.lightbulb_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomSnapshot {
  const _RoomSnapshot({
    required this.name,
    required this.temperatureC,
    required this.humidityPercent,
    required this.isLightOn,
  });

  final String name;
  final int temperatureC;
  final int humidityPercent;
  final bool isLightOn;
}
