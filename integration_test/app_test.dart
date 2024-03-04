import 'package:com_barge_idigital/screens/home/home_screen.dart';
import 'package:com_barge_idigital/screens/onboding/components/animated_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:com_barge_idigital/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("Login Testing", () {
    testWidgets("Open Login Screen with correct details", (tester) async {
      debugPrint("Loading Main");
      app.main();
      debugPrint("Main Load Done");

      await Future.delayed(const Duration(seconds: 30));
      await tester.pumpWidget(Column as Widget);
      debugPrint("Pump Settle for main is done");
      final localLoginBegin = find.byKey(const Key("openlogin"));
      await tester.tap(localLoginBegin);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(find.byKey(const Key("mobileno")), "08082071188");

      await Future.delayed(const Duration(seconds: 2));
      await tester.enterText(find.byKey(const Key("password")), "amar@1");

      await Future.delayed(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key("btnlogin")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
