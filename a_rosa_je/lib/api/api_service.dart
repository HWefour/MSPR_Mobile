import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/annonce.dart';

class ApiService {
  Future<List<Annonce>> fetchAnnonces() async {
    final response = await http.get(Uri.parse('http://192.168.56.1:1212/annonce'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Annonce.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load annonces from API');
    }
  }
}
