import 'package:growhub/features/api/data/models/alert_model.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/api/data/models/user_model.dart';
import 'package:growhub/features/api/services/api_service.dart';
import 'package:growhub/features/api/services/auth_service.dart';
import 'package:growhub/features/api/services/secure_storage_service.dart';
import 'package:growhub/features/api/data/models/dosage_history_model.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';

class ApiRepository {
  final AuthService authService;
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  ApiRepository({
    required this.authService,
    required this.apiService,
    required this.secureStorageService,
  });

  /// Log in using `email` and `password`.
  ///
  /// Returns `authToken` of type String.
  Future<String> login(String email, String password) async {
    return await authService.login(email, password);
  }

  /// Register the user using `email`, `username` and `password`.
  ///
  /// Returns `authToken` of type String.
  Future<String> signUp(String username, String email, String password) async {
    return await authService.signUp(username, email, password);
  }

  /// Indicates if the user is logged in by validating the token.
  Future<bool> isUserLoggedIn(String token) async {
    return await apiService.isUserLoggedIn(token);
  }

  /// Returns user's values.
  Future<UserModel> getUserData(String token) async {
    return await apiService.getUserData(token);
  }

  /// Return every `device` that the user owns.
  Future<Set<DeviceModel>> getConfiguration(String token) async {
    return await apiService.getConfiguration(token);
  }

  /// Return sensor readings for a specific device.
  Future<List<SensorModel>> getSensorsWithReadings(
      String token, int deviceId) async {
    return await apiService.getSensorReadings(token, deviceId);
  }

  /// Fetch dosage history for a specific device.
  Future<List<DosageHistoryModel?>> getDosageHistory(
      String token, int deviceId) async {
    return await apiService.getDosageHistory(token, deviceId);
  }

  /// Update device's values
  /// At least one parameter is needed from
  ///`icon`, `location`, `name`
  Future<void> updateDevice({
    required String token,
    required int deviceId,
    DeviceIcon? icon,
    String? location,
    String? name,
  }) async {
    await apiService.updateDevice(
      token: token,
      deviceId: deviceId,
      icon: icon,
      location: location,
      name: name,
    );
  }

  /// Update sensor's values
  /// At least one parameter is needed from
  ///`minValue`, `maxValue`, `measurementFrequency`
  Future<void> updateSensor({
    required String token,
    required int sensorId,
    double? minValue,
    double? maxValue,
    double? measurementFrequency,
  }) async {
    await apiService.updateSensor(
      token: token,
      sensorId: sensorId,
      minValue: minValue,
      maxValue: maxValue,
      measurementFrequency: measurementFrequency,
    );
  }

  /// Save auth token into the `secure storage`.
  Future<void> saveToken(String token) async {
    await secureStorageService.saveToken(token);
  }

  /// Read auth token from the `secure storage`.
  Future<String?> getToken() async {
    return await secureStorageService.getToken();
  }

  // Delete a value from secure storage
  Future<void> deleteToken() async {
    await secureStorageService.deleteToken();
  }

  /// Clear all values in the `secure storage`.
  Future<void> clearTokens() async {
    await secureStorageService.clearTokens();
  }

  /// Get all user alerts.
  Future<List<AlertModel>> getAlerts(String token) async {
    return await apiService.getAlerts(token);
  }

  /// Mark alert as resolved.
  Future<void> markAlertAsResolved(String token, int alertId) async {
    await apiService.markAlertAsResolved(token, alertId);
  }

  /// Delete alert.
  Future<void> deleteAlert(String token, int alertId) async {
    await apiService.deleteAlert(token, alertId);
  }

}
