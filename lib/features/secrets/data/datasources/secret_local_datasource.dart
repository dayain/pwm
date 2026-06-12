abstract class SecretLocalDataSource {
  /// Serializes and writes data models to disk.
  Future<void> saveSecrets(List<Map<String, dynamic>> rawSecretsList);

  /// Reads and parses raw database models from disk.
  Future<List<Map<String, dynamic>>> readSecrets();
}
