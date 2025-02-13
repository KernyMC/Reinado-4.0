import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RolesTab extends StatefulWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> roles;
  final List<Map<String, dynamic>> features;
  final void Function(String roleName) onCreateRole;
  final void Function(int roleId, String roleName) onUpdateRole;
  final void Function(int roleId) onDeleteRole;
  final Future<void> Function(int roleId, List<String> featureIds) onUpdateRoleFeatures;

  const RolesTab({
    super.key,
    required this.isLoading,
    required this.roles,
    required this.features,
    required this.onCreateRole,
    required this.onUpdateRole,
    required this.onDeleteRole,
    required this.onUpdateRoleFeatures,
  });

  @override
  State<RolesTab> createState() => _RolesTabState();
}

class _RolesTabState extends State<RolesTab> {
  Map<int, Map<String, bool>> _userFeatures = {};

  @override
  void initState() {
    super.initState();
    _initializeUserFeatures();
  }

  void _initializeUserFeatures() {
    _userFeatures = {};
    for (var user in widget.roles) {
      if (user['id'] != null && (user['rol'] == 'admin' || user['rol'] == 'notario')) {
        _userFeatures[user['id']] = {
          'tabla_notario': user['features']['tabla_notario'] == 1,
          'top_candidatas': user['features']['top_candidatas'] == 1,
          'admin_eventos': user['features']['admin_eventos'] == 1,
          'generar_reporte': user['features']['generar_reporte'] == 1,
        };
      }
    }
  }

  @override
  void didUpdateWidget(RolesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.roles != oldWidget.roles) {
      _initializeUserFeatures();
    }
  }

  Future<void> _updateFeature(int userId, String feature, bool value) async {
    try {
      setState(() {
        if (_userFeatures[userId] == null) {
          _userFeatures[userId] = {};
        }
        _userFeatures[userId]![feature] = value;
      });

      final activeFeatures = _userFeatures[userId]!
          .entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      await widget.onUpdateRoleFeatures(userId, activeFeatures);

      // Actualizar features en tiempo real para el usuario actual
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (userId == authProvider.user?.id) {
        authProvider.updateFeatures(activeFeatures);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar feature: $e')),
      );
    }
  }

  Widget _buildFeatureCheckbox(String title, String feature, int userId, String userRol) {
    bool isEnabled = _userFeatures[userId]?[feature] ?? false;

    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      value: isEnabled,
      onChanged: (bool? value) async {
        if (value != null) {
          await _updateFeature(userId, feature, value);
        }
      },
      checkColor: Colors.white,
      activeColor: const Color(0xFF0D4F02),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: widget.roles.length,
      itemBuilder: (context, index) {
        final user = widget.roles[index];
        if (user['rol'] != 'admin' && user['rol'] != 'notario') {
          return const SizedBox.shrink();
        }
        
        final userId = user['id'];
        
        return Card(
          margin: const EdgeInsets.all(8.0),
          color: Colors.white.withOpacity(0.1),
          child: ExpansionTile(
            title: Text(
              '${user['name']} ${user['lastname']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Rol: ${user['rol'].toUpperCase()}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Widgets Disponibles:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureCheckbox(
                      'Tabla Notario',
                      'tabla_notario',
                      userId,
                      user['rol'],
                    ),
                    _buildFeatureCheckbox(
                      'Top Candidatas',
                      'top_candidatas',
                      userId,
                      user['rol'],
                    ),
                    _buildFeatureCheckbox(
                      'Administrador de Eventos',
                      'admin_eventos',
                      userId,
                      user['rol'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
