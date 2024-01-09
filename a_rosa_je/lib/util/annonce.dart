class Annonce {
  final int idAnnonce;
  final String titreAnnonce;
  final String statutAnnonce;
  final String dateDebutGardeAnnonce;
  final String dateFinGardeAnnonce;
  final String texteAnnonce;

  Annonce({
    required this.idAnnonce,
    required this.titreAnnonce,
    required this.statutAnnonce,
    required this.dateDebutGardeAnnonce,
    required this.dateFinGardeAnnonce,
    required this.texteAnnonce,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      idAnnonce: json['idAnnonce'] as int,
      titreAnnonce: json['titreAnnonce'] as String,
      statutAnnonce: json['statutAnnonce'] as String,
      dateDebutGardeAnnonce: json['dateDebutGardeAnnonce'] as String,
      dateFinGardeAnnonce: json['dateFinGardeAnnonce'] as String,
      texteAnnonce: json['texteAnnonce'] as String,
    );
  }
}
