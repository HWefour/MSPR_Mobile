import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'profil_info.dart';
import 'home.dart';

class ParametreMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MySettingsPage(),
    );
  }
}

class MySettingsPage extends StatelessWidget {
  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      var box = await Hive.openBox('userBox');
      var userJson = box.get('userDetails');
      if (userJson != null) {
        Map<String, dynamic> user = jsonDecode(userJson);
        var userId = user['idUser']; // Assurez-vous d'avoir l'ID de l'utilisateur
        final response = await http.delete(Uri.parse('http://localhost:1212/settings/delete/$userId'));
        
        if (response.statusCode == 200) {
          // Suppression réussie, effacer les données utilisateur locales
          await box.delete('userDetails');

          // Naviguer vers la page de connexion
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Gérer l'échec de la suppression
          print('Échec de la suppression du compte');
        }
      }
    } catch (e) {
      // Gérer les erreurs de connexion ou d'autres erreurs possibles
      print('Erreur lors de la suppression du compte: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      var box = await Hive.openBox('userBox');
      // Effacer les données utilisateur locales
      await box.delete('userDetails');
      
      // Réinitialiser l'état d'authentification et naviguer vers la page de connexion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Gérer les erreurs possibles
      print('Erreur lors de la déconnexion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(width: 5),
            Text('Paramètres'),
          ],
        ),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SizedBox(height: 20),
            ListTile(
              title: Text('Informations du compte'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Notifications'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              title: Text('Demander le compte Botaniste'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              title: Text('Télécharger les données'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              title: Text('Politique de confidentialité'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              title: Text('Se déconnecter'),
              onTap: () {
                logout(context); // Appeler la fonction logout pour déconnecter l'utilisateur
              },
            ),
            ListTile(
              title: Text('Supprimer le compte',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirmation"),
                      content:
                          Text("Voulez-vous vraiment supprimer votre compte ?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme la popup
                          },
                          child: Text("Non"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await deleteUserAccount(context);
                          },
                          child: Text("Oui"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
