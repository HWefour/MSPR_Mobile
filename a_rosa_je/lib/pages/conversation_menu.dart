import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessagingScreen(),
    );
  }
}

class MessagingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          SearchBar(),
          MessageTile(
            name: 'MonsteraLover',
            message: 'Vous: Oh super! Je désespérais de...',
            time: '12:55',
          ),
          MessageTile(
            name: 'PlantyDaddy89',
            message: 'Merci beaucoup d\'avoir gardé mes pla...',
            time: '02/01',
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher une discussion',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(0),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;

  const MessageTile({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time),
    );
  }
}
