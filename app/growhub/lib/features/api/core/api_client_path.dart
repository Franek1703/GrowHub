class ApiClientPath {
  static Uri userInfo() {
    return Uri.parse("http://5.75.170.112:5002/api/user/info");
  }

  static Uri appConfiguration() {
    return Uri.parse("http://5.75.170.112:5002/api/configuration");
  }

  static Uri sensorReadings(int deviceId) {
    return Uri.parse("http://5.75.170.112:5002/api/sensor-readings/$deviceId");
  }
}
