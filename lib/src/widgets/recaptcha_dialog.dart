import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';

/// A dialog that displays a reCAPTCHA verification interface.
///
/// This dialog is used by both web and mobile implementations to provide
/// a consistent user experience across platforms.
class RecaptchaDialog extends StatelessWidget {
  /// The child widget to display in the dialog
  final Widget child;
  
  /// Controller for managing reCAPTCHA state
  final RecaptchaController controller;
  
  /// Creates a new RecaptchaDialog instance.
  const RecaptchaDialog({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: child,
              ),
            ),
            
            // Close button
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => controller.hide(),
                tooltip: 'Close',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Shows the reCAPTCHA dialog.
  ///
  /// This method creates and shows a dialog containing the reCAPTCHA widget.
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    required RecaptchaController controller,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RecaptchaDialog(
          child: child,
          controller: controller,
        );
      },
    );
  }
}