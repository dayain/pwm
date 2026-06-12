import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pwm/features/secrets/data/datasources/secret_local_datasource.dart';

class SecretLocalDataSourceImpl implements SecretLocalDataSource {
  static const String _fileName = 'secrets_vault.json';

  const SecretLocalDataSourceImpl();

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  @override
  Future<void> saveSecrets(List<Map<String, dynamic>> rawSecretsList) async {
    final file = await _localFile;
    final jsonString = jsonEncode(rawSecretsList);
    await file.writeAsString(jsonString);
  }

  @override
  Future<List<Map<String, dynamic>>> readSecrets() async {
    try {
      final file = await _localFile;
      debugPrint('File location ..  ${file.path}');
      if (!await file.exists()) return [];
      debugPrint('File exist ..  ${file.path}');
      final jsonString = await file.readAsString();
      debugPrint('file contents ..  $jsonString');
      if (jsonString.trim().isEmpty) return [];

      final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;

      return decodedList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      throw StorageException('Failed to read or parse local file data: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;
  const StorageException(this.message);
  @override
  String toString() => 'StorageException: $message';
}
