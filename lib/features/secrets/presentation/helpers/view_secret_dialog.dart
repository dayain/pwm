import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwm/core/presentation/custom_dialog_base.dart';
import 'package:pwm/core/presentation/presentation_util.dart';
import 'package:pwm/core/utils/crypt_util.dart';
import 'package:pwm/features/secrets/presentation/widgets/masterkey_dialog.dart';

class MasterKeyDialogResult extends DialogResultData {
  MasterKeyDialogResult({required super.resultType});
}

class ViewSecretDialog {
  static Future<void> show({
    required BuildContext context,
    required String encryptedPassword,
  }) async {
    // 1. Guard check before initiating the dialog route stack
    if (!context.mounted) return;
    // 2. Launch the dialog directly utilizing the active button context
    final result = await showCustomDialog<MasterKeyDialogResult>(
      context: context,
      dialogContent: MasterKeyDialog(
        dialogTitle: const Text("Enter Master Key"),
      ), // Enforce your RxDart Stateless Dialog layout here
      duration: const Duration(milliseconds: 350),
    );
    // 3. Post-async loop guard check
    if (!context.mounted) return;
    // 4. Handle result data states safely
    if (result == null) return; // User closed dialog manually via cancel button
    if (result.resultType == ResultType.pass) {
      _showDecryptedSecretBottomSheet(context, encryptedPassword);
    } else if (result.resultType == ResultType.fail) {
      PresentationUtil.showError(context, "Invalid Master Key");
    } else {
      PresentationUtil.showError(context, "Dialog cancelled!");
    }
  }

  static void _showDecryptedSecretBottomSheet(
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
                    await Clipboard.setData(ClipboardData(text: decryptedPwd));
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);

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
    } catch (_) {
      PresentationUtil.showError(context, "Error in Decryption");
    }
  }
}
