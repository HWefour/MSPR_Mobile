class Annonce {
  final String? idAdvertisement;
  final String? title;
  final String? createdAt;
  final String? city;
  final String? idPlant;
  final String? name;
  final String? idUser;
  final String? description;
  final String? firstName;
  final String? lastName;
  final String? usersName;
  final String? bio;
  final String? startDate;
  final String? endDate;
  final List<String> imageUrls;

  Annonce({
    required this.idAdvertisement,
    required this.title,
    required this.createdAt,
    required this.city,
    required this.idPlant,
    this.name,
    required this.idUser,
    required this.description,
    required this.firstName,
    required this.lastName,
    required this.usersName,
    required this.bio,
    this.startDate,
    this.endDate,
    required this.imageUrls,
  });

  // Ajoutez également une méthode `copyWith` si nécessaire pour la mise à jour
  Annonce copyWith({
  List<String>? imageUrls, }) {
    return Annonce(
      idAdvertisement: this.idAdvertisement,
      title: this.title,
      createdAt: this.createdAt,
      city: this.city,
      idPlant: this.idPlant,
      name: this.name,
      idUser: this.idUser,
      description: this.description,
      firstName: this.firstName,
      lastName: this.lastName,
      usersName: this.usersName,
      bio: this.bio,
      startDate: this.startDate,
      endDate: this.endDate,
      imageUrls: imageUrls ?? this.imageUrls,
    );
}

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      idAdvertisement: json['idAdvertisement'].toString(),
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      city: json['city'] as String,
      idPlant: json['idPlant'].toString(),
      name: json.containsKey('name') ? json['name'] as String : null,
      idUser: json['idUser'].toString(),
      description: json['description'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      usersName: json['usersName'] as String,
      bio: json['bio'] as String,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      imageUrls:[],
    );
  }
}

