import 'package:flutter/material.dart';

enum ResultType { pass, fail, unknown }

abstract class DialogResultData {
  final ResultType resultType;
  DialogResultData({required this.resultType});
}

// example this will go to the caller
// class MasterKeyDialogResult extends DialogResultData {
//   MasterKeyDialogResult({required super.resultType});
// }

Future<T?> showCustomDialog<T extends DialogResultData>({
  required BuildContext context,
  required Widget dialogContent,
  Duration duration = const Duration(milliseconds: 400),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Custom Dialog",
    barrierColor: Colors.black.withAlpha(140),
    transitionDuration: duration,

    pageBuilder: (context, animation, secondaryAnimation) {
      return dialogContent;
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Option A: Smooth Scale-In / Bounce Effect
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return ScaleTransition(scale: curvedAnimation, child: child);
      /* 
      // Option B: Slide-Up Effect (Uncomment to use instead of Scale)
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4), // Starts slightly below the screen center
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
      */
    },
  );
}
