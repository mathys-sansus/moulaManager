class Depense {
  final int? id; // Peut être null lors de la création d'une nouvelle note
  final String type;
  final double montant;
  final String? description;
  final int exceptionnel;

  Depense({
    this.id,
    required this.type,
    required this.montant,
    required this.description,
    required this.exceptionnel
  });

  /// Convertit une note en Map pour le stockage dans SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'montant': montant,
      "description": description,
      "exceptionnelle":exceptionnel
    };
  }

  /// Crée une Note à partir des données de la base de données
  factory Depense.fromMap(Map<String, dynamic> map) {
    return Depense(
        id: map['id'],
        type: map['type'],
        montant: map['montant'],
        description: map['description'],
        exceptionnel: map['exceptionnelle']
    );
  }
}
