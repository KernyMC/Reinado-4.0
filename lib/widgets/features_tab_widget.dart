import 'package:flutter/material.dart';

class FeaturesTab extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> features;
  final void Function(String name) onCreateFeature;
  final void Function(int idFeature, bool enabled) onUpdateFeature;

  const FeaturesTab({
    super.key,
    required this.isLoading,
    required this.features,
    required this.onCreateFeature,
    required this.onUpdateFeature,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: features.length,
          itemBuilder: (context, index) {
            final f = features[index];
            final bool isEnabled = f['enabled'] == 1;
            return ListTile(
              title: Text(f['name']),
              trailing: Switch(
                value: isEnabled,
                onChanged: (val) {
                  onUpdateFeature(f['id_feature'], val);
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
            onPressed: () => _showCreateFeatureDialog(context),
          ),
        )
      ],
    );
  }

  void _showCreateFeatureDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nueva Feature"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nombre de la Feature'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Crear'),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                onCreateFeature(name);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
