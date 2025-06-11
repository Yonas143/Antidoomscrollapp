// lib/models/user.dart
class User {
  final String id;
  final String? name;
  final String email;
  // Add other user fields as per your API response

  User({required this.id, this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String, // Adjust 'id' if your API uses a different key (e.g., '_id')
      name: json['name'] as String?,
      email: json['email'] as String,
      // Map other fields
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}