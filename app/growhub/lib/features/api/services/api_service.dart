import 'dart:convert';

import 'package:growhub/features/api/core/api_client.dart';
import 'package:growhub/features/api/data/models/user_model.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService(this.apiClient);

  Future<bool> isUserLoggedIn(String token) async {
    try {
      final response = await apiClient.getUserInfo(token);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Log in failed: $e');
    }
  }

  Future<UserModel> getUserData(String token) async {
    try {
      final response = await apiClient.getUserInfo(token);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return UserModel.fromJson(body);
      }

      throw Exception('Failed to fetch data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
