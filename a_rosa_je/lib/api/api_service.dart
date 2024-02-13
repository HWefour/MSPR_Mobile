import 'package:a_rosa_je/util/annonce.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ApiService {
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
  Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String city,
    required String password,
    required String idRole,
  }) async {
    final url = Uri.parse('$baseUrl/auth/signup');
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
  Future<UserData> getUserData(String userId) async {
    final url = Uri.parse('$baseUrl/profile/$userId');
    final response = await http.get(url);

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
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUserData(UserData userData) async {
    final url = Uri.parse('$baseUrl/profile/$userData');
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
      throw Exception('Failed to update user data');
    }
  }

}

class UserData {
  final String firstName;
  final String lastName;
  final String userName;
  final String city;
  final String email;
  final String bio;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.city,
    required this.email,
    required this.bio,
  });
}


class ApiAnnoncesVille {
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
  Future<List<Annonce>> fetchAnnoncesVille(String city) async {
    final response =
        await http.get(Uri.parse('$baseUrl/home/city/$city'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}

class ApiAnnoncesUser {
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
  Future<List<Annonce>> fetchAnnoncesUser(String idUser) async {
    final response = await http
        .get(Uri.parse('$baseUrl/profile/profileAds/$idUser'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}

class ApiAnnoncesIdAdvertisement {
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
  Future<List<Annonce>> fetchAnnoncesIdAdvertisement(String idAdvertisement) async {
    int idAdvertisementTmp = int.parse(idAdvertisement);
    final response = await http
        .get(Uri.parse('$baseUrl/home/$idAdvertisementTmp'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}

class ApiCreateAnnounce {
  final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
  static Future<http.Response> createAnnounce({
    required String title,
    required String createdAt,
    required int idPlant,
    required int idUser,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
    final url = Uri.parse('$baseUrl/create_adv');
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


class ApiCreateJob {
  static Future<http.Response> createJob({
    required String dateDuJour,
    required int idUserAnnounceur,
    required int idAdvertisement,
    required int idUserGardien
  }) async {
    final  baseUrl = dotenv.env['API_BASE_URL'] ; // pour récupérer l'url de base dans le fichier .env
    final url = Uri.parse('$baseUrl/job/create');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "dates": dateDuJour,
          "idUser": idUserAnnounceur,
          "idAdvertisement": idAdvertisement,
          "idUserGardien": idUserGardien
        }));

    return response;
  }
}