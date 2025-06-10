class Goal {
  final String id;
  final String title;
  final String description;

  Goal({required this.id, required this.title, required this.description});

  Goal copyWith({String? id, String? title, String? description}) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
