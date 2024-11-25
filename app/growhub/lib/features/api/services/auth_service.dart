import 'dart:convert';
import 'package:growhub/features/api/core/auth_client.dart';
import 'package:growhub/features/api/data/models/user_model.dart';

class AuthService {
  final AuthClient authClient;

  AuthService(this.authClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await authClient.login(email, password);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return UserModel.fromJson(body);
      }

      throw Exception('Failed to login');
    } catch (e) {
      throw Exception('Log in failed: $e');
    }
  }

  Future<UserModel> signUp(
      String username, String email, String password) async {
    try {
      final response = await authClient.signUp(username, email, password);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return await login(email, password);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(
            'Failed to sign up: ${body['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }
}
