import 'package:growhub/features/api/core/ip_path.dart';

class ApiClientPath {
  static Uri userInfo() {
    return Uri.parse("${IpPath.ip}/api/user/info");
  }

  static Uri appConfiguration() {
    return Uri.parse("${IpPath.ip}/api/configuration");
  }

  static Uri sensorReadings(int deviceId) {
    return Uri.parse("${IpPath.ip}/api/sensor-readings/$deviceId");
  }

  static Uri dosageHistory(int deviceId) {
    return Uri.parse("${IpPath.ip}/api/dosage-history/$deviceId");
  }
}
