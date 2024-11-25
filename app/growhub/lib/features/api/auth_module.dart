import 'package:growhub/features/api/core/auth_client.dart';
import 'package:growhub/features/api/services/auth_service.dart';

class AuthModule {
  static final AuthClient _authClient = AuthClient();

  static final authService = AuthService(_authClient);
}
