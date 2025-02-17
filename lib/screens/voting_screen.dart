import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  bool isLoading = true;
  bool votacionHabilitada = false;
  bool isVoting = false;
  bool hasVoted = false;
  List<Map<String, dynamic>> candidatas = [];
  int? candidataSeleccionada;
  String mensaje = '';
  String error = '';

  @override
  void initState() {
    super.initState();
    verificarEstadoYCargarCandidatas();
    verificarVotoPrevio();
  }

  /// Extrae el nombre del archivo de la ruta completa
  String _extractFileName(String? filePath) {
    if (filePath == null || filePath.isEmpty) return 'candidate_placeholder.png';
    final normalizedPath = filePath.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  /// Construye el widget de imagen usando el nombre del archivo
  Widget _buildImage(String? fotoUrl) {
    final String fileName = _extractFileName(fotoUrl);
    final String assetPath = 'assets/candidatas/$fileName';

    return Image.asset(
      assetPath,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/candidatas/candidate_placeholder.png',
          height: 120,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Future<void> verificarEstadoYCargarCandidatas() async {
    try {
      final response = await ApiService.get('/cali/checkVotacionPublica');
      print('Estado de votación: $response'); // Debug completo de la respuesta

      if (response['enabled']) {
        final data = await ApiService.get('/barra');
        print('Candidatas cargadas: ${data.length}'); // Debug cantidad de candidatas

        if (mounted) {
          setState(() {
            votacionHabilitada = true;
            candidatas = List<Map<String, dynamic>>.from(data);
            isLoading = false;
            mensaje = '';
          });
        }
      } else {
        print('Votación deshabilitada. Razón: ${response['message']}'); // Debug razón
        if (mounted) {
          setState(() {
            votacionHabilitada = false;
            isLoading = false;
            mensaje = response['message'];
          });
        }
      }
    } catch (e) {
      print('Error completo: $e'); // Debug error completo
      if (mounted) {
        setState(() {
          isLoading = false;
          votacionHabilitada = false;
          mensaje = 'Error al verificar estado de votación';
        });
      }
    }
  }

  Future<void> verificarVotoPrevio() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        final yaVoto = await ApiService.checkUserVoted(authProvider.user!.id);
        if (mounted) {
          setState(() {
            hasVoted = yaVoto;
          });
        }
      }
    } catch (e) {
      print('Error verificando voto previo: $e');
    }
  }

  Future<void> enviarVoto(int usuarioId, int candidataId) async {
    if (isVoting || hasVoted) return;

    try {
      setState(() {
        isVoting = true;
        error = '';
      });

      await ApiService.submitVote(usuarioId, candidataId, 1);

      if (mounted) {
        setState(() {
          isVoting = false;
          hasVoted = true;
          mensaje = '¡Voto registrado exitosamente!';
        });
      }

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Gracias por tu voto!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isVoting = false;
          error = 'Error al registrar el voto: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // Un ÚNICO AppBar para toda la pantalla
      appBar: AppBar(
        title: const Text(
          'Votación Pública',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D4F02), Color(0xFF0D4F02)],
            ),
          ),
        ),
        elevation: 0,
      ),
      // El body maneja todos los estados en un solo lugar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4F02), Color(0xFF002401)],
          ),
        ),
        // Usamos un Builder o directamente un método para manejar los estados
        child: Builder(
          builder: (context) {
            // 1. Si el usuario NO está autenticado
            if (authProvider.user == null) {
              return const Center(
                child: Text(
                  'Usuario no autenticado',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // 2. Si estamos cargando
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            // 3. Si la votación NO está habilitada
            if (!votacionHabilitada) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        mensaje,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // 4. Si el usuario YA votó
            if (hasVoted) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 80,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '¡Gracias por tu voto!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ya has participado en esta votación',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }

            // 5. Si ninguna de las anteriores aplica, mostramos las candidatas
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Grid de candidatas
                  Expanded(
                    child: GridView.builder(
                      itemCount: candidatas.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final candidata = candidatas[index];
                        final int candidataId = candidata['CANDIDATA_ID'];
                        final nombre =
                            candidata['CAND_NOMBRE1'] ?? 'Nombre no disponible';
                        final apellido = candidata['CAND_APELLIDOPATERNO'] ??
                            'Apellido no disponible';
                        final departamento = candidata['DEPARTMENTO_NOMBRE'] ??
                            'Departamento no disponible';
                        final fotoUrl = candidata['FOTO_URL'];

                        return GestureDetector(
                          onTap: hasVoted
                              ? null
                              : () {
                                  setState(() {
                                    candidataSeleccionada = candidataId;
                                  });
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: candidataSeleccionada == candidataId
                                  ? const Color(0xFFE7F5E6) // Fondo verde claro si está seleccionada
                                  : Colors.white,
                              border: Border.all(
                                color: candidataSeleccionada == candidataId
                                    ? const Color(0xFF1E7D22) // Borde verde oscuro si seleccionada
                                    : Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16.0),
                                    ),
                                    child: _buildImage(fotoUrl),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$nombre $apellido',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        departamento,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botón para Enviar Voto
                  ElevatedButton(
                    onPressed: (isVoting || hasVoted || candidataSeleccionada == null)
                        ? null
                        : () => enviarVoto(
                              authProvider.user!.id,
                              candidataSeleccionada!,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D4F02),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: isVoting
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Enviar Voto',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
