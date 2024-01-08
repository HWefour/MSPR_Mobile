import 'package:a_rosa_je/util/footer.dart';
import 'package:flutter/material.dart';
import '../util/annonce_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.green, // Couleur de l'arrière-plan de la barre d'applications
        // Ajoutez d'autres propriétés à AppBar si nécessaire
      ),
      body: ListView(
        children: <Widget>[
          // Vous pouvez utiliser un ListView.builder si vous chargez une liste d'annonces
          AnnonceTile(
            titre: 'Monstera à garder',
            localisation: 'Tourcoing',
            nbPlantes: '2 plantes moyennes',
            description: 'Bonjour, je dois m’absenter pour Noël et je cherche quelqu’un qui pourrait garder mes deux monsteras sur la ville de Tourcoing. Je suis disponible...',
            imageUrl: 'https://images.pexels.com/photos/1407305/pexels-photo-1407305.jpeg',
            dateDebut: '21/12/23',
            dateFin: '31/12/23',
          ),
          AnnonceTile(
            titre: 'Monstera à garder',
            localisation: 'Tourcoing',
            nbPlantes: '2 plantes moyennes',
            description: 'Bonjour, je dois m’absenter pour Noël et je cherche quelqu’un qui pourrait garder mes deux monsteras sur la ville de Tourcoing. Je suis disponible...',
            imageUrl: 'https://images.pexels.com/photos/1407305/pexels-photo-1407305.jpeg',
            dateDebut: '21/12/23',
            dateFin: '31/12/23',
          ),
          AnnonceTile(
            titre: 'Monstera à garder',
            localisation: 'Tourcoing',
            nbPlantes: '2 plantes moyennes',
            description: 'Bonjour, je dois m’absenter pour Noël et je cherche quelqu’un qui pourrait garder mes deux monsteras sur la ville de Tourcoing. Je suis disponible...',
            imageUrl: 'https://images.pexels.com/photos/1407305/pexels-photo-1407305.jpeg',
            dateDebut: '21/12/23',
            dateFin: '31/12/23',
          ),
          // Ajoutez autant de AnnonceTile que nécessaire
        ],
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic for posting an ad
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF1B5E20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}