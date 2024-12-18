import 'dart:convert';

import 'package:growhub/features/api/core/api_client.dart';
import 'package:growhub/features/api/core/api_timeout.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/api/data/models/user_model.dart';
import 'package:growhub/features/api/data/models/dosage_history_model.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';

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

  Future<List<DosageHistoryModel?>> getDosageHistory(
      String token, int deviceId) async {
    try {
      final response =
          await apiClient.getDosageHistory(token, deviceId).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> dosagesJson = body["dosages"];
        return dosagesJson
            .map((json) => DosageHistoryModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception("Device not found.");
      }
      throw Exception("Failed to fetch dosage history.");
    } catch (e) {
      throw Exception("Error fetching dosage history: $e");
    }
  }

  Future<void> updateDevice({
    required String token,
    required int deviceId,
    DeviceIcon? icon,
    String? location,
    String? name,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (icon != null) {
        updates['icon'] = icon.index;
      }
      if (location != null) {
        updates['location'] = location;
      }
      if (name != null) {
        updates['name'] = name;
      }

      if (updates.isEmpty) {
        throw Exception(
            "At least one field (icon, location, name) is required to update the device.");
      }

      final response =
          await apiClient.updateDevice(token, deviceId, updates).timeout(
        ApiTimeout.timeout,
        onTimeout: () {
          throw ApiTimeout.timeoutException;
        },
      );

      if (response.statusCode == 200) {
        return;
      }
      if (response.statusCode == 404) {
        throw Exception("Device not found.");
      }
      throw Exception("Failed to fetch dosage history.");
    } catch (e) {
      throw Exception("Error fetching dosage history: $e");
    }
  }
}
