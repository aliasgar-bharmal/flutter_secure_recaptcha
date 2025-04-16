import 'package:flutter_secure_recaptcha/src/core/enums.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_platform.dart';

/// Stub implementation that will be replaced by platform-specific implementations.
RecaptchaPlatform getPlatformImplementation({
  required String siteKey,
  required String hostDomain,
  required Function(String) onVerified,
  Function(String)? onError,
  required RecaptchaTheme theme,
  required RecaptchaSize size,
  required RecaptchaController controller,
  required double initialHeight,
  required double maxHeight,
  required double? width,
}) {
  throw UnsupportedError(
    'No implementation found for getPlatformImplementation',
  );
}
