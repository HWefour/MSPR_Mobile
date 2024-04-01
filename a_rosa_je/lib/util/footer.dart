// footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  Footer({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF1B5E20),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.announcement),
          label: 'gestion des \nAnnonces',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add), // Icône placeholder invisible
          label: 'Placer une \nannonce',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Tchat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
