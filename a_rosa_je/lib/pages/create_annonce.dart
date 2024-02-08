import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import '../api/api_service.dart';
import 'home.dart';


class CreateAnnonce extends StatefulWidget {
  @override
  _CreateAnnonceState createState() => _CreateAnnonceState();
}

class _CreateAnnonceState extends State<CreateAnnonce> 
   with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 7));
  DateTime creationDate = DateTime.now(); // Ajout de la date de création
  final _formKey = GlobalKey<FormState>();
  String title = ''; // Variable pour stocker le titre de l'annonce
  String city = 'Montpellier'; //à modifier plus tard
  String description = '';
  int numberOfPlants = 0;
  int selectedPlantId = 0;
  TextEditingController plantSearchController = TextEditingController();
  List<Map<String, dynamic>> plants = [];
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
  List<XFile>? imageFiles = [];

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

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? selectedStartDate : selectedEndDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030, 12),
    );
    if (picked != null && picked != (isStart ? selectedStartDate : selectedEndDate))
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
  }

  Future<void> _openImagePicker(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Prendre une photo'),
                  onTap: () {
                    _takePhotoWithCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choisir depuis la galerie'),
                    onTap: () {
                      _pickImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                
              ],
            ),
          );
        }
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFiles?.add(selectedImage);
      });
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFiles?.add(photo);
      });
    }
  }


  //api pour chercher une plante
  Future<void> fetchNamePlant(String namePlant) async {
    final response = await http.get(
      Uri.parse('http://localhost:1212/plant/'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, dynamic>> plantsData = []; // Stockez les noms et IDs des plantes
      for (var plantData in jsonData) {
        if (plantData['name'].toLowerCase().contains(namePlant.toLowerCase())) {
          plantsData.add({
            'name': plantData['name'],
            'idPlant': plantData['idPlant'], // Supposons que chaque plante a un champ 'idPlant'
          });
        }
      }
      setState(() {
        plants = plantsData;
      });
    } else {
      throw Exception('Échec de la récupération des données');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poster une annonce'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //champ titre
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
              ),
              //champ date creation
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: DateFormat('dd/MM/yyyy').format(creationDate), // Affichez la date de création
                  enabled: false, // Désactive l'édition
                  decoration: InputDecoration(
                    labelText: 'Date de création',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              //champ ville
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _city, // Affichez la ville actuelle
                  enabled: false, // Désactive l'édition
                  decoration: InputDecoration(
                    labelText: _city,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              //champ namePlante
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: plantSearchController,
                  decoration: InputDecoration(
                    labelText: "Rechercher une plante...",
                    hintText: "Entrez le nom d'une plante",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  onChanged: (plantName) {
                    if (plantName.isNotEmpty) {
                      fetchNamePlant(plantName);
                    }
                  },
                ),
              ),
              SizedBox(height: 8.0),
              if (plants.isNotEmpty) ...[ // Ajout de ... pour étendre la liste de widgets
                Container(
                  height: 200.0, // Ajustez la hauteur selon vos besoins
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(plants[index]['name']),
                        onTap: () {
                          setState(() {
                            selectedPlantId = plants[index]['idPlant'];
                            plantSearchController.text = plants[index]['name'];
                            plants.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
              //date début et date fin
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the date pickers evenly
                  children: [
                    Expanded( // Use Expanded to ensure buttons don't overflow
                      child: TextButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text('Du: ${DateFormat('dd/MM/yyyy').format(selectedStartDate)}'),
                      ),
                    ),
                    SizedBox(width: 8), // Add space between buttons
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text('Au: ${DateFormat('dd/MM/yyyy').format(selectedEndDate)}'),
                      ),
                    ),
                  ],
                ),
              ),
              // Plus de champs pour le nombre de plantes, etc...
              // Description TextFormField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
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

              // Buttons for adding photos
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ajouter des photos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text('Prendre une photo'),
                        onPressed: () => _takePhotoWithCamera(),
                      ),
                    ),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.image, color: Colors.black),
                        label: Text('Joindre une image'),
                        onPressed: () => _pickImageFromGallery(),
                      ),
                    ),
                  ],
                ),
              ),
            // Image preview section
              SizedBox(height: 16), // Add space before displaying images
              imageFiles!.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                      itemCount: imageFiles!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4, // Spacing between images horizontally
                        mainAxisSpacing: 4, // Spacing between images vertically
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(imageFiles![index].path),
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Center(child: Text('Pas d\'images sélectionnées.')), // Center the text when no images are selected
              SizedBox(height: 16), // Add space before the submit button

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Conversion des dates au format String dd/MM/yyyy
                      String formattedStartDate = DateFormat('dd/MM/yyyy').format(selectedStartDate);
                      String formattedEndDate = DateFormat('dd/MM/yyyy').format(selectedEndDate);
                      String formattedCreationDate = DateFormat('dd/MM/yyyy').format(creationDate);
                      
                      // Appel à l'API pour créer l'annonce
                      final response = await ApiCreateAnnounce.createAnnounce(
                        title: title,
                        createdAt: formattedCreationDate,
                        idPlant: selectedPlantId,
                        idUser: _idUser, // Id user
                        description: description,
                        startDate: formattedStartDate,
                        endDate: formattedEndDate,
                      );
                      
                      // Vérifier la réponse de l'API
                      if (response.statusCode == 200 || response.statusCode == 201 ) {
                        // Gestion de la réponse réussie
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Annonce créée avec succès')),
                        );
                        // Retour à la page d'accueil en retirant toutes les routes jusqu'à celle-ci
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()), // Remplacez HomePage() par votre widget de page d'accueil
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        // Gestion de l'échec de la réponse
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de la création de l\'annonce ${response.statusCode}')),
                        );
                      }
                    }
                  },
                  child: Text('Poster votre annonce'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
