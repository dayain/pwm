import 'package:rxdart/rxdart.dart';

class GenerateSecretVM {
  final String generatedPwd;
  GenerateSecretVM({required this.generatedPwd}) {
    _refreshPasswordSubject.add(generatedPwd);
  }

  final _refreshPasswordSubject = BehaviorSubject<String>.seeded("");

  // from UI
  Sink<String> get refreshPassword => _refreshPasswordSubject.sink;
  //  to UI
  ValueStream<String> get newPassword => _refreshPasswordSubject.stream;

  void dispose() {
    _refreshPasswordSubject.close();
  }
}
