import 'package:pwm/features/secrets/data/models/banking_secret_model.dart';
import 'package:pwm/features/secrets/data/models/email_secret_model.dart';
import 'package:pwm/features/secrets/data/models/web_secret_model.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';

class SecretModelFactory {
  static SecretEntity fromJson(Map<String, dynamic> json) {
    final SecretType secretType = SecretType.fromString(
      json['secretType'] as String,
    );
    switch (secretType) {
      case SecretType.email:
        return EmailSecretModel.fromJson(json);
      case SecretType.web:
        return WebSecretModel.fromJson(json);
      case SecretType.banking:
        return BankingSecretModel.fromJson(json);
    }
  }
}
