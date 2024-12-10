class ApiClientPath {
  static Uri userInfo() {
    return Uri.parse("http://192.168.0.171:5000/api/user/info");
  }

  static Uri appConfiguration() {
    return Uri.parse("http://192.168.0.171:5000/api/configuration");
  }

  static Uri sensorReadings(int deviceId) {
    return Uri.parse("http://172.28.65.153:5000/api/sensor-readings/$deviceId");
  }
}
