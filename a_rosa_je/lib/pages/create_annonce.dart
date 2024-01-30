import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CreateAnnonce extends StatefulWidget {
  @override
  _CreateAnnonceState createState() => _CreateAnnonceState();
}

class _CreateAnnonceState extends State<CreateAnnonce> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 7));
  final _formKey = GlobalKey<FormState>();
  String city = '';
  String description = '';
  int numberOfPlants = 0;
  List<XFile>? imageFiles = [];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? selectedStartDate : selectedEndDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030, 12),
    );
    if (picked != null && picked != (isStart ? selectedStartDate : selectedEndDate))
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
  }

  Future<void> _openImagePicker(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Prendre une photo'),
                  onTap: () {
                    _takePhotoWithCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choisir depuis la galerie'),
                    onTap: () {
                      _pickImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                
              ],
            ),
          );
        }
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFiles?.add(selectedImage);
      });
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFiles?.add(photo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poster une annonce'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // Add space between form fields
                //ajouter titre Poster une annonce
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    border: OutlineInputBorder(), // Adds a border around the text field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de ville';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    city = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the date pickers evenly
                  children: [
                    Expanded( // Use Expanded to ensure buttons don't overflow
                      child: TextButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text('Du: ${DateFormat('dd/MM/yyyy').format(selectedStartDate)}'),
                      ),
                    ),
                    SizedBox(width: 8), // Add space between buttons
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text('Au: ${DateFormat('dd/MM/yyyy').format(selectedEndDate)}'),
                      ),
                    ),
                  ],
                ),
              ),
              // Plus de champs pour le nombre de plantes, etc...
              // Description TextFormField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true, // Aligns the label with the hint text
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5, // Set to your preference
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    description = value!;
                  },
                ),
              ),

              // Buttons for adding photos
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ajouter des photos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text('Prendre une photo'),
                        onPressed: () => _takePhotoWithCamera(),
                      ),
                    ),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.image, color: Colors.black),
                        label: Text('Joindre une image'),
                        onPressed: () => _pickImageFromGallery(),
                      ),
                    ),
                  ],
                ),
              ),
            // Image preview section
              SizedBox(height: 16), // Add space before displaying images
              imageFiles!.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                      itemCount: imageFiles!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4, // Spacing between images horizontally
                        mainAxisSpacing: 4, // Spacing between images vertically
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(imageFiles![index].path),
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Center(child: Text('Pas d\'images sélectionnées.')), // Center the text when no images are selected
              SizedBox(height: 16), // Add space before the submit button

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle the form submission logic here
                    }
                  },
                  child: Text('Poster votre annonce'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
