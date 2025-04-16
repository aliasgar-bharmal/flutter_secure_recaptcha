import 'package:flutter/widgets.dart';
import 'package:flutter_secure_recaptcha/src/core/enums.dart';

abstract class RecaptchaPlatform {
  final String siteKey;
  final String hostDomain;
  final Function(String) onVerified;
  final Function(String)? onError;
  final RecaptchaTheme theme;
  final RecaptchaSize size;
  final double initialHeight;
  final double maxHeight;
  final double? width;

  RecaptchaPlatform({
    required this.siteKey,
    required this.hostDomain,
    required this.onVerified,
    this.onError,
    this.theme = RecaptchaTheme.light,
    this.size = RecaptchaSize.normal,
    this.initialHeight = 150,
    this.maxHeight = 500,
    this.width,
  });

  Widget build(BuildContext context);
  Future<void> reset();
}
