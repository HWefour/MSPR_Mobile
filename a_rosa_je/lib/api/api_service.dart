import 'package:a_rosa_je/pages/profil_info.dart';
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
        "bio": "", // Vous pouvez modifier cela si nécessaire
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

  // Méthode pour récupérer les données utilisateur
 Future<UserData> getUserData() async {
    final response =
        await http.get(Uri.parse('http://localhost:1212/auth/login/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserData(
        firstName: jsonData['firstName'],
        lastName: jsonData['lastName'],
        userName: jsonData['userName'],
        city: jsonData['city'],
        email: jsonData['email'],
        bio: jsonData['bio'],
      );
    } else {
      throw Exception('Échec de la récupération des données');
    }
  }

  // Méthode pour mettre à jour les données utilisateur
Future<void> updateUserData(UserData userData) async {
    final url = Uri.parse('http://localhost:1212/auth/updateUser/');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'firstName': userData.firstName,
        'lastName': userData.lastName,
        'userName': userData.userName,
        'city': userData.city,
        'email': userData.email,
        'bio': userData.bio,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour des données utilisateur');
    }
  }
}

class ApiAnnoncesVille {
  Future<List<Annonce>> fetchAnnoncesVille(String city) async {
    final response =
        await http.get(Uri.parse('http://localhost:1212/home/city/$city'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}

class ApiAnnoncesUser {
  Future<List<Annonce>> fetchAnnoncesUser(String idUser) async {
    final response = await http
        .get(Uri.parse('http://localhost:1212/profile/profileAds/$idUser'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}

class ApiCreateAnnounce {
  static Future<http.Response> createAnnounce({
    required String title,
    required String createdAt,
    required int idPlant,
    required String idUser,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse('http://localhost:1212/create_adv');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "created_at": createdAt,
          "idPlant": idPlant,
          "idUser": idUser,
          "description": description,
          "start_date": startDate,
          "end_date": endDate,
        }));

    return response;
  }
}
