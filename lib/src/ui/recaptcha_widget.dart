library;

import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';

/// A widget that integrates Google's reCAPTCHA into your Flutter application,
/// supporting both web and mobile platforms.
///
/// Example usage:
/// ```dart
/// FlutterSecureRecaptcha(
///   siteKey: 'your-site-key',
///   recaptchaHostDomain: 'example.com',
///   onVerifiedSuccessfully: (token) => print('Verified: $token'),
///   onFailed: () => print('Verification failed'),
/// );
/// ```
///
/// ### Required Parameters:
/// - `siteKey`: The site key provided by Google reCAPTCHA.
/// - `recaptchaHostDomain`: Required only for mobile to load the secure `recaptcha.html`.
///
/// ### Optional Callbacks:
/// - `onVerifiedSuccessfully`: Triggered with a `token` when reCAPTCHA is successful.
/// - `onFailed`: Called when verification fails or is canceled.

typedef OnRecaptchaVerified = void Function(String token);

class FlutterSecureRecaptcha extends StatelessWidget {
  /// Your Google reCAPTCHA site key.
  final String siteKey;

  /// Callback when verification is successful.
  final OnRecaptchaVerified onVerifiedSuccessfully;

  /// Domain used to validate mobile webview reCAPTCHA.
  final String recaptchaHostDomain;

  FlutterSecureRecaptcha({
    super.key,
    required this.siteKey,
    required this.recaptchaHostDomain,
    required this.onVerifiedSuccessfully,
  })  : assert(siteKey.length > 10, 'Invalid or missing siteKey'),
        assert(
            recaptchaHostDomain.isNotEmpty, 'recaptchaHostDomain is required');

  @override
  Widget build(BuildContext context) {
    return RecaptchaWidget(
      siteKey: siteKey,
      hostDomain: recaptchaHostDomain,
      onVerified: onVerifiedSuccessfully,
    );
  }
}
