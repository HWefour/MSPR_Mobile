import 'package:a_rosa_je/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:a_rosa_je/pages/profil_info.dart';

void main() {
  group('SettingsPage', () {
    testWidgets('should load user profile info', (WidgetTester tester) async {
      // Build SettingsPage widget
      await tester.pumpWidget(MaterialApp(home: SettingsPage()));

      // Wait for the page to settle
      await tester.pumpAndSettle();

      // Check if user profile info is displayed correctly
      expect(find.text('Nom d\'utilisateur : '), findsOneWidget);
      expect(find.text('Ville'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
    });

    testWidgets('should save changes and logout', (WidgetTester tester) async {
      // Build SettingsPage widget
      await tester.pumpWidget(MaterialApp(home: SettingsPage()));

      // Wait for the page to settle
      await tester.pumpAndSettle();

      // Tap the save changes button
      await tester.tap(find.byType(ElevatedButton));

      // Wait for the changes to be saved
      await tester.pumpAndSettle();

      // Check if the user is logged out after saving changes
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
