import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/respository/secret_repository.dart';

class UpdateSecretUsecase {
  final SecretRepository respository;
  UpdateSecretUsecase({required this.respository});
  Future<void> call(SecretEntity secret) async {
    await respository.updateSecret(secret);
  }
}
