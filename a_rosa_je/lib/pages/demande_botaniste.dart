import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DemandeBotanistePage extends StatelessWidget {
  final String adresseMail = "arosaje@admin.fr";

  void envoyerEmail(BuildContext context) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: adresseMail,
      query: 'subject=Demande de Botaniste',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aucune application de messagerie trouvée'),
            content: Text('Veuillez installer une application de messagerie pour envoyer un e-mail.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de Botaniste'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pour devenir botaniste, veuillez fournir les informations suivantes :',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Justificatif à fournir :',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('- Numéro de SIRET'),
            Text('- Diplôme'),
            Text('- Numéro de téléphone'),
            Text('- Adresse mail'),
            Text('- Années d\'expérience'),
            Text('- Liste des différentes plantes connues'),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => envoyerEmail(context),
              child: Text(
                adresseMail,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DemandeBotanistePage(),
  ));
}
