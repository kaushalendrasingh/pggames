class TeamModel {
  final String id;
  final String name;
  final String? image;
  final List<Map<String, dynamic>> matches;

  TeamModel({
    required this.id,
    required this.name,
    this.image,
    required this.matches,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'],
    matches:
        (json['matches'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [],
  );
}
