import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

State<RecaptchaWidget> createRecaptchaState() => _RecaptchaMobileState();

class _RecaptchaMobileState extends State<RecaptchaWidget> {
  late final WebViewController _webViewController;
  double _webViewHeight = 1; // Start small, update once recaptcha loads

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _loadRecaptchaPage();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Recaptcha',
        onMessageReceived: _handleJavaScriptMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: _onWebViewError,
        ),
      );
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    final msg = message.message;

    if (msg.startsWith('recaptchaToken:')) {
      final token = msg.replaceFirst('recaptchaToken:', '');
      widget.onVerified(token);
    } else if (msg.startsWith('contentHeight:')) {
      final newHeight = double.tryParse(msg.replaceFirst('contentHeight:', ''));
      if (newHeight != null && newHeight != _webViewHeight) {
        setState(() => _webViewHeight = newHeight);
      }
    }
  }

  void _onWebViewError(WebResourceError error) {
    log('[reCAPTCHA] WebView error: ${error.description}');
  }

  Future<void> _loadRecaptchaPage() async {
    try {
      final host = widget.hostDomain.trim().isEmpty
          ? 'localhost'
          : widget.hostDomain.trim();
      final uri =
          Uri.https(host, '/recaptcha.html', {'sitekey': widget.siteKey});
      log('[reCAPTCHA] Loading URL: $uri');
      await _webViewController.loadRequest(uri);
    } catch (e) {
      log('[reCAPTCHA] Failed to load recaptcha page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: SizedBox(
        height: _webViewHeight,
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}
