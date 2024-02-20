import 'package:flutter/material.dart';

class PlanteTile extends StatelessWidget {
  final String idPlant;
  final String name;
  final String description;
  final String imageUrl;
  PlanteTile({
    Key? key,
    required this.idPlant,
    required this.name,
    required this.description,
    required this.imageUrl,
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
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)), //nom de la plante
                    SizedBox(
                        height: 8.0), // Ajoute un espace
                    SizedBox(height: 10.0), // Ajoute un espace
                    Expanded(
                      child: Text(
                        '"' + description + '"', //description de la plante
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
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
