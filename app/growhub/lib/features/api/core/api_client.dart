import 'package:growhub/features/api/core/api_client_path.dart';
import 'package:growhub/features/api/core/base_client.dart';
import 'package:http/http.dart' as http;

class ApiClient extends GHBaseClient {
  Future<http.Response> getUserInfo(String token) async {
    return super.getTokenized(ApiClientPath.userInfo(), token);
  }

  Future<http.Response> getAppConfiguration(String token) async {
    return super.getTokenized(ApiClientPath.appConfiguration(), token);
  }

  Future<http.Response> getSensorReadings(String token, int deviceId) async {
    return super.getTokenized(ApiClientPath.sensorReadings(deviceId), token);
  }

  Future<http.Response> getDosageHistory(String token, int deviceId) async {
    return super.getTokenized(ApiClientPath.dosageHistory(deviceId), token);
  }

  Future<http.Response> updateDevice(
      String token, int deviceId, Map<String, dynamic> body) async {
    return super.patchTokenized(ApiClientPath.devices(deviceId), token, body);
  }
}
