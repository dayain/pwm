import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

abstract class SecretEvent {}

class GetAllSecretsEvent extends SecretEvent {}

class AddSecretEvent extends SecretEvent {
  final SecretEntity newSecret;
  AddSecretEvent({required this.newSecret});
}

class UpdateSecretEvent extends SecretEvent {
  final SecretEntity updatedSecret;
  UpdateSecretEvent({required this.updatedSecret});
}

class DeleteSecretEvent extends SecretEvent {
  final String deleteId;
  DeleteSecretEvent({required this.deleteId});
}
