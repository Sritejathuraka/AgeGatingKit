import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'age_gating_kit_method_channel.dart';

abstract class AgeGatingKitPlatform extends PlatformInterface {
  AgeGatingKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static AgeGatingKitPlatform _instance = MethodChannelAgeGatingKit();

  static AgeGatingKitPlatform get instance => _instance;

  static set instance(AgeGatingKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<dynamic, dynamic>> checkAge() {
    throw UnimplementedError('checkAge() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> requestParentalConsent({
    required String description,
  }) {
    throw UnimplementedError(
      'requestParentalConsent() has not been implemented.',
    );
  }

  Future<Map<dynamic, dynamic>> showAdultNotification({
    required String description,
  }) {
    throw UnimplementedError(
      'showAdultNotification() has not been implemented.',
    );
  }
}
