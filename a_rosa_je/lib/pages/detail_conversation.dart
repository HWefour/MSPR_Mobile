import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationScreen extends StatefulWidget {
  final String name;

  const ConversationScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMessages = prefs.getString('messages_${widget.name}');
    if (storedMessages != null) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(json.decode(storedMessages));
      });
    } else {
      setState(() {
        _messages = allConversations[widget.name] ?? [];
      });
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('messages_${widget.name}', json.encode(_messages));
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'isMe': true,
        'text': text,
        'time': 'Now',
        'image': null,
      });
      _controller.clear();
      _saveMessages();
    });
  }

  void _sendImage(XFile image) {
    setState(() {
      _messages.add({
        'isMe': true,
        'text': '',
        'time': 'Now',
        'image': image.path,
      });
      _saveMessages();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _sendImage(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
                  isMe: message['isMe'],
                  text: message['text'],
                  time: message['time'],
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

// Exemple de données pour toutes les conversations
final Map<String, List<Map<String, dynamic>>> allConversations = {
  'Alex34': [
    {
      'isMe': true,
      'text': 'Salut Alex, comment ça va?',
      'time': '09:00',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Salut! Ça va bien, merci. Et toi?',
      'time': '09:05',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Ça va aussi. Tu seras disponible ce week-end pour aller courir?',
      'time': '09:10',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Oui, ça me va! Samedi matin?',
      'time': '09:15',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Parfait, à samedi alors!',
      'time': '09:20',
      'image': null,
    },
  ],
  'Lucas10': [
    {
      'isMe': true,
      'text': 'Salut Lucas, as-tu des nouvelles de notre projet?',
      'time': '14:00',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Salut, oui j’ai eu des nouvelles. On a le feu vert!',
      'time': '14:05',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Génial! On commence quand?',
      'time': '14:10',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'On peut commencer dès lundi prochain.',
      'time': '14:15',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Parfait, je prépare tout pour lundi.',
      'time': '14:20',
      'image': null,
    },
  ],
  'Haitam83': [
    {
      'isMe': true,
      'text': 'Hey Haitam, tu viens à la fête demain?',
      'time': '18:00',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Salut! Oui, je serai là!',
      'time': '18:05',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Super! Hâte de te voir.',
      'time': '18:10',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Moi aussi, à demain!',
      'time': '18:15',
      'image': null,
    },
  ],
  'Marine06': [
    {
      'isMe': true,
      'text': 'Salut Marine, as-tu terminé le rapport?',
      'time': '11:00',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Salut, oui je l’ai terminé hier soir.',
      'time': '11:05',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Super, je vais le relire cet après-midi.',
      'time': '11:10',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Merci! N’hésite pas à me faire des retours.',
      'time': '11:15',
      'image': null,
    },
  ],
};
