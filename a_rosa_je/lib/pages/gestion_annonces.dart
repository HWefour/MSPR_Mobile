import 'package:a_rosa_je/pages/profil.dart';
import 'package:a_rosa_je/util/mes_annonce_tile_job.dart';
import 'package:a_rosa_je/util/mes_gardiennage_tile_job.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:a_rosa_je/util/footer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../util/annonce_job_popup_card.dart';
import '../api/api_service.dart';
import '../util/annonce.dart';
import 'create_annonce.dart';
import 'home.dart';

class GestionAnnoncesPage extends StatefulWidget {
  @override
  _GestionAnnoncesPageState createState() => _GestionAnnoncesPageState();
}

class _GestionAnnoncesPageState extends State<GestionAnnoncesPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _selectedIndex = 1;
  final ApiAnnoncesIdAdvertisement apiAnnoncesIdAdvertisement =
      ApiAnnoncesIdAdvertisement();
  int _idUserLocal = 0;
  List<Annonce> _currentMesAnnoncesJobs = [];
  List<Annonce> _currentMesGardiennagesJobs = [];
  List<Map<String, dynamic>> listMesAnnoncesJobs = [];
  List<Map<String, dynamic>> listMesGardiennagesJobs = [];
  final baseUrl = dotenv
      .env['API_BASE_URL']; // pour récupérer l'url de base dans le fichier .env

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    _loadUserProfile();
    fetchAllJobMesAnnonces(); //charge tous les jobs de mes annonces
    fetchAllJobMesGardiennages(); //charge tous les jobs de mes gardiennages
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
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  //affiche le popup des annonces Jobs
  void _showPopup(Annonce annonce) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnnonceJobPopupCard(annonce: annonce);
      },
    );
  }

  //gestion du filtrage des jobs par _idUser (userLocal)
  //pour afficher mes annonces avec job
  Future<void> fetchAllJobMesAnnonces() async {
    final response = await http.get(Uri.parse('$baseUrl/job/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, dynamic>> jobsMesAnnoncesData = [];
      for (var jobMesAnnoncesData in jsonData) {
        // Assurez-vous que jobData['idUser'] est traité comme une chaîne
        if ((jobMesAnnoncesData['idUser'] ?? '').toString() ==
            _idUserLocal.toString()) {
          jobsMesAnnoncesData.add({
            'idUser': jobMesAnnoncesData['idUser'].toString(),
            'idAdvertisement': jobMesAnnoncesData['idAdvertisement'].toString(),
            'idUserGardien': jobMesAnnoncesData['idUserGardien'].toString(),
          });
          searchMonAnnonceParId(jobMesAnnoncesData['idAdvertisement'].toString());
        }
      }
      setState(() {
        listMesAnnoncesJobs = jobsMesAnnoncesData;
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  //gestion du filtrage des jobs par _idUser (userLocal)
  //pour afficher mes gardiennages avec job
  Future<void> fetchAllJobMesGardiennages() async {
    final response = await http.get(Uri.parse('$baseUrl/job/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, dynamic>> jobsMesGardiennagesData = [];
      for (var jobMesGardiennagesData in jsonData) {
        if ((jobMesGardiennagesData['idUserGardien'] ?? '').toString() ==
            _idUserLocal.toString()) {
          jobsMesGardiennagesData.add({
            'idUser': jobMesGardiennagesData['idUser'].toString(),
            'idAdvertisement':
                jobMesGardiennagesData['idAdvertisement'].toString(),
            'idUserGardien': jobMesGardiennagesData['idUserGardien'].toString(),
          });
          searchAnnonceGardiennageParId(
              jobMesGardiennagesData['idAdvertisement'].toString());
        }
      }
      setState(() {
        listMesGardiennagesJobs = jobsMesGardiennagesData;
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }
  //récupération par Api de d'une annonce par son id et de ses images
  Future<void> searchMonAnnonceParId(dynamic idAdvertisement) async {
    try {
      // Tentative de récupérer une annonce par son id
      List<Annonce> annonces = await apiAnnoncesIdAdvertisement
          .fetchAnnoncesIdAdvertisement(idAdvertisement);
      if (annonces.isNotEmpty) {
        List<Annonce> annoncesMisesAJour =
            await Future.wait(annonces.map((annonce) async {
          List<String> imageUrls = await fetchImageUrlsForAnnonce(
              int.parse(annonce.idAdvertisement!));
          return annonce.copyWith(imageUrls: imageUrls);
        }));
        setState(() {
          _currentMesAnnoncesJobs = annoncesMisesAJour;
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des annonces : $e");
    }
    return null;
  }

  //récupération par Api d'une annonce que je vais garder par son id et de ses images
  Future<void> searchAnnonceGardiennageParId(dynamic idAdvertisement) async {
    try {
      // Tentative de récupérer une annonce par son id
      List<Annonce> annonces = await apiAnnoncesIdAdvertisement
          .fetchAnnoncesIdAdvertisement(idAdvertisement);
      if (annonces.isNotEmpty) {
        List<Annonce> annoncesMisesAJour =
            await Future.wait(annonces.map((annonce) async {
          List<String> imageUrls = await fetchImageUrlsForAnnonce(
              int.parse(annonce.idAdvertisement!));
          return annonce.copyWith(imageUrls: imageUrls);
        }));
        setState(() {
          _currentMesGardiennagesJobs = annoncesMisesAJour;
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des annonces : $e");
    }
    return null;
  }

  Future<List<String>> fetchImageUrlsForAnnonce(int idAnnonce) async {
    final url = Uri.parse('$baseUrl/images/show/$idAnnonce');
    final response = await http.get(url, headers: {'User-Agent': 'a_rosa_je'});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        List<String> urls = data.map((item) => item["url"] as String).toList();
        // Affichage des URLs
        return urls;
      } else {
        // Si les données sont vides, retourner une liste contenant uniquement l'image par défaut
        return ['images/plant_default.png'];
      }
    } else {
      // Si la requête échoue, retourner une liste contenant uniquement l'image par défaut
      return ['images/plant_default.png'];
    }
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

  //widget d'affichage de la list des annonces de l'annonceur qui ont un job
  Widget _buildMesAnnoncesGardeeList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _currentMesAnnoncesJobs.length,
            itemBuilder: (context, index) {
              Annonce annonce = _currentMesAnnoncesJobs[index];
              return GestureDetector(
                onTap: () => _showPopup(annonce),
                child: MesAnnonceTileJob(
                  idAdvertisement: annonce.idAdvertisement ?? '0',
                  title: annonce.title ?? 'N/A',
                  city: annonce.city ?? 'N/A',
                  idPlant: annonce.name ?? 'N/A', // Vérifiez ce champ, idPlant ou name?
                  name: annonce.name ?? 'N/A',
                  userName: annonce.usersName ?? 'N/A',
                  description: annonce.description ?? 'N/A',
                  startDate: annonce.startDate ?? 'N/A',
                  endDate: annonce.endDate ?? 'N/A',
                  imageUrl: annonce.imageUrls![0] ?? 'images/plant_default.png', // Supposé être un placeholder
                  createdAt: annonce.createdAt ?? 'N/A',
                  userNameGardien: '', //jobMesAnnonces['idUserGardien'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //widget d'affichage de la list des annonces de l'annonceur qui ont un job
  Widget _buildMesGardiennageList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _currentMesGardiennagesJobs.length,
            itemBuilder: (context, index) {
              Annonce annonce = _currentMesGardiennagesJobs[index];
              return GestureDetector(
                onTap: () => _showPopup(annonce),
                child: MesGardiennageTileJob(
                  idAdvertisement: annonce.idAdvertisement ?? '0',
                  title: annonce.title ?? 'N/A',
                  city: annonce.city ?? 'N/A',
                  idPlant: annonce.name ??
                      'N/A', // Vérifiez ce champ, idPlant ou name?
                  name: annonce.name ?? 'N/A',
                  userName: annonce.usersName ?? 'N/A',
                  description: annonce.description ?? 'N/A',
                  startDate: annonce.startDate ?? 'N/A',
                  endDate: annonce.endDate ?? 'N/A',
                  imageUrl: annonce.imageUrls![0] ??
                      'images/plant_default.png', // Supposé être un placeholder
                  createdAt: annonce.createdAt ?? 'N/A',
                ),
              );
            },
          ),
        ),
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
      case 4:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  ProfilPage()), // permet d'aller vers la page sans conserver les routes
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
                  backgroundImage: AssetImage('images/LOGO.png'),
                ),
                SizedBox(
                    height:
                        10), // Espace entre la photo de profil et le nom de l'utilisateur
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height:
                        10), // Espace entre le nom de l'utilisateur et la biographie
                Text(
                  'Mes annonces et gardiennages en cours',
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
                Tab(icon: Icon(Icons.add_alert), text: "Mes Annonces"),
                Tab(icon: Icon(Icons.list), text: "Mes Gardiennages"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMesAnnoncesGardeeList(),
                _buildMesGardiennageList(),
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
