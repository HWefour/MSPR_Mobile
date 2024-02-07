import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:a_rosa_je/util/footer.dart';
import '../util/annonce_popup_card.dart';
import '../util/annonce_tile.dart';
import '../api/api_service.dart';
import '../util/annonce.dart';
import 'create_annonce.dart';
import 'home.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _selectedIndex = 4;
  final ApiAnnoncesUser apiAnnoncesUser = ApiAnnoncesUser();


 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  //affiche le popup des annonces
  void _showPopup(Annonce annonce) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnnoncePopupCard(annonce: annonce);
      },
    );
  }

  // Méthode pour afficher les informations d'erreur sous forme de dialogue
  Widget _buildErrorDialog(BuildContext context, dynamic error) {
    String jsonString = json.encode(error); // Convertir l'erreur en chaîne JSON
    return AlertDialog(
      title: Text("Erreur de chargement"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Une erreur s'est produite lors du chargement des annonces :"),
            SizedBox(height: 10),
            Text("Erreur :"),
            SizedBox(height: 5),
            Text(jsonString), // Afficher le contenu JSON de l'erreur
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
          },
          child: Text("OK"),
        ),
      ],
    );
  }


  //widget d'affichage de la list des annonces
  Widget _buildAnnoncesList() {
    return Column(
      children: [
        // affichage des annonces de l'utilisateur
        Expanded(
          child: FutureBuilder<List<Annonce>>(
            future: apiAnnoncesUser.fetchAnnoncesUser('16'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Appeler la méthode pour afficher les informations d'erreur
                return _buildErrorDialog(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Annonce annonce = snapshot.data![index];
                    return GestureDetector(
                      onTap: () => _showPopup(annonce),
                      child: AnnonceTile(
                        idAdvertisement: annonce.idAdvertisement ?? 'N/A',
                        title: annonce.title ?? 'N/A',
                        city: annonce.city ?? 'N/A',
                        idPlant: annonce.name ??'N/A', 
                        name: annonce.name ?? 'N/A',
                        userName: annonce.usersName ?? 'N/A',
                        description: annonce.description ?? 'N/A',
                        startDate: annonce.startDate ?? 'N/A',
                        endDate: annonce.endDate ?? 'N/A',
                        imageUrl: 'images/plant_default.png', // Utilisez l'URL réelle de l'image si disponible
                        createdAt: annonce.createdAt ?? 'N/A',
                      ),
                    );
                  },
                );
              } else {
                setState(() {
            
                          });
                return Text("No data");
              }
            },
          ),
        ),
      ],
    );  
  }

  //widget d'affichage des images du User
  Widget _buildImageProfil() {
    return Column(
      children: [
        // affichage des images 
      ],
    );  
  }
  
  //gestion du tap sur le footer
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: 
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()), // permet d'aller vers la page sans conserver les routes
          (Route<dynamic> route) => false,
        );
        break;
      default:
        break;
    }
  }

  //build 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white, // Couleur de fond pour TabBar
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.image), text: "Mes Images"),
                Tab(icon: Icon(Icons.list), text: "Mes Annonces"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildImageProfil(),
                _buildAnnoncesList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateAnnonce()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF1B5E20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
