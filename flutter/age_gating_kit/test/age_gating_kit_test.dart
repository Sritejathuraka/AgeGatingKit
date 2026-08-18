import 'package:flutter_test/flutter_test.dart';
import 'package:age_gating_kit/age_gating_kit.dart';
import 'package:age_gating_kit/age_gating_kit_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAgeGatingKitPlatform
    with MockPlatformInterfaceMixin
    implements AgeGatingKitPlatform {

  @override
  Future<Map<dynamic, dynamic>> checkAge() async {
    return {
      'isEligibleForAgeFeatures': true,
      'ageRange': '13-17',
      'requiredRegulatoryFeatures': [
        'parentalConsent',
      ],
    };
  }
}

void main() {
  test('checkAge returns mapped AgeGatingResult', () async {
    final fakePlatform = MockAgeGatingKitPlatform();

    AgeGatingKitPlatform.instance = fakePlatform;

    final result = await AgeGatingKit.checkAge();

    expect(
      result.isEligibleForAgeFeatures,
      true,
    );

    expect(
      result.ageRange,
      '13-17',
    );

    expect(
      result.requiredRegulatoryFeatures,
      contains('parentalConsent'),
    );
  });
}