import 'package:flutter/material.dart';

class PolitiquePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique de Confidentialité'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Politique de Confidentialité et gestion des données',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Dernière mise à jour : 27/03/2024',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Chez A\'rosa_je, nous nous engageons à protéger votre vie privée. Cette politique de confidentialité explique comment nous recueillons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre site web ou nos services.',
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Collecte et utilisation des informations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nous collectons différentes informations aux fins de fournir et d\'améliorer notre service. Les types de données collectées peuvent varier en fonction de l''utilisation que vous faites de notre service. Nous collectons uniquement les données strictement nécessaires à la finalité poursuivie et nous nous engageons à ne pas les utiliser à d''autres fins sans votre consentement.',
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Conservation des données',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nous conserverons vos données personnelles uniquement aussi longtemps que nécessaire aux fins énoncées dans cette politique de confidentialité. Nous conserverons et utiliserons vos données personnelles dans la mesure nécessaire pour respecter nos obligations légales, résoudre les litiges et appliquer nos politiques. Conformément aux recommandations de la CNIL, nous limitons la durée de conservation de vos données en fonction de la finalité pour laquelle elles ont été collectées.',
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Partage des données',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nous ne vendrons ni ne louerons vos informations personnelles à des tiers. Cependant, nous pouvons partager vos données avec des tiers de confiance pour vous fournir certains services. Nous nous assurons que ces tiers respectent également les règles de confidentialité et de sécurité de vos données conformément aux lois en vigueur.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Vos droits',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Vous disposez de droits concernant vos données personnelles, notamment le droit d\'accès, de rectification et de suppression de ces données. Vous avez également le droit de limiter le traitement de vos données et de vous opposer au traitement dans certaines circonstances. Pour exercer vos droits, veuillez nous contacter à l\'adresse indiquée ci-dessous.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Contactez-nous',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Si vous avez des questions ou des préoccupations concernant notre politique de confidentialité, veuillez nous contacter à [adresse e-mail de contact]. Nous nous engageons à traiter vos demandes dans les meilleurs délais et à respecter vos droits conformément aux lois et réglementations en vigueur.',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PolitiquePage(),
  ));
}
