import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': true,
      'text': 'Salut, pourrais-tu garder mon cactus pendant mon absence?',
      'time': '10:00',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Bien sûr! Aucun problème.',
      'time': '10:05',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Merci! Voici quelques conseils: arrose-le une fois par semaine et assure-toi qu\'il reçoive beaucoup de lumière.',
      'time': '10:10',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Parfait, je prendrai bien soin de lui.',
      'time': '10:15',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Super! On peut se rencontrer ce vendredi pour que je te le remette?',
      'time': '10:20',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'Vendredi ça marche pour moi. Disons 18h devant la bibliothèque?',
      'time': '10:25',
      'image': null,
    },
    {
      'isMe': true,
      'text': 'Parfait! À vendredi alors.',
      'time': '10:30',
      'image': null,
    },
    {
      'isMe': false,
      'text': 'À vendredi!',
      'time': '10:35',
      'image': null,
    },
  ];

  final ImagePicker _picker = ImagePicker();

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
    });
  }

  void _sendImage(XFile image) {
    setState(() {
      _messages.add({
        'isMe': true,
        'text': '',
        'time': 'Now',
        'image': image,
      });
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
                  image: message['image'],
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
