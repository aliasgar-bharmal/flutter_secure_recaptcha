import 'package:flutter/foundation.dart';

/// State class for the reCAPTCHA controller.
class RecaptchaState {
  /// Whether the reCAPTCHA is currently loading
  final bool isLoading;
  
  /// Error message, if any
  final String? errorMessage;
  
  /// Whether the reCAPTCHA has been verified
  final bool isVerified;
  
  /// Whether the reCAPTCHA challenge is visible
  final bool isChallengeVisible;
  
  /// Creates a new RecaptchaState instance.
  const RecaptchaState({
    this.isLoading = true,
    this.errorMessage,
    this.isVerified = false,
    this.isChallengeVisible = false,
  });
  
  /// Creates a copy of this state with the given fields replaced.
  RecaptchaState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? clearError,
    bool? isVerified,
    bool? isChallengeVisible,
  }) {
    return RecaptchaState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError == true ? null : (errorMessage ?? this.errorMessage),
      isVerified: isVerified ?? this.isVerified,
      isChallengeVisible: isChallengeVisible ?? this.isChallengeVisible,
    );
  }
}
