import 'package:flutter/material.dart';
import 'package:pwm/core/presentation/custom_dialog_base.dart';
import 'package:pwm/core/utils/crypt_util.dart';
import 'package:pwm/features/secrets/data/datasources/secure_store.dart';
import 'package:pwm/features/secrets/presentation/helpers/view_secret_dialog.dart';

class MasterKeyDialog extends StatelessWidget {
  final Widget dialogTitle;
  MasterKeyDialog({super.key, required this.dialogTitle});
  // 1. Move mutable elements/controllers outside or mark variables as final
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SecureStore _secureStore = SecureStore();

  @override
  Widget build(BuildContext context) {
    String masterKey = "";
    return AlertDialog(
      title: dialogTitle,
      content: Form(
        key: _formKey,
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Required';
                }
                if (v.trim().length < 6) {
                  return 'Must be at least 6 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // 4. Return the wrapped custom object instead of a raw Enum
            Navigator.pop(
              context,
              MasterKeyDialogResult(resultType: ResultType.unknown),
            );
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final isValid = await _secureStore.validateMasterKey(
                CryptoUtil.fastHash(masterKey.trim()),
              );
              final returnType = isValid ? ResultType.pass : ResultType.fail;
              if (!context.mounted) return;
              // 5. Wrap the enum inside MasterKeyDialogResult to match <T extends DialogResultData>
              Navigator.pop(
                context,
                MasterKeyDialogResult(resultType: returnType),
              );
            }
          },
          child: const Text("Verify"),
        ),
      ],
    );
  }
}
