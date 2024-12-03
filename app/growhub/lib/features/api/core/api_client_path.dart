class ApiClientPath {
  static Uri userInfo() {
    return Uri.parse("http://192.168.0.171:5000/api/user/info");
  }

  static Uri appConfiguration() {
    return Uri.parse("http://192.168.0.171:5000/api/configuration");
  }
}
