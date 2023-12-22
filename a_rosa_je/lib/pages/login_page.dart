import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LogoWidget(),
                SizedBox(height: 48.0),
                TextFieldWidget(
                  hintText: 'Nom d\'utilisateur',
                ),
                SizedBox(height: 16.0),
                TextFieldWidget(
                  hintText: 'Mot de Passe',
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                ElevatedButtonWidget(
                  buttonText: 'Se connecter',
                  buttonColor: Colors.red,
                  onPressed: () {
                    // Handle login logic
                  },
                ),
                TextButton(
                  child: Text(
                    'Pas encore de compte ? Inscrivez-vous !',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // Navigate to sign up page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
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
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: Colors.white,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(buttonText),
      ),
      onPressed: onPressed,
    );
  }
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ideally, you'd use an AssetImage or NetworkImage depending on where your logo is hosted
    // For example, AssetImage('assets/logo.png'),
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: Center(
        // Replace with your actual logo image
        child: Text(
          'LOGe',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
