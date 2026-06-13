import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pwm/features/secrets/data/datasources/secret_local_datasource.dart';
import 'package:pwm/features/secrets/data/models/banking_secret_model.dart';
import 'package:pwm/features/secrets/data/models/email_secret_model.dart';
import 'package:pwm/features/secrets/data/models/secret_model_factory.dart';
import 'package:pwm/features/secrets/data/models/web_secret_model.dart';
import 'package:pwm/features/secrets/domain/entities/banking_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/email_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/web_secret_entity.dart';
import 'package:pwm/features/secrets/domain/respository/secret_repository.dart';

class SecretRepositoryImpl implements SecretRepository {
  final SecretLocalDataSource _localDataSource;
  final List<SecretEntity> _cachedSecrets = [];

  SecretRepositoryImpl({required this._localDataSource});

  @override
  Future<List<SecretEntity>> getSecrets() async => await _getSecrets();

  Future<void> _saveAllSecrets() async {
    final rawMapsList = _cachedSecrets
        .map((entity) => _mapEntityToModelJson(entity))
        .toList();
    // printSecrets();
    await _localDataSource.saveSecrets(rawMapsList);
  }

  /// Explicit domain-to-data mapping mechanism keeping boundaries intact.
  Map<String, dynamic> _mapEntityToModelJson(SecretEntity entity) {
    if (entity is EmailSecretEntity) {
      return EmailSecretModel(
        id: entity.id,
        title: entity.title,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        secretType: entity.secretType,
        emailId: entity.emailId,
        password: entity.password,
      ).toJson();
    }
    if (entity is WebSecretEntity) {
      return WebSecretModel(
        id: entity.id,
        title: entity.title,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        secretType: entity.secretType,
        webAddress: entity.webAddress,
        // isGoogleLogin: entity.isGoogleLogin,
        userId: entity.userId,
        password: entity.password,
      ).toJson();
    }
    if (entity is BankingSecretEntity) {
      return BankingSecretModel(
        id: entity.id,
        title: entity.title,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        secretType: entity.secretType,
        bankName: entity.bankName,
        customerId: entity.customerId,
        password: entity.password,
        profilePassword: entity.profilePassword,
      ).toJson();
    }
    throw ArgumentError(
      'Unsupported runtime domain entity mapping rule: ${entity.runtimeType}',
    );
  }

  @override
  Future<void> addSecret(SecretEntity secret) async {
    final found = _cachedSecrets.indexWhere((e) => e.id == secret.id);
    if (found == -1) {
      _cachedSecrets.add(secret);
      await _saveAllSecrets();
    }
  }

  @override
  Future<void> deleteSecret(String secretId) async {
    _cachedSecrets.removeWhere((e) => e.id == secretId);
    await _saveAllSecrets(); // if nothing to delete this is causing unneccessary disk write.
  }

  @override
  Future<void> updateSecret(SecretEntity updatedSecret) async {
    final index = _cachedSecrets.indexWhere((e) => e.id == updatedSecret.id);
    if (index != -1) {
      _cachedSecrets[index] = updatedSecret;
      await _saveAllSecrets();
    }
  }

  Future<List<SecretEntity>> _getSecrets() async {
    if (_cachedSecrets.isEmpty) {
      final rawList = await _localDataSource.readSecrets();
      _cachedSecrets.addAll(
        rawList.map((map) => SecretModelFactory.fromJson(map)).toList(),
      );
    }
    return _cachedSecrets;
  }

  void printSecrets() {
    final jsonList = _cachedSecrets.map(_mapEntityToModelJson).toList();
    if (kDebugMode) {
      print(const JsonEncoder.withIndent('   ').convert(jsonList));
    }
  }
}
