import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:a_rosa_je/pages/politique.dart'; // Importez votre page politique

void main() {
  testWidgets('Politique de Confidentialité et gestion des données',
      (WidgetTester tester) async {
    // Construisez le widget
    await tester.pumpWidget(MaterialApp(
      home: PolitiquePage(),
    ));

    // Vérifiez que le titre de la page est correct
    expect(find.text('Politique de Confidentialité et gestion des données'), findsOneWidget);

    // Vérifiez la présence de la date de dernière mise à jour
    expect(find.text('Dernière mise à jour : 27/03/2024'), findsOneWidget);

    // Vérifiez que le texte de politique de confidentialité est affiché
    expect(find.text('Chez A\'rosa_je, nous nous engageons à protéger votre vie privée. Cette politique de confidentialité explique comment nous recueillons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre site web ou nos services.'), findsOneWidget);

    // Vérifiez la présence de différentes sections de politique de confidentialité
    expect(find.text('1. Collecte et utilisation des informations'), findsOneWidget);
    expect(find.text('2. Conservation des données'), findsOneWidget);
    expect(find.text('3. Partage des données'), findsOneWidget);
    expect(find.text('4. Vos droits'), findsOneWidget);

    // Vérifiez la présence du texte de contact
    expect(find.text('Contactez-nous'), findsOneWidget);
    expect(find.text('Si vous avez des questions ou des préoccupations concernant notre politique de confidentialité, veuillez nous contacter à [adresse e-mail de contact]. Nous nous engageons à traiter vos demandes dans les meilleurs délais et à respecter vos droits conformément aux lois et réglementations en vigueur.'), findsOneWidget);
    
    // Vous pouvez ajouter d'autres vérifications selon les éléments de votre page
  });
}
