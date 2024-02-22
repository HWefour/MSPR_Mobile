import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

import 'demande_botaniste.dart';

void main() {
  group('DemandeBotanistePage', () {
    testWidgets('Tap on email calls send email function', (WidgetTester tester) async {
      final DemandeBotanistePage page = DemandeBotanistePage();
      await tester.pumpWidget(MaterialApp(home: page));

      final emailTextFinder = find.text('arosaje@admin.fr');
      expect(emailTextFinder, findsOneWidget);

      await tester.tap(emailTextFinder);
      await tester.pumpAndSettle();

      // Verify that the emailSent flag is true after tapping on the email text.
      expect(page.emailSent, true);
    });
  });
}
