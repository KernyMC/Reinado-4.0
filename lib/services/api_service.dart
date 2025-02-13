import 'dart:convert';
import 'package:http/http.dart' as http;
// Importa la configuración
import '../utils/config.dart'; // Importa la configuración
import '../models/user.dart';

class ApiService {
  static const String baseUrl = apiBaseUrl;

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  static Future<dynamic> get(
    String endpoint, {
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  static Future<dynamic> delete(
    String endpoint, {
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await get('/user', token: null);
      print('Response from getAllUsers: $response');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      throw Exception('Respuesta inválida del servidor');
    } catch (e) {
      print('Error en getAllUsers: $e');
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  static Future<void> updateUser(int userId, String email, String name, String lastname, String rol) async {
    try {
      final response = await put(
        '/user/$userId',
        {
          'email': email,
          'name': name,
          'lastname': lastname,
          'rol': rol,
        },
      );

      if (response == null) {
        throw Exception('Error al actualizar usuario: respuesta vacía');
      }
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  static Future<void> updateUserFeatures(int userId, List<String> features, {String? token}) async {
    try {
      final response = await put(
        '/users/$userId/features',
        {
          'features': features,
        },
        token: token,
      );

      if (response == null) {
        throw Exception('Error al actualizar features: respuesta vacía');
      }
    } catch (e) {
      throw Exception('Error al actualizar features: $e');
    }
  }

  static Future<void> submitVote(int userId, int candidataId, int puntuacion) async {
    try {
      final response = await post(
        '/cali/votacionPublica',
        {
          'USUARIO_ID': userId,
          'CANDIDATA_ID': candidataId,
          'CALIFICACION_VALOR': puntuacion,
          'EVENTO_ID': 4
        },
      );

      if (response == null) {
        throw Exception('Error al enviar voto: respuesta vacía');
      }
    } catch (e) {
      throw Exception('Error al enviar voto: $e');
    }
  }

  static Future<bool> checkUserVoted(int userId) async {
    try {
      final response = await get('/cali/checkUserVoted/$userId');
      return response['hasVoted'] ?? false;
    } catch (e) {
      print('Error verificando voto del usuario: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getRoleFeatures(int roleId) async {
    try {
      final response = await get('/roles/$roleId/features');
      if (response == null) {
        return [];
      }
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error al obtener features del rol: $e');
      return [];
    }
  }

  static Future<void> updateRoleFeatures(int userId, List<String> features, {String? token}) async {
    try {
      final response = await put(
        '/user/$userId/features',
        {
          'features': features,
        },
        token: token,
      );

      if (response == null) {
        throw Exception('Error al actualizar features: respuesta vacía');
      }
    } catch (e) {
      throw Exception('Error al actualizar features: $e');
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        return {
          'user': user,
          'token': data['token'],
          'features': List<String>.from(data['features'] ?? []),
        };
      } else {
        throw Exception('Error en el login');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  static Future<List<dynamic>> fetchCandidates(String token) async {
    try {
      final response = await get('/candidates', token: token);
      return response as List<dynamic>;
    } catch (e) {
      // Si es 404, retornamos lista vacía en lugar de lanzar error
      if (e.toString().contains('404')) {
        return [];
      }
      throw e;
    }
  }
}
