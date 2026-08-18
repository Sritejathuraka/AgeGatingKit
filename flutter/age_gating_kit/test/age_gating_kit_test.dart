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
      'requiredRegulatoryFeatures': ['declaredAgeRangeRequired'],
    };
  }

  @override
  Future<Map<dynamic, dynamic>> requestParentalConsent({
    required String description,
  }) async {
    return {
      'status': 'pending',
      'message': 'Parental consent request was sent.',
    };
  }

  @override
  Future<Map<dynamic, dynamic>> showAdultNotification({
    required String description,
  }) async {
    return {
      'status': 'acknowledged',
      'message': 'Adult notification acknowledged.',
    };
  }
}

void main() {
  late MockAgeGatingKitPlatform fakePlatform;

  setUp(() {
    fakePlatform = MockAgeGatingKitPlatform();
    AgeGatingKitPlatform.instance = fakePlatform;
  });

  test('checkAge returns AgeGatingResult', () async {
    final result = await AgeGatingKit.checkAge();

    expect(result.isEligibleForAgeFeatures, true);

    expect(result.ageRange, '13-17');

    expect(
      result.requiredRegulatoryFeatures,
      contains('declaredAgeRangeRequired'),
    );
  });

  test('requestParentalConsent returns status', () async {
    final result = await AgeGatingKit.requestParentalConsent(
      description: 'Test significant update',
    );

    expect(result['status'], 'pending');
  });

  test('showAdultNotification returns status', () async {
    final result = await AgeGatingKit.showAdultNotification(
      description: 'Test significant update',
    );

    expect(result['status'], 'acknowledged');
  });
}
