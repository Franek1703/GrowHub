class UserModel {
  final String username;
  final String email;

  UserModel({
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return UserModel(
      username: json['username'],
      email: json['email'],
    );
  }
}
