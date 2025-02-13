import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class FeatureGuard extends StatelessWidget {
  final String featureName;
  final Widget child;

  const FeatureGuard({
    super.key,
    required this.featureName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final hasFeature = authProvider.features.contains(featureName);
        if (!hasFeature) return const SizedBox.shrink();
        return child;
      },
    );
  }
} 