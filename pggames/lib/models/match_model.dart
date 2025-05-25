class MatchModel {
  final String date;
  final String opponent;
  final String venue;
  final String? result;

  MatchModel({
    required this.date,
    required this.opponent,
    required this.venue,
    this.result,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
    date: json['date'] ?? '',
    opponent: json['opponent'] ?? '',
    venue: json['venue'] ?? '',
    result: json['result'],
  );
}
