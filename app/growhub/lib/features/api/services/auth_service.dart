import 'dart:convert';
import 'package:growhub/features/api/core/auth_client.dart';
import 'package:growhub/features/api/data/models/user_model.dart';

class AuthService {
  final AuthClient authClient;

  AuthService(this.authClient);

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await authClient.login(email, password);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return UserModel.fromJson(body);
      }

      throw Exception('Failed to login');
    } catch (e) {
      return null;
    }
  }
}
