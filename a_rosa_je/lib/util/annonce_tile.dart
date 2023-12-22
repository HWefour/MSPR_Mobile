import 'package:flutter/material.dart';

class AnnonceTile extends StatelessWidget {
  final String titre;
  final String localisation;
  final String nbPlantes;
  final String description;
  final String imageUrl;
  final String dateDebut;
  final String dateFin;

  AnnonceTile({
    Key? key,
    required this.titre,
    required this.localisation,
    required this.nbPlantes,
    required this.description,
    required this.imageUrl,
    required this.dateDebut,
    required this.dateFin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Ajoute une ombre sous la carte
      margin: EdgeInsets.all(8.0), // Marge autour de la carte
      shape: RoundedRectangleBorder( // Définir les bords arrondis de la Card
        borderRadius: BorderRadius.circular(15.0), // Rayon de l'arrondi
      ),
      child: Container(
        height: 180.0, // Hauteur fixe de la Card
        child: Row(
          children: [
            ClipRRect( // Clipper l'image pour qu'elle ait aussi les bords arrondis
              borderRadius: BorderRadius.horizontal(left: Radius.circular(15.0)), // Rayon de l'arrondi pour le côté gauche de l'image
              child: Image.network(
                imageUrl,
                width: 150.0, // Largeur fixe pour l'image
                height: 180.0, // Hauteur fixe pour l'image
                fit: BoxFit.cover, // Remplit l'espace alloué tout en gardant les proportions
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(titre, style: TextStyle(fontWeight: FontWeight.bold)),
                    Row( // Nouvelle Row pour localisation et nbPlantes
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(localisation, overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(width: 0), // Espace entre les deux textes
                        Expanded(
                          child: Text(nbPlantes, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0), // Ajoute un espace
                    Expanded(
                      child: Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 8.0), // Ajoute un espace entre la description et les dates
                    Row( // Nouvelle Row pour dateDebut et dateFin
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('Du : ' + dateDebut, overflow: TextOverflow.ellipsis),
                        ),
                      SizedBox(width: 10), // Espace entre les deux textes
                        Expanded(
                          child: Text('au ' + dateFin, overflow: TextOverflow.ellipsis),
                      ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
