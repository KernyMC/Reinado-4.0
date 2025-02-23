import 'dart:async'; // Importante para el Timer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import './voting_screen.dart';

class PublicScreen extends StatefulWidget {
  const PublicScreen({super.key});

  @override
  State<PublicScreen> createState() => _PublicScreenState();
}

class _PublicScreenState extends State<PublicScreen> {
  bool isLoading = true;
  bool votacionHabilitada = false;
  String mensaje = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkVotacionStatus();
    // Verificar estado cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkVotacionStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> checkVotacionStatus() async {
    try {
      final response = await ApiService.get('/cali/checkVotacionPublica');
      if (mounted) {
        setState(() {
          votacionHabilitada = response['enabled'];
          mensaje = response['message'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          votacionHabilitada = false;
          mensaje = 'Por favor, espere mientras se habilita la votación...';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Validar que el usuario esté autenticado y sea tipo 'usuario'
    if (authProvider.user == null || authProvider.user!.rol != 'usuario') {
      return const Scaffold(
        body: Center(
          child: Text('No tienes permiso para acceder a esta página.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votación Pública'),
        backgroundColor: const Color(0xFF0D4F02),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4F02), Color(0xFF002401)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!votacionHabilitada)
                  const Icon(
                    Icons.access_time,
                    size: 80,
                    color: Colors.white,
                  ),
                const SizedBox(height: 20),
                Text(
                  votacionHabilitada 
                    ? '¡La votación está abierta!'
                    : 'Esperando el inicio de la votación...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                if (votacionHabilitada)
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VotingScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al cargar la pantalla de votación: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.how_to_vote),
                    label: const Text('INICIAR VOTACIÓN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0D4F02),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (!votacionHabilitada)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}