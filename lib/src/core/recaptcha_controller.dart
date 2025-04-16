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

  void updateHeight(double height) {
    _state = _state.copyWith(height: height);
    notifyListeners();
  }

  /// Resets the reCAPTCHA state.
  void reset() {
    _state = const RecaptchaState();
    notifyListeners();
  }
}



// class RecaptchaController extends ChangeNotifier {
//   RecaptchaState _state = RecaptchaState();

//   RecaptchaState get state => _state;

//   void setLoading(bool isLoading) {
//     _state = _state.copyWith(isLoading: isLoading);
//     notifyListeners();
//   }

//   void setError(String? error) {
//     _state = _state.copyWith(errorMessage: error);
//     notifyListeners();
//   }

//   void setChallengeVisible(bool visible) {
//     _state = _state.copyWith(isChallengeVisible: visible);
//     notifyListeners();
//   }


//   void reset() {
//     _state = ;
//     notifyListeners();
//   }
// }

