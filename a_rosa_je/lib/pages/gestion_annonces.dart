import 'package:a_rosa_je/pages/profil.dart';
import 'package:a_rosa_je/util/mes_annonce_tile_job.dart';
import 'package:a_rosa_je/util/mes_gardiennage_tile_job.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:a_rosa_je/util/footer.dart';
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
  final ApiAnnoncesIdAdvertisement apiAnnoncesIdAdvertisement = ApiAnnoncesIdAdvertisement();
  int _idUserLocal = 0;

  List<Map<String, dynamic>> listMesAnnoncesJobs = [];
  List<Map<String, dynamic>> listMesGardiennagesJobs = [];

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
    final response = await http.get(Uri.parse('http://localhost:1212/job/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, dynamic>> jobsMesAnnoncesData = [];
      for (var jobMesAnnoncesData in jsonData) {
        // Assurez-vous que jobData['idUser'] est traité comme une chaîne
        if ((jobMesAnnoncesData['idUser'] ?? '').toString() == _idUserLocal.toString()) {
          jobsMesAnnoncesData.add({
            'idUser': jobMesAnnoncesData['idUser'].toString(),
            'idAdvertisement': jobMesAnnoncesData['idAdvertisement'].toString(),
            'idUserGardien': jobMesAnnoncesData['idUserGardien'].toString(),
          });
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
    final response = await http.get(Uri.parse('http://localhost:1212/job/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, dynamic>> jobsMesGardiennagesData = [];
      for (var jobMesGardiennagesData in jsonData) {
        if ((jobMesGardiennagesData['idUserGardien'] ?? '').toString() == _idUserLocal.toString()) {
          jobsMesGardiennagesData.add({
            'idUser': jobMesGardiennagesData['idUser'].toString(),
            'idAdvertisement': jobMesGardiennagesData['idAdvertisement'].toString(),
            'idUserGardien': jobMesGardiennagesData['idUserGardien'].toString(),
          });
        }
      }
      setState(() {
        listMesGardiennagesJobs = jobsMesGardiennagesData;
      });
    } else {
      throw Exception('Failed to load jobs');
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
            itemCount: listMesAnnoncesJobs.length,
            itemBuilder: (context, index) {
              var jobMesAnnonces = listMesAnnoncesJobs[index];
              return FutureBuilder<List<Annonce>>(
                future: apiAnnoncesIdAdvertisement.fetchAnnoncesIdAdvertisement(jobMesAnnonces['idAdvertisement']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map<Widget>((annonce) {
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
                            imageUrl: 'images/plant_default.png', // Supposé être un placeholder
                            createdAt: annonce.createdAt ?? 'N/A',
                            userNameGardien: jobMesAnnonces['idUserGardien'],
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Text("No data available for job ID: ${jobMesAnnonces['idAdvertisement']}");
                  }
                },
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
            itemCount: listMesGardiennagesJobs.length,
            itemBuilder: (context, index) {
              var jobMesGardiennages = listMesGardiennagesJobs[index];
              return FutureBuilder<List<Annonce>>(
                future: apiAnnoncesIdAdvertisement.fetchAnnoncesIdAdvertisement(jobMesGardiennages['idAdvertisement']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map<Widget>((annonce) {
                        return GestureDetector(
                          onTap: () => _showPopup(annonce),
                          child: MesGardiennageTileJob(
                            idAdvertisement: annonce.idAdvertisement ?? '0',
                            title: annonce.title ?? 'N/A',
                            city: annonce.city ?? 'N/A',
                            idPlant: annonce.name ?? 'N/A', // Vérifiez ce champ, idPlant ou name?
                            name: annonce.name ?? 'N/A',
                            userName: annonce.usersName ?? 'N/A',
                            description: annonce.description ?? 'N/A',
                            startDate: annonce.startDate ?? 'N/A',
                            endDate: annonce.endDate ?? 'N/A',
                            imageUrl: 'images/plant_default.png', // Supposé être un placeholder
                            createdAt: annonce.createdAt ?? 'N/A',
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Text("No data available for job ID: ${jobMesGardiennages['idAdvertisement']}");
                  }
                },
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
                  backgroundImage: AssetImage(
                      'images/LOGO.png'), 
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
                  'Mes annonces et gardiennage en cours',
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
