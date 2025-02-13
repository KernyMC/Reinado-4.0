import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart' as auth_service;
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  List<String> _features = [];

  User? get user => _user;
  String? get token => _token;
  List<String> get features => _features;
  bool get isAuthenticated => _user != null && _token != null;
  bool get hasFeatures => _features.isNotEmpty;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void setFeatures(List<String> features) {
    _features = features;
    notifyListeners();
  }

  Future<void> updateFeatures(List<String> newFeatures) async {
    _features = newFeatures;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _token = null;
    _features = [];
    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      await auth_service.AuthService.register(userData);
    } catch (e) {
      print('Error en AuthProvider.register: $e');
      throw Exception('Error al registrar usuario: $e');
    }
  }

  Future<void> sendRecoveryEmail(String email) async {
    try {
      await auth_service.AuthService.sendRecoveryEmail(email);
    } catch (e) {
      print('Error en AuthProvider.sendRecoveryEmail: $e');
      throw Exception('Error al enviar correo de recuperación: $e');
    }
  }

  Future<void> resetPassword(String token, String password) async {
    try {
      await auth_service.AuthService.resetPassword(token, password);
    } catch (e) {
      print('Error en AuthProvider.resetPassword: $e');
      throw Exception('Error al restablecer la contraseña: $e');
    }
  }

  Future<void> verifyToken(String token) async {
    try {
      await auth_service.AuthService.verifyToken(token);
    } catch (e) {
      print('Error en AuthProvider.verifyToken: $e');
      throw Exception('Error al verificar token: $e');
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await ApiService.login(username, password);
      _user = response['user'] as User;
      _token = response['token'] as String;
      _features = List<String>.from(response['features'] ?? []);
      print('Features cargados: $_features'); // Para debugging
      notifyListeners();
    } catch (e) {
      print('Error en login: $e');
      rethrow;
    }
  }
}
