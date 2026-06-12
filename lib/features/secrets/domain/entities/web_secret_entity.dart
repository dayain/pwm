import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

class WebSecretEntity extends SecretEntity {
  final String webAddress;
  // final bool isGoogleLogin;
  final String? userId;
  final String? password;

  const WebSecretEntity({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.secretType,
    required this.webAddress,
    // required this.isGoogleLogin,
    this.userId,
    this.password,
  });
}
