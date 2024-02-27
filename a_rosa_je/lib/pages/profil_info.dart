import 'package:a_rosa_je/pages/home.dart';
import 'package:a_rosa_je/pages/parametre_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:a_rosa_je/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _usersName = '';
  String _lastName = ''; // Ajout du champ lastName
  String _city = '';
  String _email = '';
  String _bio = '';
  List<String> cities = [];
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final baseUrl = dotenv
      .env['API_BASE_URL'];

  // Fonction pour récupérer les données de l'utilisateur depuis le stockage
  Future<void> _loadUserProfileInfo() async {
    var box = await Hive.openBox('userBox');
    var userJson = box.get('userDetails');
    if (userJson != null) {
      Map<String, dynamic> user = jsonDecode(userJson);
      setState(() {
        _usersName = user['usersName'] ?? 'N/A';
        _lastName =
            user['lastName'] ?? 'N/A'; 
        _city = user['city'] ?? 'N/A';
        _email = user['email'] ?? 'N/A';
        _bio = user['bio'] ?? 'N/A';
        _userNameController.text = _usersName;
        _cityController.text = _city;
        _emailController.text = _email;
        _bioController.text = _bio;
      });
    }
  }
    Future<void> logout(BuildContext context) async {
    try {
      var box = await Hive.openBox('userBox');
      await box.delete('userDetails');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    _loadUserProfileInfo();
  }

  // Fonction pour enregistrer les modifications
  Future<void> _saveChanges() async {
    var box = await Hive.openBox('userBox');
    var userJson = box.get('userDetails');
    if (userJson != null) {
      Map<String, dynamic> user = jsonDecode(userJson);
      var userId = user['idUser'];
      var updatedUserData = {
        'usersName': _userNameController.text,
        'lastName':
            _lastName, 
        'city': _cityController.text,
        'email': _emailController.text,
        'bio': _bioController.text,
      };
      final response = await http.put(
          Uri.parse('$baseUrl/settings/update/$userId'),
          body: jsonEncode(updatedUserData),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Modifications enregistrées avec succès')));
        // Recharger les données de l'utilisateur
        box.put('userDetails', jsonEncode(updatedUserData));
         Navigator.pop(context, true);
      } else {
        // Gérer l'échec de la sauvegarde
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Échec de la sauvegarde des modifications')));
      }
    }
  }

  // Fonction pour récupérer les données de la ville depuis l'API
  Future<void> _fetchCities(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://geo.api.gouv.fr/communes?nom=$cityName&fields=departement&boost=population&limit=5'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<String> cityNames = [];
      for (var cityData in jsonData) {
        cityNames.add(cityData['nom']);
      }
      setState(() {
        cities = cityNames;
      });
    } else {
      throw Exception('Échec de la récupération des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations du profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Nom d\'utilisateur : $_usersName',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Pseudonyme',
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ville',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _cityController,
                  onChanged: (cityName) {
                    if (cityName.isNotEmpty) {
                      _fetchCities(cityName);
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                if (cities.isNotEmpty)
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(cities[index]),
                          onTap: () {
                            setState(() {
                              _cityController.text = cities[index];
                              cities.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Appliquer mes changements et se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
