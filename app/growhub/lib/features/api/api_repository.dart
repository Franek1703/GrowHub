import 'package:growhub/features/api/data/models/user_model.dart';
import 'package:growhub/features/api/services/api_service.dart';
import 'package:growhub/features/api/services/auth_service.dart';
import 'package:growhub/features/api/services/secure_storage_service.dart';

class ApiRepository {
  final AuthService authService;
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  ApiRepository({
    required this.authService,
    required this.apiService,
    required this.secureStorageService,
  });

  Future<String> login(String email, String password) async {
    return await authService.login(email, password);
  }

  Future<String> signUp(String username, String email, String password) async {
    return await authService.signUp(username, email, password);
  }

  Future<bool> isUserLoggedIn(String token) async {
    return await apiService.isUserLoggedIn(token);
  }

  Future<UserModel> getUserData(String token) async {
    return await apiService.getUserData(token);
  }

  Future<void> saveToken(String token) async {
    await secureStorageService.saveToken(token);
  }

  // Read a value from secure storage
  Future<String?> getToken() async {
    return await secureStorageService.getToken();
  }

  // Delete a value from secure storage
  Future<void> deleteToken(String key) async {
    await secureStorageService.deleteToken();
  }

  // Clear all values in secure storage
  Future<void> clearTokens() async {
    await secureStorageService.clearTokens();
  }
}
