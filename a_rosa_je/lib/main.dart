import 'package:a_rosa_je/pages/home.dart';
import 'package:a_rosa_je/pages/profil.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/sign_in.dart';
import 'pages/parametre_menu.dart';
import 'pages/profil_info.dart';
import 'package:http/http.dart' as http;

// ignore: duplicate_import
//import 'pages/profil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: LoginPage(),
      // home: ProfilePage(),
      //  home: HomePage(),
      home: RegistrationScreen(),
      // home: ParametreMenu(),
      // home: SettingsPage(),
    );
  }
}


