import 'package:flutter/material.dart';

class MesGardiennageTileJob extends StatelessWidget {
 final String idAdvertisement;
  final String title;
  final String city;
  final String idPlant;
  final String name;
  final String userName;
  final String description;
  final String startDate;
  final String endDate;
  final String imageUrl; 
  final String createdAt;

  MesGardiennageTileJob({
    Key? key,
    required this.idAdvertisement,
    required this.title,
    required this.city,
    required this.idPlant,
    required this.name,
    required this.userName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.createdAt,
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
        height: 200.0, // Hauteur fixe de la Card
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.horizontal(left: Radius.circular(15.0)),
              child: imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute
                  ? Image.network(
                      imageUrl,
                      width: 150.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'images/plant_default.png', // Chemin vers une image par défaut
                      width: 150.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                        height:
                            8.0), // Ajoute un espace entre la description et les dates
                    Row(
                      // Nouvelle Row pour dateDebut et dateFin
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('Du : ' + startDate,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(width: 0), // Espace entre les deux textes
                        Expanded(
                          child: Text('au ' + endDate,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Row( // Row pour localisation et nbPlantes
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligner horizontalement à gauche
                      mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligner horizontalement à gauche
                            mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
                            children: [
                              Image.asset('images/bx_map-pin.png', height: 40.0),
                              Text(city, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        SizedBox(width: 0), // Espace entre les deux colonnes
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligner horizontalement à gauche
                            mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
                            children: [
                              Image.asset('images/ph_plant-light.png', height: 40.0),
                              Text(name, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0), // Ajoute un espace
                    Expanded(
                      child: Text(
                        '"' + description + '"',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 10.0), // Ajoute un espace
                    //statut en cours
                    Expanded(
                      child: Text(
                        'Statut : ' + userName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    // a garder si gardiennage validé
                    // Expanded(
                    //   child: Text(
                    //     'Je garde les plantes de ' + userName,
                    //     overflow: TextOverflow.ellipsis,
                    //     maxLines: 3,
                    //   ),
                    // ),
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
