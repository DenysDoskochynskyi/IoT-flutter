import random
import time

import paho.mqtt.client as mqtt


BROKER_HOST = "broker.hivemq.com"
BROKER_PORT = 1883
TOPIC = "sensor/temperature"
CLIENT_ID = "temp_publisher_lab4"
INTERVAL_SECONDS = 5


def main() -> None:
    client = mqtt.Client(client_id=CLIENT_ID, protocol=mqtt.MQTTv311)
    client.connect(BROKER_HOST, BROKER_PORT, keepalive=20)
    client.loop_start()

    temperature_c = 22.0

    try:
        while True:
            temperature_c += random.uniform(-0.6, 0.6)
            payload = f"{temperature_c:.1f}°C"
            client.publish(TOPIC, payload, qos=0, retain=False)
            print(f"Published to {TOPIC}: {payload}")
            time.sleep(INTERVAL_SECONDS)
    except KeyboardInterrupt:
        pass
    finally:
        client.loop_stop()
        client.disconnect()


if __name__ == "__main__":
    main()

