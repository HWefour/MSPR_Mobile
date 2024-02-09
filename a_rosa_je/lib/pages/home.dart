import 'package:a_rosa_je/pages/gestion_annonces.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:a_rosa_je/util/footer.dart';
import '../util/annonce_popup_card.dart';
import '../util/annonce_tile.dart';
import '../api/api_service.dart';
import '../util/annonce.dart';
import 'create_annonce.dart';
import 'profil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  LocationData? _currentLocation;
  bool _isSearchMode = false;
  Key _mapKey = ValueKey("InitialKey");
  TextEditingController searchController = TextEditingController();
  Marker? _currentMarker;
  bool _hasAnnonces = true;
  List<Annonce> _currentAnnonces = []; //pour stocker les annonces de la map
  List<String> cities = []; // Pour stocker les villes en fonction du nom de la ville
   String selectedCity = ''; // Pour stocker la ville sélectionnée
  int _selectedIndex = 0;
  final ApiAnnoncesVille apiAnnoncesVille = ApiAnnoncesVille();
  String _usersName = '';
  String _city = '';

  
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserProfile();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      searchController.clear();
    });
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
        _usersName = user['usersName'] ?? 'N/A';
        _city = user['city'] ?? 'N/A';
      });
    }
    _determinePosition();
  }

  //determine la localisation de la map à partir de la ville de l'user
  void _determinePosition() async {
    final coordinates = await searchCity(_city);
      if (coordinates != null) {
        setState(() {
          _currentLocation = LocationData.fromMap({
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
          });
          _currentMarker = Marker(
            point: coordinates,
            width: 80.0,
            height: 80.0,
            child: Icon(Icons.location_on, size: 50.0, color: Colors.red),
          );
          _isSearchMode = false;
          // Mettre à jour la clé pour forcer la reconstruction de la carte
          _mapKey = ValueKey("${coordinates.latitude}_${coordinates.longitude}");
          _hasAnnonces = true;
        });
      } else {
        setState(() {
          _hasAnnonces = false; // Aucune annonce trouvée
        });
      }


  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // L'application est ramenée au premier plan (ou l'utilisateur revient à cette page)
      // Insérez ici votre logique de rafraîchissement
      _refreshData();
    }
  }

  void _refreshData() {
    // Exemple : Recharger les annonces
    apiAnnoncesVille.fetchAnnoncesVille(searchController.text).then((annonces) {
      setState(() {
        _currentAnnonces = annonces;
        // Ajoutez toute autre logique de mise à jour de l'état ici si nécessaire
      });
    }).catchError((error) {
      // Gérez les erreurs ici si nécessaire
      print("Erreur lors du chargement des annonces: $error");
    });
    setState(() {
      // Ici, vous pouvez appeler vos méthodes pour recharger les données
    });
  }

  void _showPopup(Annonce annonce) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnnoncePopupCard(annonce: annonce);
      },
    );
  }

  //api pour chercher une ville
  Future<void> fetchCities(String cityName) async {
    final response = await http.get(
        Uri.parse('https://geo.api.gouv.fr/communes?nom=$cityName&fields=departement&boost=population&limit=5'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<String> cityNames = [];
      for (var cityData in jsonData) {
        cityNames.add(cityData['nom']);
      }
      setState(() {
        cities = cityNames;
      });
    } else {
      // La requête a échoué, traitez les erreurs ici.
      throw Exception('Échec de la récupération des données');
    }
  }


  Widget _buildAnnoncesList() {
  return Column(
    children: [
      if (_isSearchMode) 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Rechercher...",
              hintText: "Entrez une ville",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            onChanged: (cityName) {
              if (cityName.isNotEmpty) {
                fetchCities(cityName);
              }
            },
          ),
        ),
      SizedBox(height: 8.0),
      if (cities.isNotEmpty) ...[ // Ajout de ... pour étendre la liste de widgets
        Container(
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                    title: Text(cities[index]),
                    onTap: () async {
                      setState(() {
                        selectedCity = cities[index];
                        searchController.text = selectedCity;
                        cities.clear();
                      });
                      final coordinates = await searchCity(searchController.text);
                      if (coordinates != null) {
                        setState(() {
                          _currentLocation = LocationData.fromMap({
                            "latitude": coordinates.latitude,
                            "longitude": coordinates.longitude,
                          });
                          _currentMarker = Marker(
                            point: coordinates,
                            width: 80.0,
                            height: 80.0,
                            child: Icon(Icons.location_on, size: 50.0, color: Colors.red),
                          );
                          _isSearchMode = false;
                          // Mettre à jour la clé pour forcer la reconstruction de la carte
                          _mapKey = ValueKey("${coordinates.latitude}_${coordinates.longitude}");
                          _hasAnnonces = true;
                        });
                      } else {
                        setState(() {
                          _hasAnnonces = false; // Aucune annonce trouvée
                        });
                      }
                    },
                  );
            },
          ),
        ),
      ],
      if (!_hasAnnonces)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Pas d'annonces dans cette ville",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.red,
            ),
          ),
        ),
      if (!_hasAnnonces) // Ajout d'un espace uniquement si _hasAnnonces est false
        SizedBox(height: 10.0),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Filtrer les annonces",
              style: TextStyle(fontSize: 16.0),
            ),
            IconButton(
              icon: Icon(_isSearchMode ? Icons.close : Icons.search),
              onPressed: () {
                _hasAnnonces = true;
                searchController.clear();
                setState(() {
                  _isSearchMode = !_isSearchMode;
                  
                });
              },
            ),
          ],
        ),
      ),
      Expanded(
        child: _showAnnonceList(context),
      ),
    ],
  );  
}



  //gestion de la localisation pour la map
  Future<LatLng?> searchCity(String city) async {
    try {
      // Tentative de récupérer les annonces pour la ville spécifiée
      List<Annonce> annonces = await apiAnnoncesVille.fetchAnnoncesVille(city);
      if (annonces.isNotEmpty) {

      // Si des annonces existent pour la ville, stockez-les dans l'état du widget
      setState(() {
        _currentAnnonces = annonces;
      });

        // Si des annonces existent pour la ville, procéder à la recherche de la localisation
        final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$city&format=json');
        final response = await http.get(url, headers: {
          'User-Agent': 'a_rosa_je',
        });

        if (response.statusCode == 200) {
          final results = json.decode(response.body);
          if (results.isNotEmpty) {
            final lat = double.parse(results[0]["lat"]);
            final lon = double.parse(results[0]["lon"]);
            return LatLng(lat, lon);
          }
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des annonces ou de la localisation : $e");
    }
    return null; // Renvoie null si aucune annonce n'est trouvée ou en cas d'erreur
  }

  Widget _showAnnonceList(BuildContext context) {
  // Utilisez un Container, ListView.builder, ou tout autre widget approprié ici
    return ListView.builder(
      itemCount: _currentAnnonces.length,
      itemBuilder: (context, index) {
        Annonce annonce = _currentAnnonces[index];
        return GestureDetector(
          onTap: () => _showPopup(annonce),
          child: AnnonceTile(
            idAdvertisement: annonce.idAdvertisement ?? '0',
            title: annonce.title ?? 'N/A',
            city: annonce.city ?? 'N/A',
            idPlant: '', // Assurez-vous d'avoir la bonne propriété ici
            name: annonce.name ?? 'N/A',
            userName: '', // Assurez-vous d'avoir la bonne valeur ici
            description: annonce.description ?? 'N/A',
            startDate: annonce.startDate ?? 'N/A',
            endDate: annonce.endDate ?? 'N/A',
            imageUrl: 'images/plant_default.png', // Idéalement, utilisez l'URL de l'image de l'annonce
            createdAt: '', // Assurez-vous d'avoir la bonne valeur ici
          ),
        );
      },
    );
  }

  void _showAnnoncesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _currentAnnonces.length, // Utilisez _currentAnnonces au lieu de snapshot.data!
            itemBuilder: (context, index) {
              Annonce annonce = _currentAnnonces[index]; // Utilisez _currentAnnonces au lieu de snapshot.data!
              return GestureDetector(
                onTap: () => _showPopup(annonce), // Afficher le modal d'annonce lorsque l'élément est tapé
                child: AnnonceTile(
                  idAdvertisement: annonce.idAdvertisement ?? '0',
                  title: annonce.title ?? 'N/A',
                  city: annonce.city ?? 'N/A', 
                  idPlant:'', 
                  name: annonce.name ?? 'N/A',
                  userName: '',
                  description: annonce.description ?? 'N/A',
                  startDate: annonce.startDate ?? 'N/A',
                  endDate: annonce.endDate ?? 'N/A',
                  imageUrl: 'images/plant_default.png', // Remplacez par l'URL de l'image si disponible
                  createdAt: '',
                ),
              );
            },
          ),
        );
      },
    );
  }

  //gestion de la carte
  Widget _buildMap() {
    return Column(
      children: [
        if (_isSearchMode)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                labelText: "Rechercher...",
                hintText: "Entrez une ville",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: (cityName) async {
                if (cityName.isNotEmpty) {
                  fetchCities(cityName);
                }
              },
            ),
          ),
          SizedBox(height: 8.0),
          if (cities.isNotEmpty) ...[ // Ajout de ... pour étendre la liste de widgets
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(cities[index]),
                    onTap: () async {
                      setState(() {
                        selectedCity = cities[index];
                        searchController.text = selectedCity;
                        cities.clear();
                      });
                      final coordinates = await searchCity(searchController.text);
                      if (coordinates != null) {
                        setState(() {
                          _currentLocation = LocationData.fromMap({
                            "latitude": coordinates.latitude,
                            "longitude": coordinates.longitude,
                          });
                          _currentMarker = Marker(
                            point: coordinates,
                            width: 80.0,
                            height: 80.0,
                            child: Icon(Icons.location_on, size: 50.0, color: Colors.red),
                          );
                          _isSearchMode = false;
                          // Mettre à jour la clé pour forcer la reconstruction de la carte
                          _mapKey = ValueKey("${coordinates.latitude}_${coordinates.longitude}");
                          _hasAnnonces = true;
                        });
                      } else {
                        setState(() {
                          _hasAnnonces = false; // Aucune annonce trouvée
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        if (!_hasAnnonces)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Pas d'annonces dans cette ville",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.red,
            ),
          ),
        ),
      if (!_hasAnnonces) // Ajout d'un espace uniquement si _hasAnnonces est false
        SizedBox(height: 10.0),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Filtrer les annonces",
              style: TextStyle(fontSize: 16.0),
            ),
            IconButton(
              icon: Icon(_isSearchMode ? Icons.close : Icons.search),
              onPressed: () {
                _hasAnnonces = true;
                searchController.clear();
                setState(() {
                  _isSearchMode = !_isSearchMode;
                  
                });
              },
            ),
          ],
        ),
      ),
    Expanded (
        child: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              FlutterMap(
                key: _mapKey,
                options: MapOptions(
                  initialCenter: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                  initialZoom: 13.0,
                  onTap: (tapPosition, point) {
                    if (_currentMarker != null) {
                        // Gérer l'appui sur la carte uniquement si _currentMarker est présent
                        _showAnnoncesModal(context);
                      }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.a_rosa_je.app',
                  ),
                  if (_currentMarker != null) MarkerLayer(
                    markers: [_currentMarker!],
                  ),
                  // Ajouter d'autres couches si nécessaire
                ],
              ),
              // Positioned(
              //   right: 20.0,
              //   bottom: 20.0,
              //   child: FloatingActionButton(
              //     onPressed: () async {
              //       _determinePosition();
              //       // Attendre la mise à jour de la position
              //       if (_currentLocation != null) {
              //         setState(() {
              //           // Déplacer la vue de la carte vers la nouvelle position
              //           _mapController.move(
              //             LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
              //             13.0
              //           );
              //         });
              //       }
              //     },
              //     child: Icon(Icons.my_location),
              //     tooltip: 'Reset to Current Location',
              //   )
              // ),
            ],
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
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  GestionAnnoncesPage()), // permet d'aller vers la page sans conserver les routes
          (Route<dynamic> route) => false,
        );
        break;
      case 4: 
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ProfilPage()), // permet d'aller vers la page sans conserver les routes
          (Route<dynamic> route) => false,
        );
        break;
      default:
        break;
    }
  }

  //build affichage 
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
                  radius: 50, // Rayon du cercle pour le logo
                  backgroundImage: AssetImage('images/LOGO.png'), // Remplacez par le chemin de votre photo de profil
                ),
                SizedBox(height: 10), // Espace entre la photo de profil et le nom de l'utilisateur
                Text(
                  'Bonjour $_usersName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10), // Espace entre le nom de l'utilisateur et la biographie
                Text(
                  'Trouver une plante à garder :',
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
                Tab(icon: Icon(Icons.list), text: "Annonces"),
                Tab(icon: Icon(Icons.map), text: "Carte"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnnoncesList(),
                _buildMap(),
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
  //fin app
}
