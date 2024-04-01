import 'package:a_rosa_je/pages/home.dart';
import 'package:a_rosa_je/pages/parametre_menu.dart';
import 'package:a_rosa_je/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final baseUrl = dotenv.env['API_BASE_URL']; // pour récupérer l'url de base dans le fichier .env

  //fonction loginUser
  Future<void> loginUser(BuildContext context) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text,
        }),
      );
      print('premier ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('succès');
        final token = jsonDecode(response.body)['token'];
        print('Token: $token'); 
        await storeToken(token);
        fetchUsersAndCompareEmail(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Connexion réussie')));
      } else if (response.statusCode == 401) {
        print('Erreur d\'authentification : ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Adresse mail ou mot de passe incorrect')));
      } else {
        print('Erreur HTTP non gérée : ${response.statusCode}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur HTTP non gérée')));
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur lors de la connexion')));
    }
  }

  Future<void> storeToken(String token) async {
    var box = await Hive.openBox('userBox');
    await box.put('token', token);
  }

  Future<void> fetchUsersAndCompareEmail(BuildContext context) async {
    final url = Uri.parse('$baseUrl/backoffice/users/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        final userInputEmail = _emailController.text;

        // Trouver l'utilisateur avec l'email correspondant
        final user = users.firstWhere(
          (user) => user['email'] == userInputEmail,
          orElse: () => null,
        );

        if (user != null) {
          String userJson = jsonEncode(user);
          print("Détails de l'utilisateur trouvé : $userJson");

          //j'ouvre la boite Hive
          var box = await Hive.openBox('userBox');
          // Stocker la chaîne JSON
          await box.put('userDetails', userJson);
          // Redirigez l'utilisateur vers la page d'accueil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Aucun utilisateur trouvé avec cet email
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Aucun utilisateur trouvé avec cet email.'),
            ),
          );
        }
      } else {
        // Gestion des erreurs de réponse
        print(
            "Erreur lors de la récupération des utilisateurs: ${response.statusCode}");
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    var box = await Hive.openBox('userBox');
    var token = await box.get('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B5E20),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image(image: AssetImage('images/LOGO.png')),
                SizedBox(height: 48.0),
                TextFieldWidget(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                SizedBox(height: 16.0),
                TextFieldWidget(
                  controller: _passwordController,
                  hintText: 'Mot de Passe',
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                ElevatedButtonWidget(
                  buttonText: 'Se connecter',
                  buttonColor: Colors.red,
                  onPressed: () {
                    loginUser(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'Pas encore de compte ? Inscrivez-vous !',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
