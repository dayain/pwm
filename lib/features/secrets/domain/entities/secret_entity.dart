enum SecretType {
  email('email'),
  web('web'),
  banking('banking');

  final String value;
  const SecretType(this.value);

  /// Safe lookup to find matching enum from JSON strings.
  static SecretType fromString(String value) {
    return SecretType.values.firstWhere(
      (element) => element.value == value,
      orElse: () =>
          throw ArgumentError('Unsupported secret type string: $value'),
    );
  }
}

abstract class SecretEntity {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SecretType secretType;

  const SecretEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.secretType,
  });
}
