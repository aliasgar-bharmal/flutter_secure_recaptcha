import 'package:flutter/material.dart';
import 'package:flutter_secure_recaptcha/flutter_secure_recaptcha.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FlutterSecureRecaptcha triggers success callback',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FlutterSecureRecaptcha(
          siteKey: 'dummy-key',
          recaptchaHostDomain: 'https://dummy-host.com',
          onVerifiedSuccessfully: (token) {
            expect(token.isNotEmpty, true); // Assuming token is returned
          },
        ),
      ),
    );

    // Simulate successful verification (mock this part according to your implementation)
    // You might need to use a mock method channel or call internal verification directly.

    // For example:
    // pluginController.simulateVerificationSuccess('mock-token');
    // await tester.pump();

    // expect(successCalled, isTrue); // Uncomment after proper simulation
  });

  testWidgets('FlutterSecureRecaptcha triggers failure callback',
      (WidgetTester tester) async {
    bool failedCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: FlutterSecureRecaptcha(
          siteKey: 'dummy-key',
          recaptchaHostDomain: 'https://dummy-host.com',
          onVerifiedSuccessfully: (_) {
            fail('Should not call onVerifiedSuccessfully');
          },
        ),
      ),
    );

    // Simulate failure (mock this part)
    // pluginController.simulateVerificationFailure();
    // await tester.pump();

    // expect(failedCalled, isTrue); // Uncomment after proper simulation
  });
}
