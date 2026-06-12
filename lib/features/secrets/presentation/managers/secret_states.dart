abstract class SecretState {}

class SecretInitialState extends SecretState {}

class SecretLoadingState extends SecretState {}

class SecretErrorState extends SecretState {
  final String errorMessage;
  SecretErrorState({required this.errorMessage});
}

class SecretDirtyState extends SecretState {}
