import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:age_gating_kit/age_gating_kit_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelAgeGatingKit();

  const channel = MethodChannel('age_gating_kit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'checkAge') {
          return {
            'isEligibleForAgeFeatures': true,
            'ageRange': '13-17',
            'requiredRegulatoryFeatures': [
              'parentalConsent',
            ],
          };
        }

        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('checkAge returns expected native map', () async {
    final result = await platform.checkAge();

    expect(
      result['isEligibleForAgeFeatures'],
      true,
    );

    expect(
      result['ageRange'],
      '13-17',
    );

    expect(
      result['requiredRegulatoryFeatures'],
      contains('parentalConsent'),
    );
  });
}