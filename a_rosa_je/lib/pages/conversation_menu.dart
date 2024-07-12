import 'package:flutter/material.dart';
import 'detail_conversation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

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
  String currentUserId = '';
  List<Map<String, dynamic>> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    var box = await Hive.openBox('userBox');
    var userJson = box.get('userDetails');
    if (userJson != null) {
      Map<String, dynamic> user = jsonDecode(userJson);
      setState(() {
        currentUserId = user['idUser'].toString();
      });
      _loadConversations();
    }
  }

  Future<void> _loadConversations() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.128:1212/api/get-messages/$currentUserId/8')); // Exemple avec l'utilisateur 35, à remplacer dynamiquement
      if (response.statusCode == 200) {
        List<dynamic> messages = json.decode(response.body)['messages'];
        List<Map<String, dynamic>> fetchedConversations = await _getConversations(messages);
        setState(() {
          conversations = fetchedConversations;
          isLoading = false;
        });
      } else {
        print('Failed to load messages: ${response.body}');
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('Error loading conversations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getConversations(List<dynamic> messages) async {
    Map<int, Map<String, dynamic>> lastMessages = {};
    for (var message in messages) {
      int otherUserId = message['idUser'] == int.parse(currentUserId) ? message['idUser_1'] : message['idUser'];
      String otherUsername = await _getUsername(otherUserId.toString());
      lastMessages[otherUserId] = {
        'userId': otherUserId.toString(),
        'username': otherUsername,
        'lastMessage': message['content'],
        'time': message['dates'],
      };
    }
    return lastMessages.values.toList();
  }

  Future<String> _getUsername(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.43.128:1212/api/get-username/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['username'];
    } else {
      throw Exception('Failed to get username');
    }
  }

  void _filterMessages(String query) {
    final filtered = conversations
        .where((conversation) =>
            conversation['username']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      conversations = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SearchBar(onTextChanged: _filterMessages),
                Expanded(
                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      return MessageTile(
                        userId: conversation['userId']!,
                        username: conversation['username']!,
                        message: conversation['lastMessage']!,
                        time: conversation['time']!,
                        currentUserId: currentUserId,
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
  final String userId;
  final String username;
  final String message;
  final String time;
  final String currentUserId;

  const MessageTile({
    Key? key,
    required this.userId,
    required this.username,
    required this.message,
    required this.time,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(username),
      subtitle: Text(message),
      trailing: Text(time),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              currentUserId: currentUserId,
              otherUserId: userId,
            ),
          ),
        );
      },
    );
  }
}
