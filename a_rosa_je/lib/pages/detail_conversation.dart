import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart' if (dart.library.io) 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ConversationScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const ConversationScreen({
    Key? key,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();
  late final WebSocketChannel _channel;
  String otherUsername = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadMessages();
    if (kIsWeb) {
      _channel = HtmlWebSocketChannel.connect('ws://localhost:1212');
    } else {
      _channel = IOWebSocketChannel.connect('ws://localhost:1212');
    }

    // Écouter les messages reçus du serveur
    _channel.stream.listen((message) {
      setState(() {
        _messages.add({
          'isMe': false,
          'text': message,
          'time': DateTime.now().toString(),
          'image': null,
        });
      });
    });
  }

  Future<void> _loadUsername() async {
    final response = await http.get(Uri.parse('http://localhost:1212/api/get-username/${widget.otherUserId}'));
    if (response.statusCode == 200) {
      setState(() {
        otherUsername = json.decode(response.body)['username'];
      });
    } else {
      throw Exception('Failed to load username');
    }
  }

  Future<void> _loadMessages() async {
    final response = await http.get(Uri.parse('http://localhost:1212/api/get-messages/${widget.currentUserId}/${widget.otherUserId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['messages'];
      setState(() {
        _messages = data.map((message) => {
          'isMe': message['idUser'].toString() == widget.currentUserId,
          'text': message['content'],
          'time': message['dates'],
          'image': null,
        }).toList();
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> _saveMessage(String text) async {
    final response = await http.post(
      Uri.parse('http://localhost:1212/api/add-message'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idUser': widget.currentUserId,
        'idUser_1': widget.otherUserId,
        'idAdvertisement': null, // Ajouter l'ID de l'annonce si applicable
        'content': text,
        'dates': DateTime.now().toIso8601String(), // Inclure la date et l'heure pour le message
      }),
    );

    if (response.statusCode == 200) {
      _loadMessages(); // Rafraîchir les messages après en avoir enregistré un nouveau
    } else {
      throw Exception('Failed to save message');
    }
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'isMe': true,
        'text': text,
        'time': DateTime.now().toString(),
        'image': null,
      });
      _channel.sink.add(text);
      _controller.clear();
      _saveMessage(text);
    });
  }

  void _sendImage(XFile image) {
    setState(() {
      _messages.add({
        'isMe': true,
        'text': '',
        'time': DateTime.now().toString(),
        'image': image.path,
      });
      _saveMessage(''); 
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _sendImage(pickedFile);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec $otherUsername'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  isMe: message['isMe'] ?? false,
                  text: message['text'] ?? '',
                  time: message['time'] ?? '',
                  image: message['image'] != null ? XFile(message['image']) : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Envoyer un message...',
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;
  final XFile? image;

  const MessageBubble({
    Key? key,
    required this.isMe,
    required this.text,
    required this.time,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (image != null)
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: kIsWeb
                    ? Image.network(image!.path)  // Pour Flutter Web
                    : Image.file(File(image!.path)),  // Pour les autres plateformes
              ),
            if (text.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.green[300] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
