import 'package:pwm/features/secrets/domain/entities/banking_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

class BankingSecretModel extends BankingSecretEntity {
  const BankingSecretModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.secretType,
    required super.bankName,
    required super.customerId,
    required super.password,
    required super.profilePassword,
  });

  factory BankingSecretModel.fromJson(Map<String, dynamic> json) {
    return BankingSecretModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      secretType: SecretType.fromString(json['secretType'] as String),
      bankName: json['bankName'] as String,
      customerId: json['customerId'] as String,
      password: json['password'] as String,
      profilePassword: json['profilePassword'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'secretType': SecretType.banking.value,
      'bankName': bankName,
      'customerId': customerId,
      'password': password,
      'profilePassword': profilePassword,
    };
  }
}
