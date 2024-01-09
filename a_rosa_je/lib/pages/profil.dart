import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('path/to/header_image.png'),
            CircleAvatar(
              backgroundImage: AssetImage('path/to/avatar.png'),
              radius: 40.0,
            ),
            Text(
              'Plantedu34',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Je suis un féru de plantes d\'intérieur !\nMa spécialité, ce sont les pothos et les Monsteras.\nDisponible sur Montpellier.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Mes plantes'),
              onPressed: () {
                // Handle button press
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Mes Annonces'),
              onPressed: () {
                // Handle button press
              },
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(4, (index) {
                return Card(
                  child: Image.asset('path/to/plant_image_$index.png'),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Tchat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        // Handle navigation tap
        onTap: (index) {},
      ),
    );
  }
}
