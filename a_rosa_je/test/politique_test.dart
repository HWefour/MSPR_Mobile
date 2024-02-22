import 'package:a_rosa_je/pages/politique.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Politique de Confidentialité et gestion des données',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: PolitiquePage(),
    ));
    // Vérifiez que le titre de la page est correct
    expect(find.text('Politique de Confidentialité et gestion des données'),findsOneWidget);
    // Vérifiez que le texte de votre politique de confidentialité est affiché
    expect(find.text('Chez A\'rosa_je, nous nous engageons à protéger votre vie privée. Cette politique de confidentialité explique comment nous recueillons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre site web ou nos services.'),findsOneWidget);

    expect(find.text('Si vous avez des questions ou des préoccupations concernant notre politique de confidentialité, veuillez nous contacter à [adresse e-mail de contact].'),findsOneWidget);
    
    expect(find.text('Contactez-nous'),findsOneWidget);

    expect(find.text('Dernière mise à jour : [Date]'),findsOneWidget);
    // Vous pouvez ajouter d'autres vérifications selon les éléments de votre page
  });
}
