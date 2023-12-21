import 'package:a_rosa_je/pages/profil.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
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
      home: LoginPage(),
      //home: ProfilePage(),
    );
  }
}