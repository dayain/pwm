import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:rxdart/rxdart.dart';

class AddSecretVM {
  final _secretTypeSubject = BehaviorSubject<SecretType>.seeded(
    SecretType.email,
  );
  // from ui
  Sink<SecretType> get updateSecretType => _secretTypeSubject.sink;
  // rendering in UI
  ValueStream<SecretType> get secretType$ => _secretTypeSubject.stream;

  void dispose() {
    _secretTypeSubject.close();
  }
}
