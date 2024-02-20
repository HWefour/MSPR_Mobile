class Plante {
  final String? idPlant;
  final String? name;
  final String? description;
  final List<String>? imageUrls;

  Plante({
    required this.idPlant,
    this.name,
    required this.description,
    required this.imageUrls,
  });

  // Ajoutez également une méthode `copyWith` si nécessaire pour la mise à jour
  Plante copyWith({
  List<String>? imageUrls, }) {
    return Plante(
      idPlant: this.idPlant,
      name: this.name,
      description: this.description,
      imageUrls: imageUrls ?? this.imageUrls,
    );
}

  factory Plante.fromJson(Map<String, dynamic> json) {
    return Plante(
      idPlant: json['idPlant'].toString(),
      name: json.containsKey('name') ? json['name'] as String : null,
      description: json['description'] as String,
      imageUrls:[],
    );
  }
}

