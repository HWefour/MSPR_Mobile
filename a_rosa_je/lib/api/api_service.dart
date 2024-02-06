// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../util/annonce.dart';

// //ip ordi fixe : 192.168.56.1
// //ip ordi portable : 192.168.71.1
// //localhost: http://localhost:1212/home/city/Montpellier
// class ApiService {
//   Future<List<Annonce>> fetchAnnonces(String city) async {
//     final response = await http.get(Uri.parse('http://localhost:1212/home/city/$city'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load annonces from API');
//     }
//   }
// }
import 'package:a_rosa_je/util/annonce.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String city,
    required String password,
    required String idRole,
  }) async {
    final url = Uri.parse('http://localhost:1212/auth/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "usersName": userName,
        "email": email,
        "city": city,
        "bio": "bio", // Vous pouvez modifier cela si nécessaire
        "password": password,
        "idRole": idRole, // Vous pouvez modifier cela si nécessaire
      }),
    );

    if (response.statusCode == 201) {
      // L'utilisateur a été créé avec succès.
      return {'success': true};
    } else {
      // La création de l'utilisateur a échoué.
      final errorMessage = json.decode(response.body)['message'];
      return {'success': false, 'error': errorMessage};
    }
  }

  Future<List<Annonce>> fetchAnnonces(String city) async {
    final response = await http.get(Uri.parse('http://localhost:1212/home/city/$city'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}