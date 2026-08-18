import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:age_gating_kit/age_gating_kit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'checkAge returns native result',
    (WidgetTester tester) async {
      final result = await AgeGatingKit.checkAge();

      expect(
        result,
        isNotNull,
      );
    },
  );
}