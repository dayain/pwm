import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/respository/secret_repository.dart';

class SaveSecretUsecase {
  final SecretRepository respository;
  SaveSecretUsecase({required this.respository});
  Future<void> call(SecretEntity secret) async {
    await respository.addSecret(secret);
  }
}
