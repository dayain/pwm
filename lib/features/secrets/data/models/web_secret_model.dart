import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/web_secret_entity.dart';

class WebSecretModel extends WebSecretEntity {
  WebSecretModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.secretType,
    required super.webAddress,
    // required super.isGoogleLogin,
    super.userId,
    super.password,
  });

  factory WebSecretModel.fromJson(Map<String, dynamic> json) {
    return WebSecretModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      secretType: SecretType.fromString(json['secretType'] as String),
      webAddress: json['webAddress'] as String,
      // isGoogleLogin: json['isGoogleLogin'] as bool,
      userId: json['userId'] as String?,
      password: json['password'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'secretType': SecretType.web.value,
      'webAddress': webAddress,
      // 'isGoogleLogin': isGoogleLogin,
      'userId': userId,
      'password': password,
    };
  }
}
