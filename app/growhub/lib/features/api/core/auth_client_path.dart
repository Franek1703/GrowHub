class AuthClientPath {
  static Uri login() {
    return Uri.parse("http://192.168.0.171:5000/auth/login");
  }

  static Uri signUp() {
    return Uri.parse("http://192.168.0.171:5000/auth/register");
  }
}
