import 'dart:convert';
import 'package:growhub/features/api/core/api_timeout.dart';
import 'package:growhub/features/api/core/auth_client.dart';

class AuthService {
  final AuthClient authClient;

  AuthService(this.authClient);

  Future<String> login(String email, String password) async {
    try {
      final response = await authClient.login(email, password).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return body['access_token'];
      }

      throw Exception('Failed to login');
    } catch (e) {
      throw Exception('Log in failed: $e');
    }
  }

  Future<String> signUp(String username, String email, String password) async {
    try {
      final response =
          await authClient.signUp(username, email, password).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );
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
