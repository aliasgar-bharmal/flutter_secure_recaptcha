import 'dart:html' as html;
import 'dart:developer';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_controller.dart';

State<RecaptchaWidget> createRecaptchaState() => _RecaptchaWebIframeState();

class _RecaptchaWebIframeState extends State<RecaptchaWidget> {
  late final String _viewId;
  bool _viewReady = false;
  double _iframeHeight = 150;

  @override
  void initState() {
    super.initState();
    _viewId = 'recaptcha-${DateTime.now().millisecondsSinceEpoch}';
    WidgetsBinding.instance.addPostFrameCallback((_) => _initIframe());
  }

  Future<void> _initIframe() async {
    try {
      final host = widget.hostDomain.trim().isEmpty
          ? 'localhost'
          : widget.hostDomain.trim();

      final recaptchaUrl = Uri.https(host, '/recaptcha.html', {
        'sitekey': widget.siteKey,
      });

      log('[reCAPTCHA] Web iframe loading: $recaptchaUrl');

      final iframe = html.IFrameElement()
        ..src = recaptchaUrl.toString()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '${_iframeHeight}px'
        ..allow = 'encrypted-media';

      html.window.onMessage.listen(_handleMessageFromIframe);

      ui.platformViewRegistry.registerViewFactory(_viewId, (_) => iframe);

      setState(() {
        _viewReady = true;
      });
    } catch (e, stack) {
      log('[reCAPTCHA] Web iframe failed to initialize',
          error: e, stackTrace: stack);
    }
  }

  void _handleMessageFromIframe(html.MessageEvent event) {
    final data = event.data;

    if (data is Map) {
      if (data['type'] == 'recaptcha-token' &&
          data['recaptchaToken'] is String) {
        final token = data['recaptchaToken'] as String;
        log('[reCAPTCHA] Token received from iframe: $token');
        widget.onVerified(token);
      } else if (data['type'] == 'content-height' && data['height'] is num) {
        final newHeight = (data['height'] as num).toDouble();
        if (newHeight != _iframeHeight && newHeight > 0) {
          setState(() => _iframeHeight = newHeight);
        }
      } else {
        log('[reCAPTCHA] Unhandled iframe message: $data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _viewReady
          ? SizedBox(
              width: double.infinity,
              height: _iframeHeight,
              child: HtmlElementView(viewType: _viewId),
            )
          : const SizedBox.shrink(),
    );
  }
}
