import 'package:flutter/material.dart';

class PresentationUtil {
  static void showMessage(BuildContext context, String message) {
    if (!context.mounted || message.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    if (!context.mounted || message.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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
  }
}

  // static bool validateMasterKeyDialog(BuildContext context) {
  //   final formKey = GlobalKey<FormState>();
  //   final _secureStore = SecureStore();

  //   String masterKey = "";
  //   showDialog(
  //     context: context,
  //     builder: (dlgContext) {
  //       return AlertDialog(
  //         title: const Text("Enter Master Key"),
  //         content: Form(
  //           key: formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextFormField(
  //                 obscureText: true,
  //                 decoration: InputDecoration(
  //                   labelText: "Enter MasterKey",
  //                   border: OutlineInputBorder(),
  //                 ),
  //                 onChanged: (v) => masterKey = v,
  //                 validator: (v) =>
  //                     ((v == null || v.trim().isEmpty) && v!.length < 6)
  //                     ? 'Required'
  //                     : null,
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(dlgContext),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               if (formKey.currentState!.validate()) {
  //                 final isValid = await _secureStore.validateMasterKey(
  //                   CryptoUtil.fastHash(masterKey),
  //                 );
  //                 if (!dlgContext.mounted) return;
  //                 Navigator.pop(dlgContext);
  //                 if (!context.mounted) return;
  //                 if (isValid) {
  //                   _showDecryptedSecretBottomSheet(context, pwd);
  //                 } else {
  //                   _showError(context, "Invalid MasterKey");
  //                 }
  //               }
  //             },
  //             child: const Text("Verify"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
// }
