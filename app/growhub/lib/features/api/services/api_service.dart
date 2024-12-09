import 'dart:convert';

import 'package:growhub/features/api/core/api_client.dart';
import 'package:growhub/features/api/core/api_timeout.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/api/data/models/user_model.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService(this.apiClient);

  Future<bool> isUserLoggedIn(String token) async {
    try {
      final response = await apiClient.getUserInfo(token).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );
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
      final response = await apiClient.getUserInfo(token).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return UserModel.fromJson(body);
      }

      throw Exception('Failed to fetch data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Set<DeviceModel>> getConfiguration(String token) async {
    try {
      final response = await apiClient.getAppConfiguration(token).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        Set<DeviceModel> devices = {};
        for (var device in body["devices"]) {
          devices.add(DeviceModel.fromJson(device));
        }

        return devices;
      }
      throw Exception('Failed to fetch data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<SensorModel>> getSensorReadings(
      String token, int deviceId) async {
    try {
      final response =
          await apiClient.getSensorReadings(token, deviceId).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        List<SensorModel> sensors = [];
        for (var sensor in body["sensor_readings"]) {
          sensors.add(SensorModel.fromJson(sensor));
        }

        return sensors;
      }
      throw Exception('Failed to fetch data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
