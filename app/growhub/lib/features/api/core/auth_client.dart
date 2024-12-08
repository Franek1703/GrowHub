import 'dart:convert';

import 'package:growhub/features/api/core/auth_client_path.dart';
import 'package:http/http.dart' as http;

class AuthClient {
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      AuthClientPath.login(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }

  Future<http.Response> signUp(
      String username, String email, String password) async {
    final response = await http.post(
      AuthClientPath.signUp(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );
    return response;
  }
}
