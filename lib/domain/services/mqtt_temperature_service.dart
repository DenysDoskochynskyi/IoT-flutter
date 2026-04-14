import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

abstract interface class MqttTemperatureService {
  Future<void> connect();
  Future<void> disconnect();
  Stream<String> watchTemperature();
}

final class MqttTemperatureServiceImpl implements MqttTemperatureService {
  MqttTemperatureServiceImpl({
    required String host,
    required String clientId,
    required String topic,
    int port = 1883,
  }) : _topic = topic,
       _client = MqttServerClient(host, clientId) {
    _client.port = port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
  }

  final String _topic;
  final MqttServerClient _client;

  final StreamController<String> _temp = StreamController<String>.broadcast();

  bool _isConnected = false;

  @override
  Stream<String> watchTemperature() => _temp.stream;

  @override
  Future<void> connect() async {
    if (_isConnected) return;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(_client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (_) {
      _client.disconnect();
      rethrow;
    }

    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      _client.disconnect();
      throw StateError('MQTT not connected');
    }

    _isConnected = true;
    _client.subscribe(_topic, MqttQos.atMostOnce);

    _client.updates?.listen((events) {
      if (events.isEmpty) return;
      final rec = events.first.payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        rec.payload.message,
      );
      if (!_temp.isClosed) _temp.add(payload);
    });
  }

  @override
  Future<void> disconnect() async {
    if (!_isConnected) return;
    _isConnected = false;
    _client.disconnect();
  }
}
