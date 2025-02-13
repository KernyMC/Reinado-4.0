import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class NotarioTableWidget extends StatefulWidget {
  const NotarioTableWidget({super.key});

  @override
  State<NotarioTableWidget> createState() => _NotarioTableWidgetState();
}

class _NotarioTableWidgetState extends State<NotarioTableWidget> {
  List<Map<String, dynamic>> candidates = [];
  List<Map<String, dynamic>> judges = [];
  List<Map<String, dynamic>> votaciones = [];

  bool isLoadingCandidates = true;
  bool isLoadingJudges = true;
  bool isLoadingVotaciones = true;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
    fetchJudges();
    fetchVotaciones();

    // Configurar el temporizador para actualizar los datos cada 5 segundos
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchVotaciones();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchCandidates() async {
    try {
      final data = await ApiService.get('/candidatas');
      setState(() {
        candidates = List<Map<String, dynamic>>.from(data);
        isLoadingCandidates = false;
      });
    } catch (error) {
      print('Error fetching candidates: $error');
      setState(() {
        isLoadingCandidates = false;
      });
    }
  }

  Future<void> fetchJudges() async {
    try {
      final data = await ApiService.get('/candidatas/jueces');
      setState(() {
        judges = List<Map<String, dynamic>>.from(data);
        isLoadingJudges = false;
      });
    } catch (error) {
      print('Error fetching judges: $error');
      setState(() {
        isLoadingJudges = false;
      });
    }
  }

  Future<void> fetchVotaciones() async {
    try {
      // 1) obtengo el listado crudo de votaciones
      final data = await ApiService.get('/candidatas/votaciones');
      final rawList = List<Map<String, dynamic>>.from(data);

      // 2) pivotamos la info
      final Map<String, Map<String, dynamic>> pivoted = {};

      for (var v in rawList) {
        final candId = v['CANDIDATA_ID'];
        final userId = v['USUARIO_ID'];
        final eventoId = v['EVENTO_ID'];
        final votEstado = v['VOT_ESTADO']; // "si" o "no"
        final key = '$candId-$userId';

        if (!pivoted.containsKey(key)) {
          pivoted[key] = {
            'CANDIDATA_ID': candId,
            'USUARIO_ID': userId,
            'VOT_TRAJE_TIPICO': null,
            'VOT_TRAJE_GALA': null,
            'VOT_PREGUNTAS': null,
            // EVENTO 4? -> 'VOT_EVENTO_4': null,
          };
        }

        if (eventoId == 1) {
          pivoted[key]!['VOT_TRAJE_TIPICO'] = votEstado;
        } else if (eventoId == 2) {
          pivoted[key]!['VOT_TRAJE_GALA'] = votEstado;
        } else if (eventoId == 3) {
          pivoted[key]!['VOT_PREGUNTAS'] = votEstado;
        }
        // etc. si tienes evento 4
      }

      setState(() {
        votaciones = pivoted.values.toList();
        isLoadingVotaciones = false;
      });
    } catch (error) {
      print('Error fetching votaciones: $error');
      setState(() {
        isLoadingVotaciones = false;
      });
    }
  }

  Widget buildVotingCell(dynamic value) {
    final bool isPendiente = (value == null || value == 'no');
    return Container(
      padding: const EdgeInsets.all(8),
      color: isPendiente ? Colors.red.shade100 : Colors.green.shade100,
      child: Text(isPendiente ? 'Pendiente' : 'Votado'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final isStillLoading = isLoadingCandidates || isLoadingJudges || isLoadingVotaciones;
    if (isStillLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
            'Monitoreo de Votaciones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (candidates.isEmpty || judges.isEmpty || votaciones.isEmpty)
            const Text('No hay datos disponibles')
          else
            Column(
              children: candidates.map((candidate) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${candidate['CAND_NOMBRE1']} '
                          '${candidate['CAND_APELLIDOPATERNO']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Juez')),
                            DataColumn(label: Text('Traje Típico')),
                            DataColumn(label: Text('Traje de Gala')),
                            DataColumn(label: Text('Preguntas')),
                            // DataColumn(label: Text('Evento 4')), si deseas
                          ],
                          rows: judges.map((judge) {
                            final votacion = votaciones.firstWhere(
                              (v) =>
                                  v['CANDIDATA_ID'] == candidate['CANDIDATA_ID'] &&
                                  v['USUARIO_ID'] == judge['id'],
                              orElse: () => <String, dynamic>{},
                            );

                            return DataRow(
                              cells: [
                                DataCell(
                                  Text('${judge['id']} - ${judge['name']}'),
                                ),
                                DataCell(buildVotingCell(votacion['VOT_TRAJE_TIPICO'])),
                                DataCell(buildVotingCell(votacion['VOT_TRAJE_GALA'])),
                                DataCell(buildVotingCell(votacion['VOT_PREGUNTAS'])),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}