import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/respository/secret_repository.dart';

class GetSecretsUsecase {
  final SecretRepository repository;
  GetSecretsUsecase({required this.repository});
  Future<List<SecretEntity>> call() async {
    return await repository.getSecrets();
  }
}
