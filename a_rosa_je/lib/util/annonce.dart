class Annonce {
  final String idAdvertisement;
  final String title;
  final String createdAt;
  final String? updatedAt; // This can be null
  final String city;
  final String idPlant;
  final String idUser;
  final String description;
  final String firstName;
  final String lastName;
  final String usersName;
  final String bio;

  Annonce({
    required this.idAdvertisement,
    required this.title,
    required this.createdAt,
    this.updatedAt,
    required this.city,
    required this.idPlant,
    required this.idUser,
    required this.description,
    required this.firstName,
    required this.lastName,
    required this.usersName,
    required this.bio,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      idAdvertisement: json['idAdvertisement'] as String,
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      city: json['city'] as String,
      idPlant: json['idPlant'] as String,
      idUser: json['idUser'] as String,
      description: json['description'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      usersName: json['usersName'] as String,
      bio: json['bio'] as String,
    );
  }
}
