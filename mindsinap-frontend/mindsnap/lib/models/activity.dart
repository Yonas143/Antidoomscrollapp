class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String userId;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }
}
