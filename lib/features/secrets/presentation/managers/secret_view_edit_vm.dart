import 'package:rxdart/rxdart.dart';

enum ActionMode {
  view('view'),
  edit('edit');

  final String value;
  const ActionMode(this.value);

  /// Safe lookup to find matching enum from JSON strings.
  static ActionMode fromString(String value) {
    return ActionMode.values.firstWhere(
      (element) => element.value == value,
      orElse: () =>
          throw ArgumentError('Unsupported secret type string: $value'),
    );
  }
}

class SecretViewEditVM {
  final _actionModeSubject = BehaviorSubject<ActionMode>.seeded(
    ActionMode.view,
  );
  // UI generated
  Sink<ActionMode> get changeActionMode => _actionModeSubject.sink;
  // UI consumed
  ValueStream<ActionMode> get actionMode$ => _actionModeSubject.stream;

  void dispose() {
    _actionModeSubject.close();
  }
}
