import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import '../api/api_service.dart';
import 'home.dart';


class CreateCommentaire extends StatefulWidget {
  @override
  _CreateCommentaireState createState() => _CreateCommentaireState();
}

class _CreateCommentaireState extends State<CreateCommentaire> 
   with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 7));
  DateTime creationDate = DateTime.now(); // Ajout de la date de création
  final _formKey = GlobalKey<FormState>();
  String title = ''; // Variable pour stocker le titre de l'annonced
  String description = '';
  int _idUserLocal = 0;
  String _city = '';
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env

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
        _idUserLocal = user['idUser'] ?? 0;
        _city = user['city'] ?? 'N/A';
      });
    }
  }

  


  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poster un commentaire'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Description TextFormField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ajouter un commentaire :',
                    alignLabelWithHint: true, // Aligns the label with the hint text
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4, // Set to your preference
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    description = value!;
                  },
                ),
              ),
              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
              
                      
                      // Appel à l'API pour créer l'annonce
                      final response = await ApiCreateCommentaire.createCommentaire(
                        idUser: _idUserLocal,
                        idPlant: 1,
                        commentaire: description,

                      );
                      // Vérifier la réponse de l'API
                      if (response.statusCode == 200 || response.statusCode == 201 ) {
                        // Gestion de la réponse réussie
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Commentaire posté avec succès')),
                        );
                        // Retour à la page d'accueil en retirant toutes les routes jusqu'à celle-ci
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()), // Remplacez HomePage() par votre widget de page d'accueil
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        // Gestion de l'échec de la réponse
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de la création d\'un commentaire ${response.statusCode}')),
                        );
                      }
                    }
                  },
                  child: Text('Poster votre commentaire'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
