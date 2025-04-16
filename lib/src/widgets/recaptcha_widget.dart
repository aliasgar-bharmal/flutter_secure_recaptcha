import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/enums.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';
import 'package:flutter_secure_recaptcha/src/platform/recaptcha_factory.dart';

class RecaptchaWidget extends StatefulWidget {
  final String siteKey;
  final String hostDomain;
  final Function(String) onVerified;
  final Function(String)? onError;
  final RecaptchaController? controller;
  final RecaptchaTheme theme;
  final RecaptchaSize size;

  // Initial height for the widget
  final double initialHeight;

  // Maximum height for the widget when expanded
  final double maxHeight;

  // Width of the widget
  final double? width;

  const RecaptchaWidget({
    Key? key,
    required this.siteKey,
    required this.hostDomain,
    required this.onVerified,
    this.onError,
    this.controller,
    this.theme = RecaptchaTheme.light,
    this.size = RecaptchaSize.normal,
    this.initialHeight = 150,
    this.maxHeight = 500, // Increased max height to accommodate challenges
    this.width,
  }) : super(key: key);

  @override
  State<RecaptchaWidget> createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  late final RecaptchaController _controller;
  late final dynamic _platformImplementation;
  double _currentHeight = 0;

  @override
  void initState() {
    super.initState();

    _currentHeight = widget.initialHeight;

    // Use provided controller or create a new one
    _controller = widget.controller ??
        RecaptchaController(
          siteKey: widget.siteKey,
          hostDomain: widget.hostDomain,
        );

    // Add listener for challenge visibility
    _controller.addListener(_handleControllerUpdate);

    // Create platform-specific implementation
    _platformImplementation = RecaptchaFactory.createPlatform(
      siteKey: widget.siteKey,
      hostDomain: widget.hostDomain,
      onVerified: (token) {
        // Reset height after verification
        widget.onVerified(token);
      },
      onError: (error) {
        widget.onError?.call(error);
      },
      theme: widget.theme,
      size: widget.size,
      controller: _controller,
      initialHeight: widget.initialHeight,
      maxHeight: widget.maxHeight,
    );
  }

  void _handleControllerUpdate() {
    // Update state based on controller changes
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerUpdate);

    // Only dispose the controller if we created it
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _platformImplementation.build(context);
  }
}

// library;

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';

// /// A widget that integrates Google's reCAPTCHA into your Flutter application,
// /// supporting both web and mobile platforms.
// ///
// /// Example usage:
// /// ```dart
// /// FlutterSecureRecaptcha(
// ///   siteKey: 'your-site-key',
// ///   recaptchaHostDomain: 'example.com',
// ///   onVerifiedSuccessfully: (token) => print('Verified: $token'),
// ///   onFailed: () => print('Verification failed'),
// /// );
// /// ```
// ///
// /// ### Required Parameters:
// /// - `siteKey`: The site key provided by Google reCAPTCHA.
// /// - `recaptchaHostDomain`: Required only for mobile to load the secure `recaptcha.html`.
// ///
// /// ### Optional Callbacks:
// /// - `onVerifiedSuccessfully`: Triggered with a `token` when reCAPTCHA is successful.
// /// - `onFailed`: Called when verification fails or is canceled.

// typedef OnRecaptchaVerified = void Function(String token);

// class FlutterSecureRecaptcha extends StatelessWidget {
//   /// Your Google reCAPTCHA site key.
//   final String siteKey;

//   /// Callback when verification is successful.
//   final OnRecaptchaVerified onVerifiedSuccessfully;

//   /// Domain used to validate mobile webview reCAPTCHA.
//   final String recaptchaHostDomain;

//   FlutterSecureRecaptcha({
//     super.key,
//     required this.siteKey,
//     required this.recaptchaHostDomain,
//     required this.onVerifiedSuccessfully,
//   })  : assert(siteKey.length > 10, 'Invalid or missing siteKey'),
//         assert(
//             recaptchaHostDomain.isNotEmpty, 'recaptchaHostDomain is required');

//   @override
//   Widget build(BuildContext context) {
//     return RecaptchaWidget(
//       siteKey: siteKey,
//       hostDomain: recaptchaHostDomain,
//       onVerified: onVerifiedSuccessfully,
//     );
//   }
// }
