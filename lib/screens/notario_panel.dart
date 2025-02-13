import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/notario_table_widget.dart';
import '../widgets/punctuations_widget.dart';
import '../widgets/event_administrator_widget.dart';
import '../widgets/feature_guard.dart';

class NotarioPanelScreen extends StatefulWidget {
  const NotarioPanelScreen({super.key});

  @override
  State<NotarioPanelScreen> createState() => _NotarioPanelScreenState();
}

class _NotarioPanelScreenState extends State<NotarioPanelScreen> {
  bool isVotingFinished = false;

  @override
  void initState() {
    super.initState();
    checkIfVotingFinished();
  }

  Future<void> checkIfVotingFinished() async {
    try {
      final data = await ApiService.get('/candidatas');
      final candidates = List<Map<String, dynamic>>.from(data);
      final allHaveNotaFinal = candidates.every((cand) =>
          cand['CAND_NOTA_FINAL'] != null && (cand['CAND_NOTA_FINAL'] as num) > 0);

      setState(() {
        isVotingFinished = allHaveNotaFinal;
      });
    } catch (e) {
      print('Error al verificar si la votación terminó: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al verificar el estado de la votación'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userFeatures = authProvider.features;

    if (authProvider.user == null || authProvider.user!.rol != 'notario') {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D4F02), Color(0xFF002401)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No tienes permiso para acceder a esta página.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0D4F02),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Volver al inicio'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel del Notario',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF0D4F02),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: checkIfVotingFinished,
            tooltip: 'Actualizar estado',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4F02), Color(0xFF002401)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (userFeatures.isEmpty)
                Card(
                  color: Colors.red.shade100,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No tienes permisos asignados.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFE8F5E9)],
                      ),
                    ),
                    child: FeatureGuard(
                      featureName: 'admin_eventos',
                      child: EventAdministratorWidget(
                        onVotingFinished: checkIfVotingFinished,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFE8F5E9)],
                      ),
                    ),
                    child: FeatureGuard(
                      featureName: 'tabla_notario',
                      child: const NotarioTableWidget(),
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFE8F5E9)],
                      ),
                    ),
                    child: FeatureGuard(
                      featureName: 'top_candidatas',
                      child: const PunctuationsWidget(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: checkIfVotingFinished,
        backgroundColor: const Color(0xFF0D4F02),
        tooltip: 'Actualizar estado',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
} 