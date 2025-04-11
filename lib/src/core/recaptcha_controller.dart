import 'package:flutter/material.dart';

import 'package:flutter_secure_recaptcha/src/platform/recaptcha_default.dart'
    if (dart.library.html) 'package:flutter_secure_recaptcha/src/platform/recaptcha_web.dart'
    if (dart.library.io) 'package:flutter_secure_recaptcha/src/platform/recaptcha_mobile.dart';

/// Signature for the success callback providing the verification token.
typedef RecaptchaSuccessCallback = void Function(String token);

/// A platform-aware widget that invokes the correct reCAPTCHA implementation
/// based on the target platform (web or mobile).
///
/// Do not use this widget directly; instead, use [FlutterSecureRecaptcha].
class RecaptchaWidget extends StatefulWidget {
  /// The site key provided by Google reCAPTCHA.
  final String siteKey;

  /// Callback when reCAPTCHA verification succeeds.
  final RecaptchaSuccessCallback onVerified;

  /// The domain hosting the recaptcha.html for mobile webview.
  ///
  /// This must be a valid domain when targeting mobile platforms.
  final String hostDomain;

  const RecaptchaWidget({
    super.key,
    required this.siteKey,
    required this.hostDomain,
    required this.onVerified,
  });

  @override
  State<RecaptchaWidget> createState() => createRecaptchaState();
}
