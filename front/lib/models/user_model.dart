
class User {
  String id;
  String name;
  String email;
  String role;
  DateTime? lastLogin;

  User({required this.id,required this.name, required this.email, required this.role,this.lastLogin});
  factory User.fromJson(dynamic json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      lastLogin: json['lastLogin'] == null ? null : DateTime.parse(json['lastLogin']),

    );
  }
}