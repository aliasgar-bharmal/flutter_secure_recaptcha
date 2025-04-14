import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/enums.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaMobilePlatform extends RecaptchaPlatform {
  final RecaptchaController controller;
  late final WebViewController _webViewController;
  bool _isInitialized = false;

  RecaptchaMobilePlatform({
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
    required super.onChallengeVisible,
  }) {
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..enableZoom(false) // Disable zooming to prevent scaling issues
        ..addJavaScriptChannel(
          'RecaptchaFlutter',
          onMessageReceived: _handleJavaScriptMessage,
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: _handleWebViewError,
            onPageFinished: (String url) {
              _isInitialized = true;
              controller.setLoading(false);
              _injectViewportMeta(); // Inject viewport meta after page load
            },
            onPageStarted: (String url) {
              controller.setLoading(true);
            },
          ),
        );

      // Load the reCAPTCHA page
      _loadRecaptchaPage();
    } catch (e) {
      final errorMessage = 'Failed to initialize WebView: ${e.toString()}';
      controller.setError(errorMessage);
      onError?.call(errorMessage);
    }
  }

  // Inject viewport meta tag to ensure proper scaling
  Future<void> _injectViewportMeta() async {
    const script = '''
      var meta = document.createElement('meta');
      meta.name = 'viewport';
      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover';
      document.head.appendChild(meta);
    ''';
    await _executeJavaScript(script);
  }

  Future<void> _loadRecaptchaPage() async {
    try {
      final recaptchaUrl = Uri.https(hostDomain, '/recaptcha.html', {
        'sitekey': siteKey,
        'theme': theme.name,
        'size': size.name,
      });

      log('[reCAPTCHA] Loading URL: $recaptchaUrl');
      await _webViewController.loadRequest(recaptchaUrl);
    } catch (e) {
      final errorMessage = 'Failed to load reCAPTCHA page: ${e.toString()}';
      controller.setError(errorMessage);
      onError?.call(errorMessage);
    }
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = message.message;
      log('[reCAPTCHA] Received message: $data');

      if (data.startsWith('{') && data.endsWith('}')) {
        final Map<String, dynamic> jsonData = json.decode(data);

        switch (jsonData['type']) {
          case 'recaptcha-token':
            final token = jsonData['recaptchaToken'] as String?;
            if (token != null && token.isNotEmpty) {
              onVerified(token);
            } else {
              _notifyError('Invalid reCAPTCHA token received');
            }
            break;

          case 'challenge-visible':
            final visible = jsonData['visible'] as bool? ?? false;
            log('[reCAPTCHA] Challenge visible: $visible');
            onChallengeVisible(visible);
            // Ensure proper layout when challenge appears
            if (visible) {
              _ensureChallengeLayout();
            }
            break;

          case 'recaptcha-error':
            final error = jsonData['error'] as String?;
            if (error != null) {
              _notifyError(error);
            }
            break;

          case 'recaptcha-loaded':
            controller.setLoading(false);
            break;
        }
      }
    } catch (e) {
      _notifyError('Failed to process reCAPTCHA response: ${e.toString()}');
    }
  }

  // Ensure proper layout for challenge iframe
  Future<void> _ensureChallengeLayout() async {
    const script = '''
      const challengeIframe = document.querySelector('iframe[title*="recaptcha challenge"]');
      if (challengeIframe) {
        const parentDiv = challengeIframe.closest('div[style*="position: fixed"]');
        if (parentDiv) {
          parentDiv.style.position = 'fixed';
          parentDiv.style.width = '100%';
          parentDiv.style.height = '100%';
          parentDiv.style.top = '0';
          parentDiv.style.left = '0';
          parentDiv.style.zIndex = '2147483647';
          parentDiv.style.backgroundColor = 'rgba(0,0,0,0.05)';

          challengeIframe.style.position = 'absolute';
          challengeIframe.style.top = '50%';
          challengeIframe.style.left = '50%';
          challengeIframe.style.transform = 'translate(-50%, -50%)';
          challengeIframe.style.maxWidth = '95vw';
          challengeIframe.style.maxHeight = '95vh';
        }
      }
    ''';
    await _executeJavaScript(script);
  }

  void _handleWebViewError(WebResourceError error) {
    _notifyError('WebView error: ${error.description}');
  }

  void _notifyError(String message) {
    log('[reCAPTCHA] Error: $message');
    controller.setError(message);
    onError?.call(message);
  }

  Future<void> _executeJavaScript(String script) async {
    try {
      if (_isInitialized) {
        await _webViewController.runJavaScript(script);
      }
    } catch (e) {
      _notifyError('JavaScript execution error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // WebView with proper constraints
        SizedBox(
          width: width ?? double.infinity,
          height: controller.state.isChallengeVisible ? maxHeight : initialHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
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
    await _executeJavaScript('''
      try {
        resetCaptcha();
      } catch(e) {
        RecaptchaFlutter.postMessage(JSON.stringify({
          type: 'recaptcha-error',
          error: 'Reset failed: ' + e.message
        }));
      }
    ''');

    controller.reset();
    onChallengeVisible(false);
  }
}

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
  required Function(bool) onChallengeVisible,
}) {
  return RecaptchaMobilePlatform(
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
    onChallengeVisible: onChallengeVisible,
  );
}