import 'package:a_rosa_je/pages/create_annonce.dart';
import 'package:a_rosa_je/pages/home.dart';
import 'package:a_rosa_je/pages/profil.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/sign_in.dart';
import 'pages/parametre_menu.dart';
import 'pages/profil_info.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart'; //pour le stockage en local

// ignore: duplicate_import
import 'pages/profil.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}
Future<bool> _checkUserLoggedIn() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('userBox');
  var userJson = box.get('userDetails');
  await box
      .close(); // Fermer la boîte après l'accès pour libérer des ressources
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
          // Vérifier si la future est terminée et si l'utilisateur est connecté
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // Les données utilisateur existent, donc diriger vers HomePage
              return HomePage();
            } else {
              // Pas de données utilisateur, donc diriger vers LoginPage
              return LoginPage();
            }
          } else {
            // Afficher un indicateur de chargement pendant que la vérification est en cours
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
