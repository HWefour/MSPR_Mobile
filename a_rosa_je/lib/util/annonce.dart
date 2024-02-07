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
  });

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
    );
  }
}

