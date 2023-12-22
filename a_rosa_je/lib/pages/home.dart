import 'package:flutter/material.dart';
import '../util/annonce_tile.dart';

class HomePage extends StatelessWidget {
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
          // Ajoutez autant de AnnonceTile que nécessaire
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Poster une annonce',
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
        // Configurez la navigation au bas de l'écran ici
      ),
    );
  }
}