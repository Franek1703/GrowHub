import 'dart:convert';

import 'package:growhub/features/api/core/auth_client_path.dart';
import 'package:growhub/features/api/core/base_client.dart';
import 'package:http/http.dart' as http;

class AuthClient extends GHBaseClient {
  Future<http.Response> login(String email, String password) async {
    return super.post(AuthClientPath.login(),
        jsonEncode({'email': email, 'password': password}));
  }

  Future<http.Response> signUp(
      String username, String email, String password) async {
    return super.post(
        AuthClientPath.signUp(),
        jsonEncode(
            {'username': username, 'email': email, 'password': password}));
  }
}
