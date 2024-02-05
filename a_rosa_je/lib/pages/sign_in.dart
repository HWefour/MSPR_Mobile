// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RegistrationScreen(),
//     );
//   }
// }

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _uservilleController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isChecked = false; // Pour gérer l'état de la case à cocher

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1B5E20),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             Image(image: AssetImage('images/LOGO.png')),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _nameController,
//               hintText: 'Nom',
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Veuillez entrer votre nom';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _firstNameController,
//               hintText: 'Prénom',
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Veuillez entrer votre prénom';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _usernameController,
//               hintText: 'Pseudonyme',
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Veuillez entrer votre pseudonyme';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _uservilleController,
//               hintText: 'Ville',
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Veuillez entrer votre ville';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _emailController,
//               hintText: 'Email',
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Veuillez entrer votre email';
//                 }
//                 if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
//                     .hasMatch(value)) {
//                   return 'Adresse email invalide';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _passwordController,
//               hintText: 'Mot de passe',
//               obscureText: true,
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Veuillez entrer votre mot de passe';
//                 }
//                 if (value.length < 8) {
//                   return 'Le mot de passe doit contenir au moins 8 caractères';
//                 }
//                 if (!value.contains(RegExp(r'[A-Z]'))) {
//                   return 'Le mot de passe doit contenir au moins une majuscule';
//                 }
//                 if (!value.contains(RegExp(r'[0-9]'))) {
//                   return 'Le mot de passe doit contenir au moins un chiffre';
//                 }
//                 if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
//                   return 'Le mot de passe doit contenir au moins un caractère spécial';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24.0),
//             TextFieldWidget(
//               controller: _confirmPasswordController,
//               hintText: 'Vérification du mot de passe',
//               obscureText: true,
//               validator: (value) {
//                 if (value != _passwordController.text) {
//                   return 'Les mots de passe ne correspondent pas';
//                 }
//                 return null;
//               },
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isChecked =
//                       !isChecked; // Inversez l'état de la case à cocher lors du clic
//                 });
//               },
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           Colors.white, // Couleur de la case à cocher blanche
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: isChecked
//                           ? Icon(
//                               Icons.check,
//                               size: 16.0,
//                               color: Color(0xFF1B5E20), // Couleur de la coche verte
//                             )
//                           : Container(
//                               width: 16.0,
//                               height: 16.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.black, // Couleur de la bordure de la case à cocher
//                                   width: 2.0,
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                   SizedBox(
//                       width:
//                           8), // Espacement entre la case à cocher et le texte (facultatif)
//                   Expanded(
//                     child: Text(
//                       'J\'accepte les conditions générales et la politique de confidentialité',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.0),
//             ElevatedButtonWidget(
//               buttonText: 'Inscription',
//               buttonColor: Colors.brown,
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   // Gérer la soumission du formulaire ici
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TextFieldWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final bool obscureText;
//   final FormFieldValidator<String>? validator;

//   const TextFieldWidget({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.obscureText = false,
//     this.validator,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       obscureText: obscureText,
//       validator: validator,
//     );
//   }
// }

// class ElevatedButtonWidget extends StatelessWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final VoidCallback onPressed;

//   const ElevatedButtonWidget({
//     Key? key,
//     required this.buttonText,
//     required this.buttonColor,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         primary: buttonColor,
//         onPrimary: Colors.white,
//         shape: StadiumBorder(),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(buttonText),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RegistrationScreen(),
//     );
//   }
// }

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   String selectedCity = ''; // Pour stocker la ville sélectionnée dans le menu déroulant
//   List<String> cities = []; // Pour stocker les villes en fonction du code postal

//   final TextEditingController _postalCodeController = TextEditingController();

//   Future<void> fetchCities(String postalCode) async {
//     final response = await http.get(
//         Uri.parse('https://geo.api.gouv.fr/communes?codePostal=$postalCode'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       List<String> cityNames = [];
//       for (var cityData in jsonData) {
//         cityNames.add(cityData['nom']);
//       }
//       setState(() {
//         cities = cityNames;
//       });
//     } else {
//       // La requête a échoué, traitez les erreurs ici.
//       throw Exception('Échec de la récupération des données');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1B5E20),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: <Widget>[
//           Image(image: AssetImage('images/LOGO.png')),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Nom',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Prénom',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Pseudonyme',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             controller: _postalCodeController,
//             hintText: 'Code Postal',
//             onChanged: (postalCode) {
//               if (postalCode.length == 5) {
//                 fetchCities(postalCode);
//               }
//             },
//           ),
//           SizedBox(height: 24.0),
//           DropdownButton<String>(
//             value: selectedCity,
//             items: cities.map((String city) {
//               return DropdownMenuItem<String>(
//                 value: city,
//                 child: Text(city),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 selectedCity = newValue ?? '';
//               });
//             },
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Email',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Mot de passe',
//             obscureText: true,
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Vérification du mot de passe',
//             obscureText: true,
//           ),
//           SizedBox(height: 24.0),
//           Row(
//             children: [
//               // Checkbox(
//               //   value: isChecked,
//               //   onChanged: (bool? value) {
//               //     setState(() {
//               //       isChecked = value ?? false;
//               //     });
//               //   },
//               // ),
//               SizedBox(width: 8.0),
//               Expanded(
//                 child: Text(
//                   'J\'accepte les conditions générales et la politique de confidentialité',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24.0),
//           ElevatedButtonWidget(
//             buttonText: 'Inscription',
//             buttonColor: Colors.brown,
//             onPressed: () {
//               // Gérer la soumission du formulaire ici
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TextFieldWidget extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;

//   const TextFieldWidget({
//     Key? key,
//     required this.hintText,
//     this.obscureText = false,
//     this.controller,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       obscureText: obscureText,
//     );
//   }
// }

// class ElevatedButtonWidget extends StatelessWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final VoidCallback onPressed;

//   const ElevatedButtonWidget({
//     Key? key,
//     required this.buttonText,
//     required this.buttonColor,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         primary: buttonColor,
//         onPrimary: Colors.white,
//         shape: StadiumBorder(),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(buttonText),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RegistrationScreen(),
//     );
//   }
// }

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   String selectedCity = ''; // Pour stocker la ville sélectionnée
//   List<String> cities = []; // Pour stocker les villes en fonction du nom de la ville

//   final TextEditingController _cityController = TextEditingController();

//   Future<void> fetchCities(String cityName) async {
//     final response = await http.get(
//         Uri.parse('https://geo.api.gouv.fr/communes?nom=$cityName&fields=departement&boost=population&limit=5'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       List<String> cityNames = [];
//       for (var cityData in jsonData) {
//         cityNames.add(cityData['nom']);
//       }
//       setState(() {
//         cities = cityNames;
//       });
//     } else {
//       // La requête a échoué, traitez les erreurs ici.
//       throw Exception('Échec de la récupération des données');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1B5E20),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: <Widget>[
//           Image(image: AssetImage('images/LOGO.png')),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Nom',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Prénom',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Pseudonyme',
//           ),
//           SizedBox(height: 24.0),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Ville',
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(height: 8.0),
//               TextField(
//                 controller: _cityController,
//                 onChanged: (cityName) {
//                   if (cityName.isNotEmpty) {
//                     fetchCities(cityName);
//                   }
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               if (cities.isNotEmpty)
//                 Container(
//                   height: 100.0,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ListView.builder(
//                     itemCount: cities.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         title: Text(cities[index]),
//                         onTap: () {
//                           setState(() {
//                             selectedCity = cities[index];
//                             _cityController.text = selectedCity;
//                             cities.clear();
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Email',
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Mot de passe',
//             obscureText: true,
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Vérification du mot de passe',
//             obscureText: true,
//           ),
//           SizedBox(height: 24.0),
//           Row(
//             children: [
//               // Checkbox(
//               //   value: isChecked,
//               //   onChanged: (bool? value) {
//               //     setState(() {
//               //       isChecked = value ?? false;
//               //     });
//               //   },
//               // ),
//               SizedBox(width: 8.0),
//               Expanded(
//                 child: Text(
//                   'J\'accepte les conditions générales et la politique de confidentialité',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24.0),
//           ElevatedButtonWidget(
//             buttonText: 'Inscription',
//             buttonColor: Colors.brown,
//             onPressed: () {
//               // Gérer la soumission du formulaire ici
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TextFieldWidget extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;

//   const TextFieldWidget({
//     Key? key,
//     required this.hintText,
//     this.obscureText = false,
//     this.controller,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       obscureText: obscureText,
//     );
//   }
// }

// class ElevatedButtonWidget extends StatelessWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final VoidCallback onPressed;

//   const ElevatedButtonWidget({
//     Key? key,
//     required this.buttonText,
//     required this.buttonColor,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         primary: buttonColor,
//         onPrimary: Colors.white,
//         shape: StadiumBorder(),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(buttonText),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RegistrationScreen(),
//     );
//   }
// }

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   String selectedCity = '';
//   List<String> cities = [];
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> createUser() async {
//     final url = Uri.parse('http://localhost:1212/auth/signup');
//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode({
//         "firstName": _firstNameController.text,
//         "lastName": _lastNameController.text,
//         "usersName": _userNameController.text,
//         "email": _emailController.text,
//         "city": selectedCity,
//         "bio": "bio", // Vous pouvez modifier cela si nécessaire
//         "password": _passwordController.text,
//         "idRole": "2" // Vous pouvez modifier cela si nécessaire
//       }),
//     );

//     if (response.statusCode == 201) {
//       // L'utilisateur a été créé avec succès.
//       // Vous pouvez afficher un message de succès ou effectuer d'autres actions ici.
//     } else {
//       // La création de l'utilisateur a échoué.
//       // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
//       throw Exception('Échec de la création de l\'utilisateur');
//     }
//   }

//   Future<void> fetchCities(String cityName) async {
//     final response = await http.get(
//         Uri.parse(
//             'https://geo.api.gouv.fr/communes?nom=$cityName&fields=departement&boost=population&limit=5'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       List<String> cityNames = [];
//       for (var cityData in jsonData) {
//         cityNames.add(cityData['nom']);
//       }
//       setState(() {
//         cities = cityNames;
//       });
//     } else {
//       throw Exception('Échec de la récupération des données');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1B5E20),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: <Widget>[
//           Image(image: AssetImage('images/LOGO.png')),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Nom',
//             controller: _firstNameController,
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Prénom',
//             controller: _lastNameController,
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Pseudonyme',
//             controller: _userNameController,
//           ),
//           SizedBox(height: 24.0),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Ville',
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(height: 8.0),
//               TextField(
//                 controller: _cityController,
//                 onChanged: (cityName) {
//                   if (cityName.isNotEmpty) {
//                     fetchCities(cityName);
//                   }
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               if (cities.isNotEmpty)
//                 Container(
//                   height: 100.0,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ListView.builder(
//                     itemCount: cities.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         title: Text(cities[index]),
//                         onTap: () {
//                           setState(() {
//                             selectedCity = cities[index];
//                             _cityController.text = selectedCity;
//                             cities.clear();
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Email',
//             controller: _emailController,
//           ),
//           SizedBox(height: 24.0),
//           TextFieldWidget(
//             hintText: 'Mot de passe',
//             obscureText: true,
//             controller: _passwordController,
//           ),
//           SizedBox(height: 24.0),
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'J\'accepte les conditions générales et la politique de confidentialité',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24.0),
//           ElevatedButtonWidget(
//             buttonText: 'Inscription',
//             buttonColor: Colors.brown,
//             onPressed: () {
//               createUser();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TextFieldWidget extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;

//   const TextFieldWidget({
//     Key? key,
//     required this.hintText,
//     this.obscureText = false,
//     this.controller,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       obscureText: obscureText,
//     );
//   }
// }

// class ElevatedButtonWidget extends StatelessWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final VoidCallback onPressed;

//   const ElevatedButtonWidget({
//     Key? key,
//     required this.buttonText,
//     required this.buttonColor,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         primary: buttonColor,
//         onPrimary: Colors.white,
//         shape: StadiumBorder(),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(buttonText),
//       ),
//     );
//   }
// }
import 'package:a_rosa_je/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedCity = '';
  List<String> cities = [];
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> createUserAndNavigate() async {
    final url = Uri.parse('http://localhost:1212/auth/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "usersName": _userNameController.text,
        "email": _emailController.text,
        "city": selectedCity,
        "bio": "bio", // Vous pouvez modifier cela si nécessaire
        "password": _passwordController.text,
        "idRole": "2" // Vous pouvez modifier cela si nécessaire
      }),
    );

    if (response.statusCode == 201) {
      // L'utilisateur a été créé avec succès.
      // Vous pouvez afficher un message de succès ou effectuer d'autres actions ici.

      // Redirigez l'utilisateur vers la page LoginPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // La création de l'utilisateur a échoué.
      // Vous pouvez afficher un message d'erreur ou effectuer d'autres actions ici.
      throw Exception('Échec de la création de l\'utilisateur');
    }
  }

  Future<void> fetchCities(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://geo.api.gouv.fr/communes?nom=$cityName&fields=departement&boost=population&limit=5'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<String> cityNames = [];
      for (var cityData in jsonData) {
        cityNames.add(cityData['nom']);
      }
      setState(() {
        cities = cityNames;
      });
    } else {
      throw Exception('Échec de la récupération des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B5E20),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Image(image: AssetImage('images/LOGO.png')),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Nom',
            controller: _firstNameController,
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Prénom',
            controller: _lastNameController,
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Pseudonyme',
            controller: _userNameController,
          ),
          SizedBox(height: 24.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ville',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _cityController,
                onChanged: (cityName) {
                  if (cityName.isNotEmpty) {
                    fetchCities(cityName);
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              if (cities.isNotEmpty)
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(cities[index]),
                        onTap: () {
                          setState(() {
                            selectedCity = cities[index];
                            _cityController.text = selectedCity;
                            cities.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Email',
            controller: _emailController,
          ),
          SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: 'Mot de passe',
            obscureText: true,
            controller: _passwordController,
          ),
          SizedBox(height: 24.0),
          Row(
            children: [
              // Checkbox(
              //   value: isChecked,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       isChecked = value ?? false;
              //     });
              //   },
              // ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'J\'accepte les conditions générales et la politique de confidentialité',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          ElevatedButtonWidget(
            buttonText: 'Inscription',
            buttonColor: Colors.brown,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
              // createUserAndNavigate();
            },
          ),
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
    );
  }
}

class ElevatedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const ElevatedButtonWidget({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: Colors.white,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(buttonText),
      ),
    );
  }
}

// Implémentez la page LoginPage ici selon vos besoins
// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Page de Connexion'),
//       ),
//       body: Center(
//         child: Text(
//             'Vous êtes redirigé vers la page de connexion après inscription.'),
//       ),
//     );
//   }
// }
