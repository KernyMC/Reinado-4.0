import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  final List<String>? requiredFeatures;

  const ProtectedRoute({
    super.key, 
    required this.child, 
    required this.allowedRoles,
    this.requiredFeatures,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (!authProvider.isAuthenticated) {
      return const Center(child: Text('No estás autenticado.'));
    }
    if (!allowedRoles.contains(authProvider.user!.rol)) {
      return const Center(child: Text('No tienes acceso a esta sección.'));
    }
    if (requiredFeatures != null && requiredFeatures!.isNotEmpty) {
      final hasRequiredFeatures = requiredFeatures!
          .every((feature) => authProvider.features.contains(feature));
      
      if (!hasRequiredFeatures) {
        return const Center(
          child: Text('No tienes los permisos necesarios para ver esta sección.'),
        );
      }
    }
    return child;
  }
}
