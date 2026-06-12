import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwm/features/secrets/data/datasources/secret_local_datasource.dart';
import 'package:pwm/features/secrets/data/datasources/secret_local_datasource_impl.dart';
import 'package:pwm/features/secrets/data/respository/secret_repository_impl.dart';
import 'package:pwm/features/secrets/domain/respository/secret_repository.dart';
import 'package:pwm/features/secrets/domain/usecases/delete_secret_usecase.dart';
import 'package:pwm/features/secrets/domain/usecases/get_secrets_usecase.dart';
import 'package:pwm/features/secrets/domain/usecases/save_secret_usecase.dart';
import 'package:pwm/features/secrets/domain/usecases/update_secret_usecase.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_vm.dart';
import 'package:pwm/features/secrets/presentation/pages/secrets_home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<SecretLocalDataSource>(
          create: (_) => SecretLocalDataSourceImpl(),
        ),
        ProxyProvider<SecretLocalDataSource, SecretRepository>(
          update: (_, datasource, _) =>
              SecretRepositoryImpl(localDataSource: datasource),
        ),
        ProxyProvider<SecretRepository, GetSecretsUsecase>(
          update: (_, repo, _) => GetSecretsUsecase(repository: repo),
        ),
        ProxyProvider<SecretRepository, SaveSecretUsecase>(
          update: (_, repo, _) => SaveSecretUsecase(respository: repo),
        ),
        ProxyProvider<SecretRepository, UpdateSecretUsecase>(
          update: (_, repo, _) => UpdateSecretUsecase(respository: repo),
        ),
        ProxyProvider<SecretRepository, DeleteSecretUsecase>(
          update: (_, repo, _) => DeleteSecretUsecase(respository: repo),
        ),
        ProxyProvider4<
          GetSecretsUsecase,
          SaveSecretUsecase,
          UpdateSecretUsecase,
          DeleteSecretUsecase,
          SecretVM
        >(
          update: (_, getu, saveu, updateu, deleteu, _) => SecretVM(
            deleteSecretUsecase: deleteu,
            getSecretsUsecase: getu,
            saveSecretUsecase: saveu,
            updateSecretUsecase: updateu,
          ),
          dispose: (_, vm) => vm.dispose(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Secrets Management",
      home: SecretsHomePage(),
    );
  }
}
