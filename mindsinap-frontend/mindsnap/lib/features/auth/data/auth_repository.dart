// lib/features/auth/data/auth_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart'; // Add dio to your pubspec.yaml
import 'package:mindsnap/models/user.dart'; // Your User model

// This class will wrap the response from your login/register API
// if it returns both a user object and a token.
class AuthResponseWrapper {
  final User user;
  final String token;

  AuthResponseWrapper({required this.user, required this.token});

  // Factory to create from the JSON map returned by your API
  // You'll need to adjust this based on the EXACT structure of your API's login response
  factory AuthResponseWrapper.fromJson(Map<String, dynamic> json) {
    // Example: Assuming your API returns:
    // {
    //   "token": "your_jwt_token",
    //   "user": { "id": "123", "name": "Test User", "email": "test@example.com" }
    // }
    if (json['token'] == null || json['user'] == null) {
      throw Exception('Invalid API response format for login/registration.');
    }
    return AuthResponseWrapper(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}


class AuthRepository {
  final Dio _dio;
  // Your API base URL
  static const String _baseUrl = "http://localhost:5000"; // Ensure this is correct and accessible from your emulator/device

  AuthRepository(this._dio);

  // Example: Login
  Future<AuthResponseWrapper> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/api/auth/login", // Full URL for login
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        // Parse the response using your AuthResponseWrapper
        return AuthResponseWrapper.fromJson(response.data as Map<String, dynamic>);
      } else {
        // Handle non-200 responses that don't throw DioException by default
        final errorData = response.data as Map<String, dynamic>?;
        final message = errorData?['message'] ?? response.statusMessage ?? "Login failed";
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: message,
            type: DioExceptionType.badResponse);
      }
    } on DioException catch (e) {
      // More specific error handling for Dio errors
      String errorMessage = "Login failed. Please try again.";
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      print("AuthRepository Login DioError: $errorMessage --- ${e.response?.data}");
      throw Exception(errorMessage); // Throw a generic Exception with a user-friendly message
    } catch (e) {
      print("AuthRepository Login Generic Error: $e");
      throw Exception("An unexpected error occurred during login.");
    }
  }

  // Example: Register (Adapt based on your API)
  Future<AuthResponseWrapper> register({
    required String name,
    required String email,
    required String password,
    // Add other fields as necessary (e.g. username)
  }) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/api/auth/register", // Full URL for registration
        data: {
          'name': name,
          'email': email,
          'password': password,
          // Add other fields
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201 && response.data != null) {
        // Assuming registration also returns user and token
        return AuthResponseWrapper.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorData = response.data as Map<String, dynamic>?;
        final message = errorData?['message'] ?? response.statusMessage ?? "Registration failed";
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: message,
            type: DioExceptionType.badResponse);
      }
    } on DioException catch (e) {
      String errorMessage = "Registration failed. Please try again.";
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      print("AuthRepository Register DioError: $errorMessage --- ${e.response?.data}");
      throw Exception(errorMessage);
    } catch (e) {
      print("AuthRepository Register Generic Error: $e");
      throw Exception("An unexpected error occurred during registration.");
    }
  }

  // If you have an endpoint to get the current user's profile using a token
  Future<User?> getUserProfile(String token) async {
    if (token.isEmpty) return null; // No token, no profile to fetch

    try {
      final response = await _dio.get(
        "$_baseUrl/api/auth/me", // Or your specific "get user profile" endpoint
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data as Map<String, dynamic>);
      }
      return null; // Or throw an exception if user should always be found with a valid token
    } on DioException catch (e) {
      // If token is invalid (e.g., 401 Unauthorized), this is expected.
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        print("AuthRepository getUserProfile: Invalid or expired token.");
        return null;
      }
      print("AuthRepository getUserProfile DioError: ${e.response?.data ?? e.message}");
      // For other errors, you might want to throw to indicate a problem
      throw Exception("Failed to fetch user profile.");
    } catch (e) {
      print("AuthRepository getUserProfile Generic Error: $e");
      throw Exception("An unexpected error occurred while fetching user profile.");
    }
  }
  // In lib/features/auth/data/auth_repository.dart
  Future<String> checkBackendConnection() async {
    try {
      print("Attempting to connect to: $_baseUrl/");
      final response = await _dio.get("$_baseUrl/"); // Request to the root
      print("Backend check response status: ${response.statusCode}");
      print("Backend check response data: ${response.data}");
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        return "Failed: Status ${response.statusCode}";
      }
    } on DioException catch (e) {
      print("Backend check DioError: ${e.message}");
      if (e.response != null) {
        print("Backend check DioError response data: ${e.response?.data}");
      }
      // Log the specific DioException type if possible
      print("Backend check DioError type: ${e.type}");
      throw Exception("DioError on backend check: ${e.message}");
    } catch (e) {
      print("Backend check Generic Error: $e");
      throw Exception("Generic error on backend check: $e");
    }
  }

// NO logoutServer method needed if you don't have a backend logout endpoint.
// The token just exists in memory in the AuthController's state.
}