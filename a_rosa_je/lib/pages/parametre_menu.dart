import 'dart:convert';
import 'package:a_rosa_je/pages/demande_botaniste.dart';
import 'package:a_rosa_je/pages/politique.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'gestion_annonces.dart';
import 'login_page.dart';
import 'profil.dart';
import 'profil_info.dart';
import 'home.dart';
import '../util/footer.dart'; // Importez votre widget Footer depuis son emplacement

class ParametreMenu extends StatefulWidget {
  @override
  _ParametreMenuState createState() => _ParametreMenuState();
}

class _ParametreMenuState extends State<ParametreMenu> {
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
      body: MySettingsPage(),
      // bottomNavigationBar: Footer(
      //   selectedIndex: 2, // Index correspondant à ParametreMenu
      //   onItemSelected: (index) {
      //     switch (index) {
      //       case 0:
      //         Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(builder: (context) => HomePage()),
      //           (Route<dynamic> route) => false,
      //         );
      //         break;
      //       case 1:
      //         Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(builder: (context) => GestionAnnoncesPage()),
      //           (Route<dynamic> route) => false,
      //         );
      //         break;
      //       case 3:
      //         Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(builder: (context) => ProfilPage()),
      //           (Route<dynamic> route) => false,
      //         );
      //         break;
      //     }
      //   },
      // ),
    );
  }
}

class MySettingsPage extends StatelessWidget {
  final baseUrl = dotenv
      .env['API_BASE_URL']; // pour récupérer l'url de base dans le fichier .env
  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      var box = await Hive.openBox('userBox');
      var userJson = box.get('userDetails');
      if (userJson != null) {
        Map<String, dynamic> user = jsonDecode(userJson);
        var userId = user['idUser'];
        final response =
            await http.delete(Uri.parse('$baseUrl/settings/delete/$userId'));

        if (response.statusCode == 200) {
          await box.delete('userDetails');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          print('Échec de la suppression du compte');
        }
      }
    } catch (e) {
      print('Erreur lors de la suppression du compte: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      var box = await Hive.openBox('userBox');
      await box.delete('userDetails');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DemandeBotanistePage()),
              );
            },
          ),
          // ListTile(
          //   title: Text('Télécharger les données'),
          //   onTap: () {
          //     // Handle tap
          //   },
          // ),
          ListTile(
            title: Text('Politique de confidentialité'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PolitiquePage()),
              );
            },
          ),
          ListTile(
            title: Text('Se déconnecter'),
            onTap: () {
              logout(context);
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
                          Navigator.of(context).pop();
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
    );
  }
}
