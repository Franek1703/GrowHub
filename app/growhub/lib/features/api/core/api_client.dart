import 'package:growhub/features/api/core/api_client_path.dart';
import 'package:http/http.dart' as http;

abstract class Tokenizer {
  Future<http.Response> getTokenized(Uri uri, String token) async {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    return response;
  }
}

class ApiClient extends Tokenizer {
  Future<http.Response> getUserInfo(String token) async {
    final response = await http.get(
      ApiClientPath.userInfo(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> getAppConfiguration(String token) async {
    final response = await http.get(
      ApiClientPath.appConfiguration(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );
    return response;
  }
}
