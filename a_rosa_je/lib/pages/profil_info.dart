import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/api_service.dart';

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
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      UserData userData = await apiService.getUserData();
      setState(() {
        nomController.text = userData.firstName;
        prenomController.text = userData.lastName;
        pseudonymeController.text = userData.userName;
        villeController.text = userData.city;
        emailController.text = userData.email;
        bioController.text = userData.bio;
      });
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la récupération des données'),
        ),
      );
    }
  }

  Future<void> saveChanges() async {
    UserData updatedUserData = UserData(
      firstName: nomController.text,
      lastName: prenomController.text,
      userName: pseudonymeController.text,
      city: villeController.text,
      email: emailController.text,
      bio: bioController.text,
    );
    try {
      await apiService.updateUserData(updatedUserData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Modifications enregistrées avec succès'),
        ),
      );
    } catch (e) {
      print('Erreur lors de la sauvegarde des modifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la sauvegarde des modifications'),
        ),
      );
    }
  }

  Future<void> fetchCities(String cityName) async {
    final response = await http.get(
      Uri.parse(
          'https://geo.api.gouv.fr/communes?nom=$cityName&fields=departement&boost=population&limit=5'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<String> cityNames = [];
      for (var cityData in jsonData) {
        cityNames.add(cityData['nom']);
      }
      setState(() {
        villeController.text = cityNames.isNotEmpty ? cityNames[0] : '';
      });
    } else {
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
              onChanged: (cityName) {
                if (cityName.isNotEmpty) {
                  fetchCities(cityName);
                }
              },
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text('Appliquer mes changements'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserData {
  final String firstName;
  final String lastName;
  final String userName;
  final String city;
  final String email;
  final String bio;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.city,
    required this.email,
    required this.bio,
  });
}
