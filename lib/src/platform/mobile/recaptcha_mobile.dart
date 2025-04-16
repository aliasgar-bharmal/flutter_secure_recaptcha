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

  RecaptchaMobilePlatform({
    required super.siteKey,
    required super.hostDomain,
    required super.onVerified,
    super.onError,
    super.theme,
    required super.size,
    required this.controller,
  }) {
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.purple)
        ..enableZoom(false)
        ..addJavaScriptChannel(
          'RecaptchaFlutter',
          onMessageReceived: _handleJavaScriptMessage,
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (error) =>
                _notifyError('WebView error: ${error.description}'),
            onPageFinished: (url) {
              _injectResizeObserver();
              controller.setLoading(false);
            },
            onPageStarted: (_) => controller.setLoading(true),
          ),
        );

      _loadRecaptchaPage();
    } catch (e) {
      _notifyError('Failed to initialize WebView: ${e.toString()}');
    }
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
      _notifyError('Failed to load reCAPTCHA page: ${e.toString()}');
    }
  }

  // Add this method to inject a resize observer
  void _injectResizeObserver() {
    const js = '''
    const captchaContainer = document.querySelector('.g-recaptcha');
    if (captchaContainer) {
      const resizeObserver = new ResizeObserver(entries => {
        for (let entry of entries) {
          const height = entry.contentRect.height;
          if (height > 0) {
            window.RecaptchaFlutter.postMessage(JSON.stringify({
              type: 'height-update',
              height: height + 20 // Add padding
            }));
          }
        }
      });
      
      resizeObserver.observe(captchaContainer);
      
      // Also observe the iframe when it appears
      const checkForIframe = setInterval(() => {
        const iframe = document.querySelector('iframe[title="reCAPTCHA"]');
        if (iframe) {
          resizeObserver.observe(iframe);
          clearInterval(checkForIframe);
        }
      }, 100);
    }
    ''';

    _webViewController.runJavaScript(js);
  }

  void _updateHeight(double newHeight) {
    log('[reCAPTCHA] Updating height to: $newHeight');
    // Validate height constraints
    final validHeight = newHeight.clamp(100.0, maxHeight);

    // Update controller with new height and notify listeners
    controller.updateHeight(validHeight);
    _webViewController.runJavaScript(
        'document.documentElement.style.height = "${validHeight}px";');
    log('[reCAPTCHA] Height updated to: $validHeight');
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = message.message;
      log('[reCAPTCHA] Received message: $data');

      if (data.startsWith('{') && data.endsWith('}')) {
        final Map<String, dynamic> jsonData = json.decode(data);

        switch (jsonData['type']) {
          case 'height-update':
            log(jsonData.toString());
            final height = jsonData['height'] as num?;
            if (height != null) {
              _updateHeight(height.toDouble());
            }
            break;

          case 'recaptcha-token':
            final token = jsonData['recaptchaToken'] as String?;
            if (token != null && token.isNotEmpty) {
              onVerified(token);
            } else {
              _notifyError('Invalid reCAPTCHA token received');
            }
            break;

          case 'recaptcha-error':
            final error = jsonData['error'] as String?;
            if (error != null) {
              _notifyError(error);
            }
            break;
        }
      }
    } catch (e) {
      _notifyError('Failed to process reCAPTCHA response: ${e.toString()}');
    }
  }

  void _notifyError(String message) {
    log('[reCAPTCHA] Error: $message');
    controller.setError(message);
    onError?.call(message);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return SizedBox(
              width: width ?? constraints.maxWidth,
              height: controller.state.height,
              // Use calculated height
              child: Stack(
                children: [
                  // Replace Expanded with Positioned.fill
                  Positioned.fill(
                    child: Container(
                      color: Colors.blueAccent,
                      child: WebViewWidget(
                        controller: _webViewController,
                      ),
                    ),
                  ),
                  if (controller.state.isLoading)
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Future<void> reset() async {}
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
}) {
  return RecaptchaMobilePlatform(
    siteKey: siteKey,
    hostDomain: hostDomain,
    onVerified: onVerified,
    onError: onError,
    theme: theme,
    size: size,
    controller: controller,
  );
}
