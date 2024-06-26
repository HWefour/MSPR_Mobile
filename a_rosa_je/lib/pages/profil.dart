import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:a_rosa_je/util/footer.dart';
import 'package:hive/hive.dart';
import '../util/annonce_popup_card.dart';
import '../util/annonce_tile.dart';
import '../api/api_service.dart';
import '../util/annonce.dart';
import 'create_annonce.dart';
import 'gestion_annonces.dart';
import 'home.dart';
import 'parametre_menu.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _selectedIndex = 4;
  final ApiAnnoncesUser apiAnnoncesUser = ApiAnnoncesUser();
  int _idUserLocal = 0 ;
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
    _tabController = TabController(length: 2, vsync: this);
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
        _firstName = user['firstName'] ?? 'N/A';
        _lastName = user['lastName'] ?? 'N/A';
        _usersName = user['usersName'] ?? 'N/A';
        _email = user['email'] ?? 'N/A';
        _city = user['city'] ?? 'N/A';
        _bio = user['bio'] ?? 'N/A';
        _siret = user['siret']??'N/A';
        _companyName = user['companyName'] ??'N/A';
        _companyNumber = user['companyNumber'] ?? 'N/A';
        _idRole = user['idRole'];
      });
    }
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
            future: apiAnnoncesUser.fetchAnnoncesUser(_idUserLocal.toString()),
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
                        idAdvertisement: annonce.idAdvertisement ?? '0',
                        title: annonce.title ?? 'N/A',
                        city: annonce.city ?? 'N/A',
                        idPlant: annonce.name ?? 'N/A',
                        name: annonce.name ?? '',
                        userName: annonce.usersName ?? 'N/A',
                        description: annonce.description ?? 'N/A',
                        startDate: annonce.startDate ?? 'N/A',
                        endDate: annonce.endDate ?? 'N/A',
                        imageUrl:
                            'images/plant_default.png', // Utilisez l'URL réelle de l'image si disponible
                        createdAt: annonce.createdAt ?? 'N/A',
                      ),
                    );
                  },
                );
              } else {
                setState(() {});
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
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // permet d'aller vers la page sans conserver les routes
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  GestionAnnoncesPage()), // permet d'aller vers la page sans conserver les routes
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Mettez ici la logique pour accéder à la page des paramètres
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ParametreMenu()));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10), // Espace au-dessus du Container
          // Espace pour afficher la photo de profil, le nom de l'utilisateur et la biographie
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50, // Rayon du cercle de la photo de profil
                  backgroundImage: AssetImage(
                      'assets/profile_picture.jpg'), // Remplacez par le chemin de votre photo de profil
                ),
                SizedBox(
                    height:
                        10), // Espace entre la photo de profil et le nom de l'utilisateur
                Text(
                  _usersName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height:
                        10), // Espace entre le nom de l'utilisateur et la biographie
                Text(
                  _bio,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Espace en dessous du Container
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
