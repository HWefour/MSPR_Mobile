import 'dart:convert';

import 'package:a_rosa_je/api/api_service.dart';
import 'package:a_rosa_je/pages/create_coms.dart';
import 'package:a_rosa_je/pages/gestion_annonces.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../util/plantes.dart';

class PlantePopupCard extends StatefulWidget {
  final Plante plante;
  PlantePopupCard({Key? key, required this.plante}) : super(key: key);

  @override
  _AnnoncePopupCardState createState() => _AnnoncePopupCardState();
}

class _AnnoncePopupCardState extends State<PlantePopupCard> 
   with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  
  DateTime creationDateJob = DateTime.now(); // Ajout de la date de création
  int _idUser = 0;
  String _firstName = '';
  String _lastName = '';
  String _usersName = '';
  String _email = '';
  String _city = '';
  String _bio = '';
  String _siret = '';
  String _companyName = '';
  String _companyNumber = '';
  int _idRole = 0;
  

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    var box = await Hive.openBox('userBox');
    var userJson = box.get('userDetails');
    if (userJson != null) {
      // Assume userJson is a JSON string that needs to be decoded
      Map<String, dynamic> user = jsonDecode(userJson);
      // Utilisez `user` pour mettre à jour l'état de l'interface utilisateur si nécessaire
      setState(() {
        //Mettez à jour votre état avec les informations de l'utilisateur
        _idUser = user['idUser'] ?? 0;
        _firstName = user['firstName'] ?? 'N/A';
        _lastName = user['lastName'] ?? 'N/A';
        _usersName = user['usersName'] ?? 'N/A';
        _email = user['email'] ?? 'N/A';
        _city = user['city'] ?? 'N/A';
        _bio = user['bio'] ?? 'N/A';
        _siret = user['siret'] ?? 'N/A';
        _companyName = user['companyName'] ?? 'N/A';
        _companyNumber = user['companyNumber'] ?? 'N/A';
        _idRole = user['idRole'];
      });
    }
  }

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
                        widget.plante.name ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.plante.description ?? 'N/A',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2 * 1 - 1, (index) {
                        // Multiplie par 2 et soustrait 1 pour alterner image et espace
                        if (index % 2 == 0) {
                          // Image
                          if (widget.plante.imageUrls != null &&
                              widget.plante.imageUrls!.isNotEmpty) {
                            // S'il y a au moins une image dans imageUrls
                            if (index ~/ 1 < widget.plante.imageUrls!.length) {
                              // S'il y a une image correspondante dans imageUrls
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  widget.plante.imageUrls![index ~/ 1],
                                  width: MediaQuery.of(context).size.width -
                                      32, // Ajustez selon le padding/margin global
                                  height: 400.0, // Ajustez selon vos besoins
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          }
                          // S'il n'y a pas d'image dans imageUrls ou si l'image correspondante n'existe pas
                          // Utilisation de l'image par défaut
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
                            height: 10.0,
                          ); // Hauteur de l'espace entre les images
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateCommentaire(idPlant: int.parse(widget.plante.idPlant!))),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36), // makes it stretch
                  ),
                  child: Text('Ajouter un commentaire'),
                ),  
              ),
            ),
          ],
        ),
      ),
    );
  }
}
