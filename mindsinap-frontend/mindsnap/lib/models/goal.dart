// lib/models/goal.dart

class Goal {
  final String id;        // For identifying goals, e.g., for deletion
  final String platform;  // As used in your controller's create method
  final int dailyLimit; // As used in your controller's create method
  // Add any other properties your 'Goal' actually has
  // For example, if you also have a general 'title' or 'description':
  // final String? title;
  // final String? description;


  Goal({
    required this.id,
    required this.platform,
    required this.dailyLimit,
    // this.title,
    // this.description,
  });

  // This factory constructor is ESSENTIAL for converting data from your repository
  // (which is List<Map<String, dynamic>>) into List<Goal>
  factory Goal.fromJson(Map<String, dynamic> jsonMap) {
    return Goal(
      // IMPORTANT: Adjust the keys ('id', 'platform', 'dailyLimit')
      // to match EXACTLY what your backend/database returns in the map.
      id: jsonMap['id'] as String,
      platform: jsonMap['platform'] as String,
      dailyLimit: jsonMap['dailyLimit'] as int,
      // If you added title/description above, uncomment and map them here too:
      // title: jsonMap['title'] as String?,
      // description: jsonMap['description'] as String?,
    );
  }

  // Optional: If you need to send Goal objects as JSON to your backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'dailyLimit': dailyLimit,
      // 'title': title,
      // 'description': description,
    };
  }
}