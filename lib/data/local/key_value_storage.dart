abstract interface class KeyValueStorage {
  Future<bool?> readBool(String key);
  Future<String?> readString(String key);

  Future<void> writeBool(String key, bool value);
  Future<void> writeString(String key, String value);

  Future<void> remove(String key);
}
