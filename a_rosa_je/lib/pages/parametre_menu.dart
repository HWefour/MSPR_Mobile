import 'package:a_rosa_je/pages/profil.dart';
import 'package:flutter/material.dart';
import 'profil_info.dart';

void main() {
  runApp(ParametreMenu());
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: BackButton(),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the children horizontally
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Image(
            //   image: AssetImage('images/LOGO.png'),
            //   height: 50, // You can adjust the size of the image here
            // ),
            SizedBox(
                width: 5), // Provide some spacing between the logo and the text
            Text('Paramètres'),
          ],
        ),
        // Other AppBar properties...
      ),
      // The rest of your Scaffold content...

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
                  MaterialPageRoute(builder: (context) => (SettingsPage())),
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
                // Handle tap
              },
            ),
            ListTile(
              title: Text('Supprimer le compte',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ).toList(),
      ),
      // body: ListView.builder(
      //   itemCount: 7, // Nombre de tuiles
      //   itemBuilder: (BuildContext context, int index) {
      //     return Column(
      //       children: [
      //         SizedBox(height: 20), // Boîte de taille avec une largeur de 12
      //         ListTile(
      //           title: Text(
      //             index == 0
      //                 ? 'Informations du compte'
      //                 : index == 1
      //                     ? 'Notifications'
      //                     : index == 2
      //                         ? 'Demander le compte Botaniste'
      //                         : index == 3
      //                             ? 'Télécharger les données'
      //                             : index == 4
      //                                 ? 'Politique de confidentialité'
      //                                 : index == 5
      //                                     ? 'Se déconnecter'
      //                                     : 'Supprimer le compte',
      //             style: index == 6 ? TextStyle(color: Colors.red) : null,
      //           ),
      //           onTap: () {
      //             // Gérer le clic ici
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
