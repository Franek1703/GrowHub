import 'package:http/http.dart' as http;

abstract class GHBaseClient {
  Future<http.Response> getTokenized(Uri uri, String token) async {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> postTokenized(
      Uri uri, String token, Object? body) async {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> post(Uri url, Object? body) async {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }

  Future<http.Response> get(Uri url) async {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }
}
