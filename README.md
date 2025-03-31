# IoT-flutter  
IoT Flutter Lab  

## Лабораторна робота №4: Авторизація та робота з MQTT-пристроями

### Опис:

Настав час зануритися не лише у Flutter, а й у світ IoT(єхидно сміюся). У цій лабораторній роботі ви маєте:

1. **Реалізувати повний цикл авторизації**:
   - Реєстрація користувача;
   - Звичайний логін;
   - Автоматичний вхід у додаток, якщо сесія збережена;
   - Вихід із додатку з підтвердженням (діалог).

2. **Реалізувати роботу з MQTT-датчиком**:
   - Підключення до публічного або локального MQTT-брокера;
   - Підписка на топік (наприклад, `sensor/temperature`);
   - Обробка та відображення отриманих даних (наприклад, температура);
   - Можна симулювати публікацію даних за допомогою:
     - Власного скрипта (Python, Node.js тощо);
     - Фізичного МК (наприклад, ESP8266/ESP32);
     - Онлайн-інструментів (HiveMQ Web Client, MQTT Explorer, Mosquitto CLI).

3. **Реалізувати перевірку підключення до Інтернету:**
   - При спробі входу без з’єднання – показати повідомлення;
   - Після входу – слідкувати за з’єднанням і повідомляти про втрату;
   - Якщо спрацював автологін без Інтернету – дати доступ, але попередити про відсутність мережі (можна обмежити функціонал).

---

## Вимоги до реалізації:

- Усі сценарії користувача (логін, автологін, логін без мережі, розлогін тощо) **мають працювати стабільно**.
- Код має бути **відформатований згідно з лінтером**, який вже був доданий до репозиторію.
- **MQTT-зв’язок повинен працювати** та передавати/відображати інформацію.
- Виконується у **тому ж репозиторії, що і ЛР3**.
  - Спочатку мержите зміни ЛР3 в `main`, потім створюєте **нову гілку для ЛР4**, і робите pull request на `main`.

---

## Приклад: підписка на MQTT-дані (температура)

```
dart
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('broker.hivemq.com', 'flutter_client_id');

Future<void> connectAndListen() async {
  client.port = 1883;
  client.logging(on: false);
  client.keepAlivePeriod = 20;
  client.onDisconnected = () => print('Disconnected');
  client.onConnected = () => print('Connected to broker');

  final connMessage = MqttConnectMessage()
      .withClientIdentifier('flutter_client_id')
      .startClean()
      .withWillQos(MqttQos.atMostOnce);
  client.connectionMessage = connMessage;

  try {
    await client.connect();
  } catch (e) {
    print('Connection failed: $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('MQTT Connected!');
    client.subscribe('sensor/temperature', MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('Received temperature: $payload');
    });
  }
}
```

---

## Корисні ресурси:

### MQTT:
- HiveMQ Public Broker: [https://www.hivemq.com/demos/websocket-client/](https://www.hivemq.com/demos/websocket-client/)
- MQTT у Flutter: [mqtt_client](https://pub.dev/packages/mqtt_client)
- MQTT Explorer: [https://mqtt-explorer.com/](https://mqtt-explorer.com/)

### Плагіни Flutter:
- **connectivity_plus** – для перевірки інтернету: [Посилання](https://pub.dev/packages/connectivity_plus)
- **flutter_secure_storage** – зберігання токенів: [Посилання](https://pub.dev/packages/flutter_secure_storage)
- **provider** – для управління станом: [Посилання](https://pub.dev/packages/provider)

---

## Рекомендації до захисту:

- Що таке плагіни/пакети і чим вони відрізняються;
- Що таке MQTT, топік, брокер, QoS;
- Як працює async/await, Stream;
- Як зберігаються сесії користувача;
- Що таке Provider і навіщо він потрібен.

---

**Успіхів у розробці! Нехай ваші віртуальні датчики завжди працюють стабільно як і психіка😉**
