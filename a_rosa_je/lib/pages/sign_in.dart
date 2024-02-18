import 'package:a_rosa_je/pages/login_page.dart';
import 'package:a_rosa_je/pages/politique.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isChecked = false;
  final baseUrl = dotenv
      .env['API_BASE_URL']; // pour récupérer l'url de base dans le fichier .env

  // Validation de l'email
  bool isEmailValid(String email) {
    String pattern =
        '^[a-zA-Z0-9.!#\$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*\$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Validation du mot de passe
  bool isPasswordValid(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`^(){}\[\]:";\<>?,./\\\-_=+]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  Future<void> createUserAndNavigate() async {
    if (!isEmailValid(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer une adresse e-mail valide.'),
        ),
      );
      return;
    }

    if (!isPasswordValid(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Le mot de passe doit contenir au moins une majuscule, une minuscule, un chiffre, un caractère spécial et au moins 8 caractères.'),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Les mots de passe ne correspondent pas.'),
        ),
      );
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Veuillez accepter les conditions générales et la politique de confidentialité.'),
        ),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/auth/signup');
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Votre compte utilisateur a bien été créé'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      if (responseData['error'] == 'email_exists') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Un utilisateur existe déjà avec cette adresse e-mail.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Une erreur s\'est produite lors de la création de l\'utilisateur.'),
          ),
        );
      }
      return;
    } else {
      // Gestion des autres codes d'état HTTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de la création de l\'utilisateur. Réessayez plus tard.'),
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
          TextFieldWidget(
            hintText: 'Confirmer le mot de passe',
            obscureText: true,
            controller: _confirmPasswordController,
          ),
          SizedBox(height: 24.0),
Row(
  children: [
    Checkbox(
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value ?? false;
        });
      },
    ),
    SizedBox(width: 8.0),
    Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Politique de Confidentialité'),
                content: SingleChildScrollView(
                  child: Text(
                    'Chez A\'rosa_je, nous nous engageons à protéger votre vie privée. Cette politique de confidentialité explique comment nous recueillons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre site web ou nos services.',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fermer'),
                  ),
                ],
              );
            },
          );
        },
        child: Text(
          'J\'accepte les conditions générales et la politique de confidentialité',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
),

          SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButtonWidget(
                  buttonText: 'Inscription',
                  buttonColor: Colors.brown,
                  onPressed: createUserAndNavigate,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Connexion'),
                  ),
                ),
              ),
            ],
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
