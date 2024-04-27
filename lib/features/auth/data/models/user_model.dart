class UserModel {
  String userId;
  String name;
  String email;


  UserModel({
    required this.name,
    required this.email,
    required this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      userId: json['uId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uId': userId,
    };
  }
}