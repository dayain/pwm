import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

class BankingSecretEntity extends SecretEntity {
  final String bankName;
  final String customerId;
  final String password;
  final String profilePassword;

  const BankingSecretEntity({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.secretType,
    required this.bankName,
    required this.customerId,
    required this.password,
    required this.profilePassword,
  });
}
