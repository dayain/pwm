import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

class EmailSecretEntity extends SecretEntity {
  final String emailId;
  final String password;

  const EmailSecretEntity({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.secretType,
    required this.emailId,
    required this.password,
  });
}
