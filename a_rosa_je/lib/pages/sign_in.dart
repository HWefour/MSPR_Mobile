
import 'package:a_rosa_je/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/api_service.dart';
// import 'login_page.dart'; // Assurez-vous d'importer la page LoginPage ici

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedCity = '';
  List<String> cities = [];
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> createUserAndNavigate() async {
    final url = Uri.parse('http://192.168.56.1:1212/auth/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "usersName": _userNameController.text,
        "email": _emailController.text,
        "city": selectedCity,
        "bio": "bio", // Vous pouvez modifier cela si nécessaire
        "password": _passwordController.text,
        "idRole": "2" // Vous pouvez modifier cela si nécessaire
      }),
    );
    int _selectedIndex = 0;
    final ApiService apiService = ApiService();

    if (response.statusCode == 201) {
      // L'utilisateur a été créé avec succès.
      // Vous pouvez afficher un message de succès ou effectuer d'autres actions ici.

      // Redirigez l'utilisateur vers la page LoginPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // La création de l'utilisateur a échoué.
      // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la création de l\'utilisateur'),
        ),
      );
    }
  }

  Future<void> fetchCities(String cityName) async {
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
      backgroundColor: Color(0xFF1B5E20),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Image(image: AssetImage('images/LOGO.png')),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Nom',
            controller: _firstNameController,
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Prénom',
            controller: _lastNameController,
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Pseudonyme',
            controller: _userNameController,
          ),
          SizedBox(height: 24.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ville',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _cityController,
                onChanged: (cityName) {
                  if (cityName.isNotEmpty) {
                    fetchCities(cityName);
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
                            selectedCity = cities[index];
                            _cityController.text = selectedCity;
                            cities.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Email',
            controller: _emailController,
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Mot de passe',
            obscureText: true,
            controller: _passwordController,
          ),
          SizedBox(height: 24.0),
          Row(
            children: [
              // Checkbox(
              //   value: isChecked,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       isChecked = value ?? false;
              //     });
              //   },
              // ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'J\'accepte les conditions générales et la politique de confidentialité',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          ElevatedButtonWidget(
            buttonText: 'Inscription',
            buttonColor: Colors.brown,
            onPressed: () {
              createUserAndNavigate();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
    );
  }
}

class ElevatedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const ElevatedButtonWidget({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: Colors.white,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(buttonText),
      ),
    );
  }
}

// Implémentez la page LoginPage ici selon vos besoins
// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Page de Connexion'),
//       ),
//       body: Center(
//         child: Text(
//             'Vous êtes redirigé vers la page de connexion après inscription.'),
//       ),
//     );
//   }
// }
