import 'package:flutter/material.dart';
import '../widgets/notario_table_widget.dart';
import '../widgets/punctuations_widget.dart'; // Importa el nuevo widget

class NotarioTableScreen extends StatelessWidget {
  const NotarioTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tabla del Notario',
          style: TextStyle(color: Colors.white), // Letras blancas
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Icono blanco
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        backgroundColor: const Color(0xFF0D4F02), // Mismo color que AdminPanelScreen
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D4F02),
              Color(0xFF002401),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              PunctuationsWidget(),
              NotarioTableWidget(),
            ],
          ),
        ),
      ),
    );
  }
}