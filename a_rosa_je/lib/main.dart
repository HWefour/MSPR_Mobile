// ignore_for_file: prefer_const_constructors

import 'package:a_rosa_je/pages/home.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
<<<<<<< HEAD
import 'package:hive_flutter/hive_flutter.dart'; //pour le stockage en local
=======
import 'pages/sign_in.dart';
import 'pages/parametre_menu.dart';
import 'pages/profil_info.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart'; // pour le stockage en local
>>>>>>> origin/alex
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importez votre page web_socket.dart ici
import 'web_socket.dart'; // Remarque : Importez ici

void main() async {
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

Future<bool> _checkUserLoggedIn() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('userBox');
  var userJson = box.get('userDetails');
<<<<<<< HEAD
  await box
      .close(); // Fermer la boîte 
=======
  await box.close(); // Fermer la boîte après l'accès pour libérer des ressources
>>>>>>> origin/alex
  return userJson != null;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Rosa Je',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomePage();
            } else {
              return LoginPage();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
