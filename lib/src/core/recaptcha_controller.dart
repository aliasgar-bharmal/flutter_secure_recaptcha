import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/src/core/recaptcha_state.dart';

/// Controller for managing reCAPTCHA state and actions.
///
/// This controller allows for programmatic control of the reCAPTCHA widget,
/// including showing, hiding, and resetting the verification.
class RecaptchaController extends ChangeNotifier {
  /// The site key for reCAPTCHA verification
  final String siteKey;

  /// The host domain for reCAPTCHA verification
  final String hostDomain;

  /// Current state of the reCAPTCHA
  RecaptchaState _state = const RecaptchaState();

  /// Gets the current state of the reCAPTCHA
  RecaptchaState get state => _state;

  /// Creates a new RecaptchaController instance.
  ///
  /// The [siteKey] and [hostDomain] parameters are required for reCAPTCHA
  /// verification.
  RecaptchaController({
    required this.siteKey,
    required this.hostDomain,
  });

  /// Sets the loading state of the reCAPTCHA.
  void setLoading(bool isLoading) {
    _state = _state.copyWith(isLoading: isLoading);
    notifyListeners();
  }

  /// Sets an error message for the reCAPTCHA.
  void setError(String message) {
    _state = _state.copyWith(
      errorMessage: message,
      isLoading: false,
    );
    notifyListeners();
  }

  /// Sets the verification state of the reCAPTCHA.
  void setVerified(bool isVerified) {
    _state = _state.copyWith(
      isVerified: isVerified,
      isLoading: false,
    );
    notifyListeners();
  }

  /// Sets the challenge visibility state.
  void setChallengeVisible(bool isVisible) {
    _state = _state.copyWith(
      isChallengeVisible: isVisible,
    );
    notifyListeners();
  }

  /// Resets the reCAPTCHA state.
  void reset() {
    _state = _state.copyWith(
      isVerified: false,
      clearError: true,
      isLoading: false,
      isChallengeVisible: false,
    );
    notifyListeners();
  }

  /// Shows the reCAPTCHA.
  ///
  /// This method is primarily used for programmatically showing the reCAPTCHA
  /// when it's embedded in a dialog or other container that can be hidden.
  void show() {
    // This is a placeholder for platform-specific implementations
    // The actual implementation will be handled by the platform-specific code
    notifyListeners();
  }

  /// Hides the reCAPTCHA.
  ///
  /// This method is primarily used for programmatically hiding the reCAPTCHA
  /// when it's embedded in a dialog or other container that can be hidden.
  void hide() {
    // This is a placeholder for platform-specific implementations
    // The actual implementation will be handled by the platform-specific code
    notifyListeners();
  }
}
