import 'package:growhub/features/api/core/ip_path.dart';

class AuthClientPath {
  static Uri login() {
    return Uri.parse("${IpPath.ip}/auth/login");
  }

  static Uri signUp() {
    return Uri.parse("${IpPath.ip}/auth/register");
  }
}
