class UserModel {
  final String fullName;
  final String email;
  final String? password;

  UserModel({required this.fullName, required this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'email': email, 'password': password};
  }

  UserModel copyWith({String? fullName, String? email, String? password}) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
