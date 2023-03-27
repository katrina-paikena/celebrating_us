enum CelebrationType { birthday, nameday, anniversary }

class Celebration {
  final int? id;
  final String name;
  final DateTime date;
  final CelebrationType type;

  Celebration({
    this.id,
    required this.name,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'type': type.index,
    };
  }
}