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

  final double height;

  /// Creates a new RecaptchaState instance.
  const RecaptchaState({
    this.isLoading = true,
    this.errorMessage,
    this.isVerified = false,
    this.isChallengeVisible = false,
    this.height = 78.0,
  });

  /// Creates a copy of this state with the given fields replaced.
  RecaptchaState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? clearError,
    bool? isVerified,
    bool? isChallengeVisible,
    double? height,
  }) {
    return RecaptchaState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError == true ? null : (errorMessage ?? this.errorMessage),
      isVerified: isVerified ?? this.isVerified,
      isChallengeVisible: isChallengeVisible ?? this.isChallengeVisible,
      height: height ?? this.height,
    );
  }
}
