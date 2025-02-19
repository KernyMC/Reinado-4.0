import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EventAdministratorWidget extends StatefulWidget {
  final Function() onVotingFinished;

  const EventAdministratorWidget({
    super.key,
    required this.onVotingFinished,
  });

  @override
  State<EventAdministratorWidget> createState() => _EventAdministratorWidgetState();
}

class _EventAdministratorWidgetState extends State<EventAdministratorWidget> {
  Map<int, bool> eventStates = {
    1: false, // Traje Típico
    2: false, // Traje Gala
    3: false, // Preguntas
    4: false, // Público
  };

  @override
  void initState() {
    super.initState();
    fetchEventStates();
  }

  Future<void> fetchEventStates() async {
    try {
      final response = await ApiService.get('/evento/estado');
      if (mounted) {
        setState(() {
          eventStates = Map<int, bool>.from(
            response.map((key, value) => MapEntry(key, value == 'si')),
          );
        });
      }
    } catch (error) {
      print('Error fetching event states: $error');
    }
  }

  Future<void> toggleEventState(int eventId, String state) async {
    try {
      await ApiService.put('/user/cambio/$state/$eventId', {});
      if (mounted) {
        setState(() {
          eventStates[eventId] = state == 'si';
        });
      }
    } catch (error) {
      print('Error toggling event state: $error');
    }
  }

  Future<void> resetVoting() async {
    try {
      await ApiService.post('/user/limpiarVotaciones', {});
    } catch (error) {
      print('Error resetting voting: $error');
    }
  }

  Future<void> handleGenerateReport(BuildContext context) async {
    Navigator.pushNamed(context, '/report');
  }

  Future<void> handleCloseVoting() async {
    try {
      // 1) Cerrar votaciones
      await ApiService.put('/cali/cerrarVotaciones', {});
      print("Todos los eventos han sido cerrados (EVENTO_ESTADO = 'no').");

      // 2) Actualizar PUNTAJE FINAL
      await ApiService.put('/cali/actualizarPuntajeFinal', {});
      print("Puntaje final de candidatas actualizado correctamente.");
    } catch (error) {
      print('Error closing voting: $error');
    }
  }

  void showCloseVotingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de querer cerrar las votaciones?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                handleCloseVoting();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventButtons(int eventId, String eventName) {
    final bool isActive = eventStates[eventId] ?? false;

    return Column(
      children: [
        Text(
          'Etapa $eventId ($eventName):',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? Colors.grey : Colors.lightGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 40),
              ),
              onPressed: isActive ? null : () => toggleEventState(eventId, 'si'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isActive ? Icons.check_circle : Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(isActive ? 'Activo' : 'Empezar'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: !isActive ? Colors.grey : Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 40),
              ),
              onPressed: !isActive ? null : () => toggleEventState(eventId, 'no'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(!isActive ? Icons.block : Icons.stop),
                  const SizedBox(width: 8),
                  Text(!isActive ? 'Inactivo' : 'Cerrar'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Etapas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Eventos
          _buildEventButtons(1, 'Traje Típico'),
          _buildEventButtons(2, 'Traje de Gala'),
          _buildEventButtons(3, 'Preguntas'),
          _buildEventButtons(4, 'Público'),
          const SizedBox(height: 24),

          // Botones de acción
          Column(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => showCloseVotingDialog(context),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        minWidth: 88,
                        minHeight: 40,
                      ),
                      child: const Text(
                        '⛔ Cerrar Votaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          '¿Estás seguro de querer reiniciar la votación?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              resetVoting();
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFDC830), Color(0xFFF37335)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        minWidth: 88,
                        minHeight: 40,
                      ),
                      child: const Text(
                        '⟳ Reiniciar Votaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => handleGenerateReport(context),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        minWidth: 88,
                        minHeight: 40,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '📋 Generar Reporte ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
