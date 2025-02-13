class UserModel {
  final int id;
  final String username;
  final String? email;
  final String? name;
  final String? lastname;
  final String rol;
  final Map<String, bool> features;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.name,
    this.lastname,
    required this.rol,
    required this.features,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      lastname: json['lastname'],
      rol: json['rol'],
      features: Map<String, bool>.from(json['features'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'lastname': lastname,
      'rol': rol,
      'features': features,
    };
  }
}
