import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_events.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_vm.dart';
import 'package:pwm/features/secrets/presentation/pages/add_secret_form.dart';
import 'package:pwm/features/secrets/presentation/widgets/secret_tile.dart';

class SecretsHomePage extends StatelessWidget {
  const SecretsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SecretVM>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => vm.updateSecretEvent.add(GetAllSecretsEvent()),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Secrets")),
      body: StreamBuilder<List<SecretEntity>>(
        stream: vm.secrets$,
        builder: (context, snap) {
          final secrets = snap.data ?? [];
          if (secrets.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  "No Secrets Exist",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              itemCount: secrets.length,
              itemBuilder: (context, index) {
                final secret = secrets[index];
                return SecretTile(vm: vm, secret: secret);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddSecretForm.show(context);
        },
        // child: Container(
        //   width: 54, // Diameter of your inner circle
        //   height: 54, // Must match width for a perfect circle
        //   decoration: const BoxDecoration(
        //     color: Colors.blueAccent, // Blue background for the circle
        //     shape: BoxShape.circle, // Makes the container a perfect circle
        //   ),
        //   child: const Icon(
        //     Icons.person,
        //     color: Colors.white,
        //     size: 32, // Larger icon size to fill out the circle
        //   ),
        // ),
        backgroundColor: Colors.blue, // Sets the background color to blue
        foregroundColor: Colors.white, // Sets the plus sign icon color to white
        shape: const CircleBorder(), // Explicitly forces a perfect circle shape
        child: const Icon(Icons.add, size: 36), // The plus sign icon
      ),
    );
  }
}
