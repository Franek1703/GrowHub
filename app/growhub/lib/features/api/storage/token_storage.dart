// import 'package:growhub/features/api/services/secure_storage_service.dart';

// // Storing secured JWT token
// class TokenStorage {
//   final SecureStorageService secureStorageService;

//   TokenStorage(this.secureStorageService);

//   Future<void> saveToken(String token) async {
//     await secureStorageService.write('jwt', token);
//   }

//   Future<String?> getToken() async {
//     return await secureStorageService.read('jwt');
//   }

//   Future<void> clearToken() async {
//     await secureStorageService.delete('jwt');
//   }
// }
