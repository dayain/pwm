import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pwm/core/presentation/presentation_util.dart';
import 'package:pwm/core/utils/crypt_util.dart';
import 'package:pwm/features/secrets/data/datasources/secure_store.dart';
import 'package:pwm/features/secrets/domain/entities/banking_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/email_secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/secret_entity.dart';
import 'package:pwm/features/secrets/domain/entities/web_secret_entity.dart';
import 'package:pwm/features/secrets/presentation/helpers/view_secret_dialog.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_events.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_view_edit_vm.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_vm.dart';
import 'package:pwm/features/secrets/presentation/pages/secret_view_edit_modal.dart';

class SecretTile extends StatelessWidget {
  final SecretVM vm;
  final SecretEntity secret;
  const SecretTile({super.key, required this.vm, required this.secret});

  @override
  Widget build(BuildContext context) {
    if (secret is WebSecretEntity) {
      return _buildWebSecretCard(context);
    }
    if (secret is EmailSecretEntity) {
      return _buildEmailSecretCard(context);
    }
    if (secret is BankingSecretEntity) {
      return _buildBankingSecretCard(context);
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildWebSecretCard(BuildContext context) {
    final webSecret = secret as WebSecretEntity;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        // Forces Row children to stretch vertically
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Column 1: Full-height circular icon container
            Container(
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), // Match Card corner radius
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  SecretViewEditModal.show(context, webSecret, ActionMode.view);
                },
                icon: const Icon(
                  Icons.web_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

            // Column 2: Title and Subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      webSecret.userId!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      webSecret.title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Column 3: Action Pane (Edit, View, Delete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.grey),
                    onPressed: () {
                      // _showMasterKeyDialog(context, webSecret);
                      ViewSecretDialog.show(
                        context: context,
                        encryptedPassword: webSecret.password!,
                      );
                    }, // View action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      SecretViewEditModal.show(
                        context,
                        webSecret,
                        ActionMode.edit,
                      );
                    }, // Edit action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showMasterKeyDialogForDelete(context, webSecret.id);
                    }, // Delete action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSecretCard(BuildContext context) {
    final emailSecret = secret as EmailSecretEntity;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        // Forces Row children to stretch vertically
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Column 1: Full-height circular icon container
            Container(
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), // Match Card corner radius
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  SecretViewEditModal.show(
                    context,
                    emailSecret,
                    ActionMode.view,
                  );
                },
                icon: Icon(Icons.email_outlined, color: Colors.white, size: 30),
              ),
            ),

            // Column 2: Title and Subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emailSecret.emailId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emailSecret.title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Column 3: Action Pane (Edit, View, Delete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.grey),
                    onPressed: () {
                      // _showMasterKeyDialog(context, emailSecret);
                      ViewSecretDialog.show(
                        context: context,
                        encryptedPassword: emailSecret.password,
                      );
                    }, // View action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      SecretViewEditModal.show(
                        context,
                        emailSecret,
                        ActionMode.edit,
                      );
                    }, // Edit action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showMasterKeyDialogForDelete(context, emailSecret.id);
                    }, // Delete action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankingSecretCard(BuildContext context) {
    final bankSecret = secret as BankingSecretEntity;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        // Forces Row children to stretch vertically
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Column 1: Full-height circular icon container
            Container(
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), // Match Card corner radius
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  SecretViewEditModal.show(
                    context,
                    bankSecret,
                    ActionMode.view,
                  );
                },
                icon: Icon(Icons.money, color: Colors.white, size: 30),
              ),
            ),

            // Column 2: Title and Subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bankSecret.customerId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bankSecret.title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Column 3: Action Pane (Edit, View, Delete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.grey),
                    onPressed: () {
                      // _showMasterKeyDialog(context, bankSecret);
                      ViewSecretDialog.show(
                        context: context,
                        encryptedPassword: bankSecret.password,
                      );
                    }, // View action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      SecretViewEditModal.show(
                        context,
                        bankSecret,
                        ActionMode.edit,
                      );
                    }, // Edit action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showMasterKeyDialogForDelete(context, bankSecret.id);
                    }, // Delete action
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMasterKeyDialog(BuildContext context, SecretEntity secret) {
    final formKey = GlobalKey<FormState>();
    final _secureStore = SecureStore();
    final pwd = _getCorrectSecret(secret);
    if (pwd == null) {
      _showError(context, "Invalid Secret");
      return;
    }
    String masterKey = "";
    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: const Text("Enter Master Key"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter MasterKey",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => masterKey = v,
                  validator: (v) =>
                      ((v == null || v.trim().isEmpty) && v!.length < 6)
                      ? 'Required'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final isValid = await _secureStore.validateMasterKey(
                    CryptoUtil.fastHash(masterKey),
                  );
                  if (!dlgContext.mounted) return;
                  Navigator.pop(dlgContext);
                  if (!context.mounted) return;
                  if (isValid) {
                    _showDecryptedSecretBottomSheet(context, pwd);
                  } else {
                    _showError(context, "Invalid MasterKey");
                  }
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  void _showMasterKeyDialogForDelete(BuildContext context, String secretId) {
    final formKey = GlobalKey<FormState>();
    final _secureStore = SecureStore();

    String masterKey = "";
    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("Delete Secret?"),
              SizedBox(height: 2),
              Text(
                secretId,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(height: 10),
              const Text("Enter Master Key"),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter MasterKey",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => masterKey = v,
                  validator: (v) =>
                      ((v == null || v.trim().isEmpty) && v!.length < 6)
                      ? 'Required'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final isValid = await _secureStore.validateMasterKey(
                    CryptoUtil.fastHash(masterKey),
                  );
                  if (!dlgContext.mounted) return;
                  Navigator.pop(dlgContext);
                  if (!context.mounted) return;
                  if (isValid) {
                    // _showDecryptedSecretBottomSheet(context, pwd);
                    vm.updateSecretEvent.add(
                      DeleteSecretEvent(deleteId: secretId),
                    );
                    PresentationUtil.showMessage(context, "Deleted Secret....");
                  } else {
                    _showError(context, "Invalid MasterKey");
                  }
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  String? _getCorrectSecret(SecretEntity secret) =>
      secret is BankingSecretEntity
      ? secret.password
      : secret is EmailSecretEntity
      ? secret.password
      : secret is WebSecretEntity
      ? secret.password
      : null;

  void _showError(BuildContext context, String errorMessage) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

  void _showDecryptedSecretBottomSheet(
    BuildContext context,
    String encryptedPwd,
  ) {
    try {
      final decryptedPwd = CryptoUtil.decrypt(encryptedPwd);
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetContext) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Decrypted Password',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  decryptedPwd,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy to Clipboard'),
                  onPressed: () async {
                    // Clipboard operation is an implicit async gap
                    await Clipboard.setData(ClipboardData(text: decryptedPwd));
                    // Guard sheetContext after async clipboard execution
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);

                    // Guard parental context before hitting ScaffoldMessenger
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _showError(context, "Error in Decryption");
    }
  }
}
