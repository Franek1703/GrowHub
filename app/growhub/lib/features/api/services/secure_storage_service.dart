import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

class SecureStorageService {
  // Save a value in secure storage
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: "jwt", value: token);
  }

  // Read a value from secure storage
  Future<String?> getToken() async {
    return await secureStorage.read(key: "jwt");
  }

  // Delete a value from secure storage
  Future<void> deleteToken() async {
    await secureStorage.delete(key: "jwt");
  }

  // Clear all values in secure storage
  Future<void> clearTokens() async {
    await secureStorage.deleteAll();
  }
}
