class AuthClientPath {
  static Uri login() {
    return Uri.parse("http://5.75.170.112:5002/auth/login");
  }

  static Uri signUp() {
    return Uri.parse("http://5.75.170.112:5002/auth/register");
  }
}
