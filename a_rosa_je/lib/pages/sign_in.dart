import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isChecked = false; // Pour gérer l'état de la case à cocher

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B5E20),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Image(image: AssetImage('images/LOGO.png')),
            SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _nameController,
              hintText: 'Nom',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _firstNameController,
              hintText: 'Prénom',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre prénom';
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _usernameController,
              hintText: 'Pseudonyme',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre pseudonyme';
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _emailController,
              hintText: 'Email',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                    .hasMatch(value)) {
                  return 'Adresse email invalide';
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _passwordController,
              hintText: 'Mot de passe',
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                if (value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }
                if (!value.contains(RegExp(r'[A-Z]'))) {
                  return 'Le mot de passe doit contenir au moins une majuscule';
                }
                if (!value.contains(RegExp(r'[0-9]'))) {
                  return 'Le mot de passe doit contenir au moins un chiffre';
                }
                if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Le mot de passe doit contenir au moins un caractère spécial';
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _confirmPasswordController,
              hintText: 'Vérification du mot de passe',
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isChecked =
                      !isChecked; // Inversez l'état de la case à cocher lors du clic
                });
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    isChecked
                        ? 'assets/checked_checkbox.svg'
                        : 'assets/unchecked_checkbox.svg',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'J\'accepte les conditions générales et la politique de confidentialité',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButtonWidget(
              buttonText: 'Inscription',
              buttonColor: Colors.brown,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Gérer la soumission du formulaire ici
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
      validator: validator,
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
