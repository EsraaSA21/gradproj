class User {
  final String fullName;
  final String email;
  final String phone;
  final String username;
  final String id;


  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.username,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      id: json['id'],
    );
  }
}