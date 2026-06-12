import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwm/core/utils/crypt_util.dart';
import 'package:pwm/features/secrets/domain/entities/banking_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/email_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/web_secret_entity.dart';
import 'package:pwm/features/secrets/presentation/managers/add_secret_vm.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_events.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_vm.dart';
import 'package:uuid/uuid.dart';

class AddSecretForm extends StatelessWidget {
  const AddSecretForm({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddSecretForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final secretVM = Provider.of<SecretVM>(context, listen: false);
    return Provider<AddSecretVM>(
      create: (_) => AddSecretVM(),
      dispose: (_, vm) => vm.dispose(),
      builder: (context, _) {
        final addVM = Provider.of<AddSecretVM>(context, listen: false);
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Add New Secret",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                StreamBuilder<SecretType>(
                  stream: addVM.secretType$,
                  builder: (context, snap) {
                    final currentType = snap.data ?? SecretType.email;
                    return Column(
                      children: [
                        SegmentedButton<SecretType>(
                          segments: const [
                            ButtonSegment(
                              value: SecretType.email,
                              label: Text("Email"),
                            ),
                            ButtonSegment(
                              value: SecretType.web,
                              label: Text("Web"),
                            ),
                            ButtonSegment(
                              value: SecretType.banking,
                              label: Text("Bank"),
                            ),
                          ],
                          selected: {currentType},
                          onSelectionChanged: (s) =>
                              addVM.updateSecretType.add(s.first),
                        ),
                        const SizedBox(height: 16),
                        if (currentType == SecretType.email)
                          _buildEmailForm(context, secretVM)
                        else if (currentType == SecretType.web)
                          _buildWebForm(context, secretVM)
                        else if (currentType == SecretType.banking)
                          _buildBankForm(context, secretVM),
                        // dynamically render form parts based on the secret type selection stream
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailForm(BuildContext context, SecretVM vm) {
    final formKey = GlobalKey<FormState>();
    String title = "";
    String email = "";
    String password = "";

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => title = v,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Required" : null,
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => email = v,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(v)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => password = v,
              validator: (v) => v!.isEmpty || v.length < 6
                  ? "Required & minimum 6 chars"
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  vm.updateSecretEvent.add(
                    AddSecretEvent(
                      newSecret: EmailSecretEntity(
                        id: Uuid().v4(),
                        title: title,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        secretType: SecretType.email,
                        emailId: email,
                        password: CryptoUtil.encrypt(password),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebForm(BuildContext context, SecretVM vm) {
    final formKey = GlobalKey<FormState>();
    String title = "";
    String web = "";
    String userId = "";
    String password = "";

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => title = v,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "website name",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => web = v,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter website name'
                  : null,
            ),

            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "userId",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => userId = v,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter valid user id'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => password = v,
              validator: (v) => v!.isEmpty && v.length < 6
                  ? "Required & minimum 6 chars"
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  vm.updateSecretEvent.add(
                    AddSecretEvent(
                      newSecret: WebSecretEntity(
                        id: Uuid().v4(),
                        title: title,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        secretType: SecretType.web,
                        webAddress: web,
                        userId: userId,
                        password: CryptoUtil.encrypt(password),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankForm(BuildContext context, SecretVM vm) {
    final formKey = GlobalKey<FormState>();
    String title = "";
    String bankName = "";
    String customerId = "";
    String password = "";
    String profilePassword = "";

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => title = v,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Bank name",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => bankName = v,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "customer id",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => customerId = v,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => password = v,
              validator: (v) => v!.isEmpty && v.length < 6
                  ? "Required & minimum 6 chars"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Profile Password",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => profilePassword = v,
              validator: (v) => v!.isEmpty && v.length < 6
                  ? "Required & minimum 6 chars"
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  vm.updateSecretEvent.add(
                    AddSecretEvent(
                      newSecret: BankingSecretEntity(
                        id: Uuid().v4(),
                        title: title,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        secretType: SecretType.web,
                        bankName: bankName,
                        customerId: customerId,
                        password: CryptoUtil.encrypt(password),
                        profilePassword: CryptoUtil.encrypt(profilePassword),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
