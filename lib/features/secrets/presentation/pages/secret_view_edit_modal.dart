import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwm/core/utils/crypt_util.dart';
import 'package:pwm/features/secrets/domain/entities/banking_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/email_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/web_secret_entity.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_events.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_view_edit_vm.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_vm.dart';

class SecretViewEditModal extends StatelessWidget {
  const SecretViewEditModal({
    super.key,
    required this.secret,
    required this.actionMode,
  });
  final SecretEntity secret;
  final ActionMode actionMode;
  // Helper method to instantiate the local vm for this specific view
  static void show(
    BuildContext context,
    SecretEntity secret,
    ActionMode actionType,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows bottom sheet to expand nicely with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) =>
          SecretViewEditModal(secret: secret, actionMode: actionType),
    );
  }

  const SecretViewEditModal._internal({
    required this.secret,
    required this.actionMode,
  });

  @override
  Widget build(BuildContext context) {
    final secretVM = Provider.of<SecretVM>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actionMode == ActionMode.edit
                  ? 'Edit ${actionMode.value} Secret'
                  : 'View ${actionMode.value} Secret',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 20),
            if (secret.secretType == SecretType.email)
              _buildEmailForm(
                context,
                secretVM,
                secret as EmailSecretEntity,
                actionMode,
              )
            else if (secret.secretType == SecretType.web)
              _buildWebForm(
                context,
                secretVM,
                secret as WebSecretEntity,
                actionMode,
              )
            else if (secret.secretType == SecretType.banking)
              _buildBankForm(
                context,
                secretVM,
                secret as BankingSecretEntity,
                actionMode,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailForm(
    BuildContext context,
    SecretVM vm,
    EmailSecretEntity secret,
    ActionMode mode,
  ) {
    final formKey = GlobalKey<FormState>();
    String title = secret.title;
    String email = secret.emailId;
    String password = secret.password;

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 5),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.title,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (v) => title = v,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      secret.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Email ID",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                secret.emailId,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => password = v,
                  validator: (v) => v!.isEmpty || v.length < 6
                      ? "Required & minimum 6 chars"
                      : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CryptoUtil.decrypt(secret.password),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          mode == ActionMode.edit
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          vm.updateSecretEvent.add(
                            UpdateSecretEvent(
                              updatedSecret: EmailSecretEntity(
                                id: secret.id,
                                title: title,
                                createdAt: secret.createdAt,
                                updatedAt: DateTime.now(),
                                secretType: SecretType.email,
                                emailId: email,
                                password: password == secret.password
                                    ? password
                                    : CryptoUtil.encrypt(password),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Update"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
        ],
      ),
    );
  }

  Widget _buildWebForm(
    BuildContext context,
    SecretVM vm,
    WebSecretEntity secret,
    ActionMode mode,
  ) {
    final formKey = GlobalKey<FormState>();
    String title = secret.title;
    String web = secret.webAddress;
    String userId = secret.userId!;
    String password = secret.password!;

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 5),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.title,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (v) => title = v,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      secret.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Web Name",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                secret.webAddress,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.userId,
                  decoration: InputDecoration(
                    labelText: "user id",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => userId = v,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "User ID",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      secret.userId!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => password = v,
                  validator: (v) => v!.isEmpty || v.length < 6
                      ? "Required & minimum 6 chars"
                      : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CryptoUtil.decrypt(secret.password!),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          mode == ActionMode.edit
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          vm.updateSecretEvent.add(
                            UpdateSecretEvent(
                              updatedSecret: WebSecretEntity(
                                id: secret.id,
                                title: title,
                                webAddress: secret.webAddress,
                                createdAt: secret.createdAt,
                                updatedAt: DateTime.now(),
                                secretType: SecretType.web,
                                userId: userId,
                                password: password == secret.password
                                    ? password
                                    : CryptoUtil.encrypt(password),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Update"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
        ],
      ),
    );
  }

  Widget _buildBankForm(
    BuildContext context,
    SecretVM vm,
    BankingSecretEntity secret,
    ActionMode mode,
  ) {
    final formKey = GlobalKey<FormState>();
    String title = secret.title;
    String bank = secret.bankName;
    String customerId = secret.customerId;
    String password = secret.password;
    String profilePassword = secret.profilePassword;

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 5),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.title,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (v) => title = v,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      secret.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bank Name",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                secret.bankName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Customer ID",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                secret.customerId,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => password = v,
                  validator: (v) => v!.isEmpty || v.length < 6
                      ? "Required & minimum 6 chars"
                      : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CryptoUtil.decrypt(secret.password!),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          mode == ActionMode.edit
              ? TextFormField(
                  initialValue: secret.profilePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "profile password",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => password = v,
                  validator: (v) => v!.isEmpty || v.length < 6
                      ? "Required & minimum 6 chars"
                      : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile Password",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CryptoUtil.decrypt(secret.profilePassword),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          mode == ActionMode.edit
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          vm.updateSecretEvent.add(
                            UpdateSecretEvent(
                              updatedSecret: BankingSecretEntity(
                                id: secret.id,
                                title: title,
                                bankName: secret.bankName,
                                customerId: secret.customerId,
                                createdAt: secret.createdAt,
                                updatedAt: DateTime.now(),
                                secretType: SecretType.banking,
                                password: password == secret.password
                                    ? password
                                    : CryptoUtil.encrypt(password),
                                profilePassword:
                                    profilePassword == secret.profilePassword
                                    ? profilePassword
                                    : CryptoUtil.encrypt(profilePassword),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Update"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
        ],
      ),
    );
  }
}
