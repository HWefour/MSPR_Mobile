import 'package:flutter/material.dart';
import 'detail_conversation.dart';

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

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  List<Map<String, String>> messages = [
    {
      'name': 'Alex34',
      'message': 'Vous: Oh super! Je désespérais de...',
      'time': '12:55'
    },
    {
      'name': 'Lucas10',
      'message': 'Merci beaucoup d\'avoir gardé mes pla...',
      'time': '02/01/2024'
    },    {
      'name': 'Haitam83',
      'message': 'Vous: Oh super! Je désespérais de...',
      'time': '12/06/2024'
    },
    {
      'name': 'Marine06',
      'message': 'Merci beaucoup d\'avoir gardé mes pla...',
      'time': '05/09/2023'
    },
  ];

  List<Map<String, String>> filteredMessages = [];

  @override
  void initState() {
    super.initState();
    filteredMessages = messages;
  }

  void _filterMessages(String query) {
    final filtered = messages
        .where((message) => message['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredMessages = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SearchBar(onTextChanged: _filterMessages),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                return MessageTile(
                  name: message['name']!,
                  message: message['message']!,
                  time: message['time']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onTextChanged;

  const SearchBar({Key? key, required this.onTextChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onTextChanged,
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(name: name),
          ),
        );
      },
    );
  }
}
