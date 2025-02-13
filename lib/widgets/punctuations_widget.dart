import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PunctuationsWidget extends StatefulWidget {
  const PunctuationsWidget({super.key});

  @override
  _PunctuationsWidgetState createState() => _PunctuationsWidgetState();
}

class _PunctuationsWidgetState extends State<PunctuationsWidget> {
  List<Map<String, dynamic>> candidatas = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchCandidatas();

    // Actualizar cada 2 segundos
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchCandidatas();
    });
  }

  Future<void> fetchCandidatas() async {
    try {
      final data = await ApiService.get('/candidatas/topCandidatas');
      final rawList = List<Map<String, dynamic>>.from(data);

      // Ordenar desc por CAND_PUNTUACION_TOTAL
      rawList.sort((a, b) {
        final notaB = (b['CAND_PUNTUACION_TOTAL'] ?? 0).toDouble();
        final notaA = (a['CAND_PUNTUACION_TOTAL'] ?? 0).toDouble();
        return notaB.compareTo(notaA);
      });

      setState(() {
        candidatas = rawList;
      });
    } catch (error) {
      print('Error fetching candidates: $error');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Puntuaciones de Candidatas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Lista de candidatas con scroll
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5, // Altura máxima del 50% de la pantalla
            ),
            child: SingleChildScrollView(
              child: Column(
                children: candidatas.map((candidate) {
                  final index = candidatas.indexOf(candidate) + 1;
                  final puntuacion = (candidate['CAND_PUNTUACION_TOTAL'] ?? 0).toDouble();
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: index <= 3 ? Colors.green.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: index <= 3 ? Colors.green : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: index <= 3 ? Colors.green : Colors.grey,
                          child: Text(
                            '$index',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${candidate['CAND_NOMBRE1']} ${candidate['CAND_APELLIDOPATERNO']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: index <= 3 ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Puntuación: ${puntuacion.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: index <= 3 ? Colors.green : Colors.grey,
                                  fontWeight: index <= 3 ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}