import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'age_gating_kit_platform_interface.dart';

class MethodChannelAgeGatingKit extends AgeGatingKitPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('age_gating_kit');

  @override
  Future<Map<dynamic, dynamic>> checkAge() async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'checkAge',
    );

    return result ?? <dynamic, dynamic>{};
  }

  @override
  Future<Map<dynamic, dynamic>> requestParentalConsent({
    required String description,
  }) async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'requestParentalConsent',
      {'description': description},
    );

    return result ?? <dynamic, dynamic>{};
  }

  @override
  Future<Map<dynamic, dynamic>> showAdultNotification({
    required String description,
  }) async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'showAdultNotification',
      {'description': description},
    );

    return result ?? <dynamic, dynamic>{};
  }
}
