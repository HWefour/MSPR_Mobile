import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool hasNewNotifications; // Ajout de cette variable pour indiquer s'il y a des notifications

  Footer({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.hasNewNotifications, // Valeur par défaut
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
          icon: Stack(
            children: [
              Icon(Icons.announcement),
              if (hasNewNotifications)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: 'gestion des \nAnnonces',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add),
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
