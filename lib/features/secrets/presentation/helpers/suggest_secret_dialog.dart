import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwm/core/presentation/presentation_util.dart';
import 'package:pwm/core/utils/pwd_generator.dart';
import 'package:pwm/features/secrets/presentation/managers/generate_secret_vm.dart';

class SuggestSecretDialog {
  static void showBottomSheet(BuildContext context, String generatedPwd) {
    final GenerateSecretVM vm = GenerateSecretVM(generatedPwd: generatedPwd);
    try {
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
                  'Generated Password',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                StreamBuilder<String>(
                  stream: vm.newPassword,
                  builder: (sheetContext, snap) {
                    if (!snap.hasData) return const CircularProgressIndicator();
                    return SelectableText(
                      snap.data!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy to Clipboard'),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: vm.newPassword.value),
                    );
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    vm.refreshPassword.add(SmartPasswordGenerator.generate());
                  },
                  child: Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(10, 5, 10, 5),
                    child: const Text(
                      "Refresh Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.blueAccent,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ).whenComplete(() => vm.dispose());
    } catch (_) {
      PresentationUtil.showError(context, "Unkown Error!");
    }
  }
}
