import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    final url = Uri.parse('http://localhost:1212/auth/login');

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

      if (response.statusCode == 200) {
        // L'authentification a réussi. Vous pouvez afficher un message de succès ou effectuer d'autres actions ici.

        // Redirigez l'utilisateur vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // L'authentification a échoué.
        // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'authentification. Veuillez vérifier vos informations.'),
          ),
        );
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

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
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
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: Colors.white,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(buttonText),
      ),
      onPressed: onPressed,
    );
  }
}

// Remplacez HomePage par la page vers laquelle vous souhaitez rediriger après la connexion réussie.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Text('Bienvenue sur la page d\'accueil !'),
      ),
    );
  }
}

// Remplacez RegistrationScreen par la page d'inscription de votre application.
class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Center(
        child: Text('Page d\'inscription'),
      ),
    );
  }
}

// import 'package:a_rosa_je/pages/sign_in.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatelessWidget {
//   // final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
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
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 TextFieldWidget(
//                   controller: _passwordController,
//                   hintText: 'Mot de Passe',
//                   obscureText: true,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 24.0),
//                 ElevatedButtonWidget(
//                   buttonText: 'Se connecter',
//                   buttonColor: Colors.red,
//                   onPressed: () {
//                     // Handle login logic
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
//                       MaterialPageRoute(builder: (context) => RegistrationScreen(),)
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

//   const TextFieldWidget({
//     Key? key,
//     required this.hintText,
//     this.obscureText = false,
//     required TextEditingController controller,
//     required String? Function(dynamic value) validator,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
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

// class LogoWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Ideally, you'd use an AssetImage or NetworkImage depending on where your logo is hosted
//     // For example, AssetImage('assets/logo.png'),
//     return Container(
//       height: 200,
//       width: 200,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.rectangle,
//       ),
//       child: Center(
//         // Replace with your actual logo image
//         child: Text(
//           'LOGe',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
