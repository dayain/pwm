import 'package:pwm/features/secrets/domain/respository/secret_repository.dart';

class DeleteSecretUsecase {
  final SecretRepository respository;
  DeleteSecretUsecase({required this.respository});
  Future<void> call(String deleteId) async {
    await respository.deleteSecret(deleteId);
  }
}
