// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_recaptcha/src/core/enums.dart';
// import 'package:flutter_secure_recaptcha/src/widgets/recaptcha_widget.dart';
// import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';

// /// Helper class for working with reCAPTCHA.
// ///
// /// This class provides utility methods for showing reCAPTCHA dialogs
// /// and handling verification.
// class RecaptchaHelper {
//   /// Shows a reCAPTCHA dialog and returns the verification token.
//   ///
//   /// This method shows a dialog with a reCAPTCHA widget and returns the
//   /// verification token when the user completes the verification.
//   ///
//   /// Example:
//   /// ```dart
//   /// final token = await RecaptchaHelper.verify(
//   ///   context: context,
//   ///   siteKey: 'your-site-key',
//   ///   hostDomain: 'your-domain.com',
//   /// );
//   ///
//   /// if (token != null) {
//   ///   // Use the token for server-side verification
//   ///   print('Verified with token: $token');
//   /// } else {
//   ///   print('Verification cancelled or failed');
//   /// }
//   /// ```
//   static Future<String?> verify({
//     required BuildContext context,
//     required RecaptchaController controller,
//     RecaptchaTheme theme = RecaptchaTheme.light,
//     RecaptchaSize size = RecaptchaSize.normal,
//     Function(String)? onError,
//   }) async {
//     final completer = Completer<String?>();

//     // Create the widget
//     final widget = RecaptchaWidget(
//       controller: controller,
//       theme: theme,
//       size: size,
//       onVerified: (token) {
//         if (!completer.isCompleted) {
//           completer.complete(token);
//         }
//       },
//       onError: (error) {
//         onError?.call(error);
//         if (!completer.isCompleted) {
//           completer.completeError(error);
//         }
//       },
//     );

//     // Show the dialog
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.zero,
//           backgroundColor: Colors.transparent,
//           content: Container(
//             width: double.maxFinite,
//             constraints: BoxConstraints(
//               maxWidth: 400,
//               maxHeight: MediaQuery.of(context).size.height * 0.8,
//             ),
//             child: widget,
//           ),
//         );
//       },
//     ).then((_) {
//       // If the dialog is dismissed without verification, complete with null
//       if (!completer.isCompleted) {
//         completer.complete(null);
//       }
//     });

//     // Show the reCAPTCHA
//     controller.show();

//     try {
//       // Wait for verification or error
//       final token = await completer.future;

//       // Close the dialog
//       if (context.mounted) {
//         Navigator.of(context, rootNavigator: true).pop();
//       }

//       return token;
//       Navigator.of(context, rootNavigator: true).pop();
//     } catch (e) {
//       // Close the dialog on error
//       if (context.mounted) {
//         Navigator.of(context, rootNavigator: true).pop();
//       }
//       return null;
//     } finally {
//       // Dispose the controller
//       controller.dispose();
//     }
//   }
// }
