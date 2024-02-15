// import 'package:a_rosa_je/pages/sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> loginUser(BuildContext context) async {
//     final url = Uri.parse('http://localhost:1212/auth/login');

//     try {
//       final response = await http.post(
//         url,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode({
//           "email": _emailController.text,
//           "password": _passwordController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // L'authentification a réussi. Vous pouvez afficher un message de succès ou effectuer d'autres actions ici.

//         // Redirigez l'utilisateur vers la page d'accueil
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       } else {
//         // L'authentification a échoué.
//         // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Échec de l\'authentification. Veuillez vérifier vos informations.'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Erreur lors de la connexion : $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1B5E20),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Image(image: AssetImage('images/LOGO.png')),
//                 SizedBox(height: 48.0),
//                 TextFieldWidget(
//                   controller: _emailController,
//                   hintText: 'Email',
//                 ),
//                 SizedBox(height: 16.0),
//                 TextFieldWidget(
//                   controller: _passwordController,
//                   hintText: 'Mot de Passe',
//                   obscureText: true,
//                 ),
//                 SizedBox(height: 24.0),
//                 ElevatedButtonWidget(
//                   buttonText: 'Se connecter',
//                   buttonColor: Colors.red,
//                   onPressed: () {
//                     loginUser(context);
//                   },
//                 ),
//                 TextButton(
//                   child: Text(
//                     'Pas encore de compte ? Inscrivez-vous !',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegistrationScreen()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TextFieldWidget extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController controller;

//   const TextFieldWidget({
//     Key? key,
//     required this.hintText,
//     this.obscureText = false,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         hintText: hintText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// class ElevatedButtonWidget extends StatelessWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final VoidCallback onPressed;

//   const ElevatedButtonWidget({
//     Key? key,
//     required this.buttonText,
//     required this.buttonColor,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: buttonColor,
//         onPrimary: Colors.white,
//         shape: StadiumBorder(),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(buttonText),
//       ),
//       onPressed: onPressed,
//     );
//   }
// }

// // Remplacez HomePage par la page vers laquelle vous souhaitez rediriger après la connexion réussie.
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accueil'),
//       ),
//       body: Center(
//         child: Text('Bienvenue sur la page d\'accueil !'),
//       ),
//     );
//   }
// }
import 'package:a_rosa_je/pages/home.dart';
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
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env


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
    if (response.statusCode == 200) {
      // L'authentification a réussi. Vous pouvez afficher un message de succès ou effectuer d'autres actions ici.
      //ajout test lucas
      //connexion avec l'api pour trouver l'utilisateur correspondant
      print('je suis la');
      fetchUsersAndCompareEmail(context);
    } else if (response.statusCode == 401) {
      // 401 Unauthorized - L'authentification a échoué.
      // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
      print('Erreur d\'authentification : ${response.statusCode}');
    } else {
      // Autres cas de code de statut HTTP non gérés.
      // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
      print('Erreur HTTP non gérée : ${response.statusCode}');
    }
  } catch (e) {
    // Erreur lors de la requête HTTP.
    print('Erreur lors de la connexion : $e');
  }
}


  
  Future<void> fetchUsersAndCompareEmail(BuildContext context) async {
    final url = Uri.parse('$baseUrl/backoffice/users/');
    print('je suis ici');
    try {
      final response = await http.get(url);
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
          // Utilisateur trouvé, vous pouvez maintenant utiliser les données de l'utilisateur
          // Convertir l'utilisateur en chaîne JSON
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
        print("Erreur lors de la récupération des utilisateurs: ${response.statusCode}");
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
    }
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
                    style: TextStyle(color: Colors.white),
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
