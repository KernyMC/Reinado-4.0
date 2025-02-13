import 'package:flutter/material.dart';

class GalaScreen extends StatelessWidget {
  const GalaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Juez'),
      ),
      body: const Center(
        child: Text('Aquí va la lógica para los jueces'),
      ),
    );
  }
}
