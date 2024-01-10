import 'package:flutter/material.dart';
import '../util/annonce.dart';

class AnnoncePopupCard extends StatelessWidget {
  final Annonce annonce;

  AnnoncePopupCard({Key? key, required this.annonce}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: Container(
        padding: EdgeInsets.only(top: 16.0),
        height: 600.0, // Fixed popup height
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        annonce.titreAnnonce,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Annonce de : Marc',
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 8.0),
                              Text(('Localisation : Montpellier'),
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 8.0),
                              Text('Plantes : 2 plantes moyennes',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Du ${annonce.dateDebutGardeAnnonce}',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow
                                .ellipsis, // Ajouté pour gérer le débordement de texte
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'au ${annonce.dateFinGardeAnnonce}',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow
                                .ellipsis, // Ajouté pour gérer le débordement de texte
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      annonce.texteAnnonce,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2 * 2 - 1, (index) {
                        // Multiplie par 2 et soustrait 1 pour alterner image et espace
                        if (index % 2 == 0) {
                          // Image
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'images/plant_default.png',
                              width: MediaQuery.of(context).size.width -
                                  32, // Ajustez selon le padding/margin global
                              height: 400.0, // Ajustez selon vos besoins
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          // Espace
                          return SizedBox(
                              height:10.0); // Hauteur de l'espace entre les images
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), // Close the popup
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36), // makes it stretch
                  ),
                  child: Text('Contacter Marc'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
