class User {
  final int id;
  final String username;
  final String name;
  final String lastname;
  final String rol;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.lastname,
    required this.rol,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      lastname: json['lastname'],
      rol: json['rol'],
      email: json['email'],
    );
  }
} 