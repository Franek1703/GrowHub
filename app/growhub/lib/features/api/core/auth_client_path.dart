class AuthClientPath {
  static Uri login() {
    return Uri.parse("http://172.28.65.153:5000/auth/login");
  }

  static Uri signUp() {
    return Uri.parse("http://172.28.65.153:5000/auth/register");
  }
}
