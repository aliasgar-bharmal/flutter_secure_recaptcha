import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/enums.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_platform.dart';

/// Web-specific implementation of the reCAPTCHA platform.
///
/// This class handles the web implementation of reCAPTCHA using an iframe
/// and HTML/JavaScript communication.
class RecaptchaWebPlatform extends RecaptchaPlatform {
  /// Controller for managing reCAPTCHA state
  final RecaptchaController controller;

  /// Unique ID for the HTML element view
  final String _viewId;

  /// Whether the view is ready to be displayed
  bool _viewReady = false;

  /// HTML iframe element
  late final html.IFrameElement _iframe;

  /// Creates a new RecaptchaWebPlatform instance.
  RecaptchaWebPlatform({
    required super.siteKey,
    required super.hostDomain,
    required super.onVerified,
    super.onError,
    super.theme,
    super.size,
    required this.controller,
    super.initialHeight,
    super.maxHeight,
    super.width,
  }) : _viewId = 'recaptcha-${DateTime.now().millisecondsSinceEpoch}' {
    _initializeIframe();
  }

  /// Initializes the iframe for reCAPTCHA.
  void _initializeIframe() {
    try {
      // Create URL with parameters
      final recaptchaUrl = Uri.https(hostDomain, '/recaptcha.html', {
        'sitekey': siteKey,
        'theme': theme.name,
        'size': size.name,
        'inline': 'true', // Ensure inline mode
      });

      // Create iframe element
      _iframe = html.IFrameElement()
        ..src = recaptchaUrl.toString()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.backgroundColor = 'transparent'
        ..allow = 'encrypted-media';

      // Set up message listener
      html.window.onMessage.listen(_handleMessageFromIframe);

      // Register view factory
      ui.platformViewRegistry.registerViewFactory(_viewId, (_) => _iframe);

      _viewReady = true;

      // Initial state update
      controller.setLoading(false);
    } catch (e) {
      final errorMessage = 'Failed to initialize reCAPTCHA: ${e.toString()}';
      controller.setError(errorMessage);
      onError?.call(errorMessage);
    }
  }

  /// Handles messages from the iframe.
  void _handleMessageFromIframe(html.MessageEvent event) {
    try {
      final data = event.data;

      if (data is Map) {
        switch (data['type']) {
          case 'recaptcha-token':
            if (data['recaptchaToken'] is String) {
              final token = data['recaptchaToken'] as String;
              controller.setVerified(true);
              onVerified(token);
            }
            break;

          case 'challenge-visible':
            final visible = data['visible'] as bool? ?? false;
            controller.setChallengeVisible(visible);

            break;

          case 'recaptcha-error':
            if (data['error'] is String) {
              final errorMessage = data['error'] as String;
              controller.setError(errorMessage);
              onError?.call(errorMessage);
            }
            break;

          case 'recaptcha-loaded':
            controller.setLoading(false);
            break;
        }
      }
    } catch (e) {
      final errorMessage =
          'Error processing reCAPTCHA response: ${e.toString()}';
      controller.setError(errorMessage);
      onError?.call(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // reCAPTCHA iframe
        if (_viewReady)
          Positioned.fill(
            child: HtmlElementView(viewType: _viewId),
          ),

        // Loading indicator
        if (controller.state.isLoading)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  @override
  Future<void> reset() async {
    try {
      _iframe.contentWindow?.postMessage({
        'type': 'reset-captcha',
      }, '*');

      controller.reset();
    } catch (e) {
      final errorMessage = 'Failed to reset reCAPTCHA: ${e.toString()}';
      controller.setError(errorMessage);
      onError?.call(errorMessage);
    }
  }
}

/// Returns the web implementation of RecaptchaPlatform.
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
  double? width,
}) {
  return RecaptchaWebPlatform(
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
