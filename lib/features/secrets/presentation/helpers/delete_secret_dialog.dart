import 'package:flutter/material.dart';
import 'package:pwm/core/presentation/custom_dialog_base.dart';
import 'package:pwm/core/presentation/presentation_util.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_events.dart';
import 'package:pwm/features/secrets/presentation/managers/secret_vm.dart';
import 'package:pwm/features/secrets/presentation/widgets/masterkey_dialog.dart';

class MasterKeyDialogResult extends DialogResultData {
  MasterKeyDialogResult({required super.resultType});
}

class DeleteSecretDialog {
  static Future<void> show({
    required BuildContext context,
    required String secretId,
    required SecretVM vm,
  }) async {
    // 1. Guard check before initiating the dialog route stack
    if (!context.mounted) return;
    // 2. Launch the dialog directly utilizing the active button context
    final result = await showCustomDialog<MasterKeyDialogResult>(
      context: context,
      dialogContent: MasterKeyDialog(
        dialogTitle: Column(
          children: [
            const Text("Delete Secret?"),
            SizedBox(height: 2),
            Text(
              secretId,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black.withAlpha(130),
              ),
            ),
            SizedBox(height: 10),
            const Text("Enter Master Key"),
          ],
        ),
      ), // Enforce your RxDart Stateless Dialog layout here
      duration: const Duration(milliseconds: 350),
    );
    // 3. Post-async loop guard check
    if (!context.mounted) return;
    // 4. Handle result data states safely
    if (result == null) {
      PresentationUtil.showError(context, "Dialog cancelled!");
      return; // User closed dialog manually via cancel button
    }
    if (result.resultType == ResultType.pass) {
      // push DeleteSecretEvent throgh the main screen the showing updated data
      vm.updateSecretEvent.add(DeleteSecretEvent(deleteId: secretId));
      if (!context.mounted) return;
      PresentationUtil.showMessage(context, "Deleted Successful...");
    } else if (result.resultType == ResultType.fail) {
      PresentationUtil.showError(context, "Invalid Master Key");
    } else {
      PresentationUtil.showError(context, "Dialog cancelled!");
    }
  }
}
