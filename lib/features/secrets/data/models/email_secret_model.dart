import 'package:pwm/features/secrets/domain/entities/email_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

class EmailSecretModel extends EmailSecretEntity {
  const EmailSecretModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.secretType,
    required super.emailId,
    required super.password,
  });

  factory EmailSecretModel.fromJson(Map<String, dynamic> json) {
    return EmailSecretModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      secretType: SecretType.fromString(json['secretType'] as String),
      emailId: json['emailId'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'secretType': SecretType.email.value,
      'emailId': emailId,
      'password': password,
    };
  }
}
