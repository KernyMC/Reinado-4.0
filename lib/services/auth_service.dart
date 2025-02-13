import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart'; // Importa la configuración

class AuthService {
  static const String baseUrl = apiBaseUrl; // Usa la variable global

  static Future<AuthUser> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al iniciar sesión: ${response.body}');
      }

      final json = jsonDecode(response.body);
      return AuthUser.fromJson(json);
    } catch (e) {
      print('Error en AuthService.login: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  static Future<void> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al registrar usuario: ${response.body}');
      }
    } catch (e) {
      print('Error en AuthService.register: $e');
      throw Exception('Error al registrar usuario: $e');
    }
  }

  static Future<void> sendRecoveryEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/enviarCorreoRestablecimiento'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al enviar correo de recuperación: ${response.body}');
      }
    } catch (e) {
      print('Error en AuthService.sendRecoveryEmail: $e');
      throw Exception('Error al enviar correo de recuperación: $e');
    }
  }

  static Future<void> resetPassword(String token, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': password}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al restablecer la contraseña: ${response.body}');
      }
    } catch (e) {
      print('Error en AuthService.resetPassword: $e');
      throw Exception('Error al restablecer la contraseña: $e');
    }
  }

  static Future<void> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verifyToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode != 200) {
        throw Exception('Código de restablecimiento no válido: ${response.body}');
      }
    } catch (e) {
      print('Error en AuthService.verifyToken: $e');
      throw Exception('Código de restablecimiento no válido: $e');
    }
  }
}

class AuthUser {
  final int id;
  final String username;
  final String name;
  final String lastname;
  final String email;
  final String rol;

  // Nuevo campo
  final String token; // <-- para el JWT

  AuthUser({
    required this.id,
    required this.username,
    required this.name,
    required this.lastname,
    required this.email,
    required this.rol,
    required this.token, // <--
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AuthUser(
      id: userJson['id'],
      username: userJson['username'],
      name: userJson['name'] ?? '',
      lastname: userJson['lastname'] ?? '',
      email: userJson['email'] ?? '',
      rol: userJson['rol'],
      token: json['token'] ?? '', // <-- recoges 'token' del JSON root
    );
  }
}
