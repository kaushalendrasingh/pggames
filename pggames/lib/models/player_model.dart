class PlayerModel {
  final String id;
  final String name;
  final String role;
  final String team;
  final String? image;
  final int points;

  PlayerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.team,
    this.image,
    this.points = 0,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    role: json['role'] ?? '',
    team: json['team'] ?? '',
    image: json['image'],
    points: json['points'] ?? 0,
  );
}
