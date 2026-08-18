import 'age_gating_kit_platform_interface.dart';
import 'models/age_gating_result.dart';

class AgeGatingKit {
  static Future<AgeGatingResult> checkAge() async {
    final result = await AgeGatingKitPlatform.instance.checkAge();

    return AgeGatingResult.fromMap(result);
  }

  static Future<Map<dynamic, dynamic>> requestParentalConsent({
    required String description,
  }) {
    return AgeGatingKitPlatform.instance.requestParentalConsent(
      description: description,
    );
  }

  static Future<Map<dynamic, dynamic>> showAdultNotification({
    required String description,
  }) {
    return AgeGatingKitPlatform.instance.showAdultNotification(
      description: description,
    );
  }
}
