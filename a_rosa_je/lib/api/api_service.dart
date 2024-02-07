import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/annonce.dart';

//ip ordi fixe : 192.168.56.1
//ip ordi portable : 192.168.71.1
//localhost: http://localhost:1212/home/city/Montpellier

//api pour récupérer les annonces par ville
class ApiService {
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

//api pour créer une annonce
class ApiCreateAnnounce {
  static Future<http.Response> createAnnounce({
    required String title,
    required String createdAt,
    required String idPlant,
    required String idUser,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse('http://localhost:1212/create_adv');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
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