import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

abstract class SecretRepository {
  /// Fetches the latest collection of secrets from disk once.
  Future<List<SecretEntity>> getSecrets();

  /// Persists a complete collection of domain entities down to disk.
  // Future<void> saveAllSecrets(List<SecretEntity> secrets);
  Future<void> addSecret(SecretEntity secret);
  Future<void> updateSecret(SecretEntity updatedSecret);
  Future<void> deleteSecret(String secretId);
}
