// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController pseudonymeController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Appeler fetchData() au moment de l'initialisation de la page
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:1212/home/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Récupérez les données de l'utilisateur à partir de jsonData et mettez à jour les contrôleurs de texte.
      setState(() {
        nomController.text = jsonData['firstName'];
        prenomController.text = jsonData['lastName'];
        pseudonymeController.text = jsonData['userName'];
        villeController.text = jsonData['city'];
      });
    } else {
      // La requête a échoué, traitez les erreurs ici.
      throw Exception('Échec de la récupération des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations du compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
            TextField(
              controller: prenomController,
              decoration: InputDecoration(
                labelText: 'Prénom',
              ),
            ),
            TextField(
              controller: pseudonymeController,
              decoration: InputDecoration(
                labelText: 'Pseudonyme',
              ),
            ),
            TextField(
              controller: villeController,
              decoration: InputDecoration(
                labelText: 'Ville de résidence',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Gérer la sauvegarde des données ici, si nécessaire.
              },
              child: Text('Appliquer mes changements'),
            ),
          ],
        ),
      ),
      // ... reste du code
    );
  }
}
