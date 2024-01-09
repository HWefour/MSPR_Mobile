import 'package:flutter/material.dart';
import 'package:a_rosa_je/util/footer.dart';
import '../util/annonce_tile.dart';
import '../api/api_service.dart';
import '../util/annonce.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ApiService apiService = ApiService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Annonce>>(
        future: apiService.fetchAnnonces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Annonce annonce = snapshot.data![index];
                return AnnonceTile(
                  titre: annonce.titreAnnonce,
                  localisation: annonce.statutAnnonce, // Assurez-vous que c'est le champ correct pour 'localisation'
                  nbPlantes:'', // Vous devrez peut-être ajuster cela selon vos données
                  description: annonce.texteAnnonce,
                  imageUrl: 'images/plant_default.png', // Remplacez par l'URL de l'image si disponible
                  dateDebut: annonce.dateDebutGardeAnnonce,
                  dateFin: annonce.dateFinGardeAnnonce,
                );
              },
            );
          } else {
            return Text("No data");
          }
        },
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic for posting an ad
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF1B5E20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
