import 'package:growhub/features/api/core/api_client_path.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<http.Response> getUserInfo(String token) async {
    final response = await http.post(
      ApiClientPath.userInfo(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );
    return response;
  }
}
