import 'package:flutter_secure_recaptcha/src/core/enums.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_platform.dart';
import 'package:flutter_secure_recaptcha/src/platform/recaptcha_stub.dart'
    if (dart.library.html) 'package:flutter_secure_recaptcha/src/platform/web/recaptcha_web.dart'
    if (dart.library.io) 'package:flutter_secure_recaptcha/src/platform/mobile/recaptcha_mobile.dart';

/// Factory class for creating platform-specific reCAPTCHA implementations.
///
/// This class uses conditional imports to select the appropriate implementation
/// based on the current platform.
class RecaptchaFactory {
  /// Creates a platform-specific reCAPTCHA implementation.
  ///
  /// This method returns either a web or mobile implementation based on
  /// the current platform.
  static RecaptchaPlatform createPlatform({
    required String siteKey,
    required String hostDomain,
    required Function(String) onVerified,
    Function(String)? onError,
    RecaptchaTheme theme = RecaptchaTheme.light,
    RecaptchaSize size = RecaptchaSize.normal,
    required RecaptchaController controller,
    double initialHeight = 150,
    double maxHeight = 500,
    double? width,
  }) {
    return getPlatformImplementation(
      siteKey: siteKey,
      hostDomain: hostDomain,
      onVerified: onVerified,
      onError: onError,
      theme: theme,
      size: size,
      controller: controller,
      initialHeight: initialHeight,
      maxHeight: maxHeight,
      width: width,
    );
  }
}
