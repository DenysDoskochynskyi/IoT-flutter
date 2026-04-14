import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_project/app/app_routes.dart';
import 'package:my_project/app/di.dart';
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

  bool _hasInternet = true;
  String? _mqttTemp;
  bool _mqttStarted = false;

  StreamSubscription<bool>? _internetSub;
  StreamSubscription<String>? _mqttSub;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final hasInternet = await AppDi.connectivityService.hasInternet();
    if (!mounted) return;

    setState(() {
      _hasInternet = hasInternet;
    });

    if (!hasInternet) {
      _showOfflineSnack();
    } else {
      await _startMqtt();
    }

    _internetSub = AppDi.connectivityService.watchInternet().listen((online) {
      if (!mounted) return;
      final wasOnline = _hasInternet;
      setState(() {
        _hasInternet = online;
      });

      if (!online && wasOnline) {
        _showOfflineSnack();
      }

      if (online && !_mqttStarted) {
        _startMqtt();
      }
    });
  }

  void _showOfflineSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Offline mode: MQTT disabled.')),
    );
  }

  Future<void> _startMqtt() async {
    if (_mqttStarted) return;
    _mqttStarted = true;

    try {
      await AppDi.mqttTemperatureService.connect();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mqttStarted = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MQTT connection failed.')),
      );
      return;
    }

    _mqttSub = AppDi.mqttTemperatureService.watchTemperature().listen((value) {
      if (!mounted) return;
      setState(() {
        _mqttTemp = value;
      });
    });
  }

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
  void dispose() {
    _internetSub?.cancel();
    _mqttSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = _rooms[_roomIndex];
    final canGoPrev = _roomIndex > 0;
    final canGoNext = _roomIndex < _rooms.length - 1;

    final temperatureValue = _hasInternet
        ? (_mqttTemp ?? '${room.temperatureC}°C')
        : '${room.temperatureC}°C';

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
          if (!_hasInternet)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.wifi_off),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No Internet connection. Some features are disabled.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                  value: temperatureValue,
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
