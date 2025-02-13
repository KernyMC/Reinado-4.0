import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/notario_table_widget.dart';
import '../widgets/punctuations_widget.dart';
import '../widgets/event_administrator_widget.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool isVotingFinished = false;
  bool votingEnded = false;

  @override
  void initState() {
    super.initState();
    checkIfVotingFinished();
  }

  Future<void> checkIfVotingFinished() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await ApiService.get('/voting/status', token: token);
      setState(() {
        votingEnded = response['ended'] ?? false;
      });
    } catch (e) {
      if (!e.toString().contains('404')) {
        print('Error al verificar si la votación terminó: $e');
      }
      setState(() {
        votingEnded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userFeatures = authProvider.features;

    print('Features disponibles: $userFeatures'); // Para debugging

    if (authProvider.user == null || authProvider.user!.rol != 'admin') {
      return const Scaffold(
        body: Center(
          child: Text('No tienes permiso para acceder a esta página.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        title: const Text(
          'Panel de Administración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D4F02),
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
            children: [
              if (userFeatures.contains('admin_eventos'))
                EventAdministratorWidget(
                  onVotingFinished: checkIfVotingFinished,
                ),
              if (userFeatures.contains('top_candidatas'))
                const PunctuationsWidget(),
              if (userFeatures.contains('tabla_notario'))
                const NotarioTableWidget(),
              if (userFeatures.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No tienes permisos asignados.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}