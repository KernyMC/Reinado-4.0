import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa tu AuthProvider y ApiService
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

// Importar los 5 widgets:
import '../widgets/features_tab_widget.dart';
import '../widgets/roles_tab_widget.dart';
import '../widgets/events_tab_widget.dart';
import '../widgets/users_tab_widget.dart';
import '../widgets/candidatas_tab_widget.dart';

class SuperAdminPanelScreen extends StatefulWidget {
  const SuperAdminPanelScreen({super.key});

  @override
  State<SuperAdminPanelScreen> createState() => _SuperAdminPanelScreenState();
}

class _SuperAdminPanelScreenState extends State<SuperAdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ============================
  // Features
  // ============================
  bool isLoadingFeatures = false;
  List<Map<String, dynamic>> features = [];

  // ============================
  // Roles
  // ============================
  bool isLoadingRoles = false;
  List<Map<String, dynamic>> roles = [];

  // ============================
  // Eventos
  // ============================
  bool isLoadingEvents = false;
  List<Map<String, dynamic>> events = [];

  // ============================
  // Usuarios
  // ============================
  bool isLoadingUsers = false;
  List<Map<String, dynamic>> users = [];

  // ============================
  // Candidatas
  // ============================
  bool isLoadingCandidatas = false;
  List<Map<String, dynamic>> candidatas = [];

  // Agregar después de la sección de candidatas
  bool isLoadingCarreras = false;
  List<Map<String, dynamic>> carreras = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchUsers();
    fetchRoles();
    fetchEvents();
    fetchCandidatas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================================================
  // Sección: FEATURES
  // ==================================================
  Future<void> fetchFeatures() async {
    try {
      setState(() => isLoadingFeatures = true);

      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await ApiService.get('/features', token: token);

      setState(() {
        features = List<Map<String, dynamic>>.from(data);
        isLoadingFeatures = false;
      });
    } catch (e) {
      print('Error al obtener features: $e');
      setState(() => isLoadingFeatures = false);
    }
  }

  Future<void> createFeature(String name) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.post('/features', {
        'name': name,
        'enabled': 0,
      }, token: token);

      // Refrescamos la lista
      fetchFeatures();
    } catch (e) {
      print('Error al crear feature: $e');
    }
  }

  Future<void> updateFeature(int idFeature, bool enabled) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.put('/features/$idFeature', {
        'enabled': enabled ? 1 : 0
      }, token: token);

      // Actualizamos la lista local
      final idx = features.indexWhere((f) => f['id_feature'] == idFeature);
      if (idx != -1) {
        setState(() {
          features[idx]['enabled'] = enabled ? 1 : 0;
        });
      }
    } catch (e) {
      print('Error al actualizar feature: $e');
    }
  }

  // ==================================================
  // Sección: ROLES
  // ==================================================
  Future<void> fetchRoles() async {
    try {
      setState(() => isLoadingRoles = true);
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await ApiService.get('/user/with-features', token: token);
      setState(() {
        roles = List<Map<String, dynamic>>.from(data);
        isLoadingRoles = false;
      });
    } catch (e) {
      print('Error al obtener roles: $e');
      setState(() => isLoadingRoles = false);
    }
  }

  Future<void> createRole(String roleName) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.post('/roles', {
        'role_name': roleName
      }, token: token);
      fetchRoles();
    } catch (e) {
      print('Error al crear rol: $e');
    }
  }

  Future<void> updateRole(int roleId, String newName) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.put('/roles/$roleId', {
        'role_name': newName
      }, token: token);
      fetchRoles();
    } catch (e) {
      print('Error al actualizar rol: $e');
    }
  }

  Future<void> deleteRole(int roleId) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.delete('/roles/$roleId', token: token);
      fetchRoles();
    } catch (e) {
      print('Error al eliminar rol: $e');
    }
  }

  // ==================================================
  // Sección: EVENTOS
  // ==================================================
  Future<void> fetchEvents() async {
    try {
      setState(() => isLoadingEvents = true);

      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await ApiService.get('/events', token: token);

      setState(() {
        events = List<Map<String, dynamic>>.from(data);
        isLoadingEvents = false;
      });
    } catch (e) {
      print('Error al obtener eventos: $e');
      setState(() => isLoadingEvents = false);
    }
  }

  Future<void> createEvent(String name, double peso, String estado) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.post('/events', {
        'EVENTO_NOMBRE': name,
        'EVENTO_PESO': peso,
        'EVENTO_ESTADO': estado,
      }, token: token);
      fetchEvents();
    } catch (e) {
      print('Error al crear evento: $e');
    }
  }

  Future<void> updateEvent(int eventId, String name, double peso, String estado) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.put('/events/$eventId', {
        'EVENTO_NOMBRE': name,
        'EVENTO_PESO': peso,
        'EVENTO_ESTADO': estado
      }, token: token);
      fetchEvents();
    } catch (e) {
      print('Error al actualizar evento: $e');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.delete('/events/$eventId', token: token);
      fetchEvents();
    } catch (e) {
      print('Error al eliminar evento: $e');
    }
  }

  // ==================================================
  // Sección: USUARIOS
  // ==================================================
  Future<void> fetchUsers() async {
    try {
      setState(() => isLoadingUsers = true);
      final data = await ApiService.getAllUsers();
      setState(() {
        users = data;
        isLoadingUsers = false;
      });
    } catch (e) {
      print('Error al obtener usuarios: $e');
      setState(() => isLoadingUsers = false);
    }
  }

  Future<void> createUser(
    String username,
    String email,
    String password,
    String name,
    String lastname,
    String rol,
  ) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.post('/user', {
        'username': username,
        'email': email,
        'password': password,
        'name': name,
        'lastname': lastname,
        'role_id': rol // si tu BD usa 'rol' como string enum
      }, token: token);
      fetchUsers();
    } catch (e) {
      print('Error al crear usuario: $e');
    }
  }

  Future<void> updateUser(
    int userId,
    String email,
    String name,
    String lastname,
    String rol,
  ) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.updateUser(userId, email, name, lastname, rol);
      fetchUsers();
    } catch (e) {
      print('Error al actualizar usuario: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar usuario: $e')),
        );
      }
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.delete('/user/$userId', token: token);
      fetchUsers();
    } catch (e) {
      print('Error al eliminar usuario: $e');
    }
  }

  // ==================================================
  // Sección: CANDIDATAS
  // ==================================================
  Future<void> fetchCandidatas() async {
    try {
      setState(() => isLoadingCandidatas = true);
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await ApiService.get('/candidatas/all', token: token);
      setState(() {
        candidatas = List<Map<String, dynamic>>.from(data);
        isLoadingCandidatas = false;
      });
    } catch (e) {
      print('Error al obtener candidatas: $e');
      setState(() => isLoadingCandidatas = false);
    }
  }

  Future<void> createCandidata(Map<String, dynamic> candData) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.post('/candidatas', candData, token: token);
      fetchCandidatas();
    } catch (e) {
      print('Error al crear candidata: $e');
    }
  }

  Future<void> updateCandidata(int candidataId, Map<String, dynamic> candData) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.put('/candidatas/$candidataId', candData, token: token);
      fetchCandidatas();
    } catch (e) {
      print('Error al actualizar candidata: $e');
    }
  }

  Future<void> deleteCandidata(int candidataId) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.delete('/candidatas/$candidataId', token: token);
      fetchCandidatas();
    } catch (e) {
      print('Error al eliminar candidata: $e');
    }
  }

  // ==================================================
  // Build
  // ==================================================
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.user == null || authProvider.user!.rol != 'superadmin') {
      return const Scaffold(
        body: Center(child: Text('No tienes permiso para ver esta página.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel Súper Admin',
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
            onPressed: () {
              switch (_tabController.index) {
                case 0:
                  fetchRoles();
                  break;
                case 1:
                  fetchEvents();
                  break;
                case 2:
                  fetchUsers();
                  break;
                case 3:
                  fetchCandidatas();
                  break;
              }
            },
            tooltip: 'Actualizar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Roles'),
            Tab(text: 'Eventos'),
            Tab(text: 'Usuarios'),
            Tab(text: 'Candidatas'),
          ],
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
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                RolesTab(
                  isLoading: isLoadingRoles,
                  roles: roles,
                  features: features,
                  onCreateRole: createRole,
                  onUpdateRole: updateRole,
                  onDeleteRole: deleteRole,
                  onUpdateRoleFeatures: updateRoleFeatures,
                ),
                EventsTab(
                  isLoading: isLoadingEvents,
                  events: events,
                  onUpdateEvent: updateEvent,
                  onDeleteEvent: deleteEvent,
                ),
                UsersTab(
                  isLoading: isLoadingUsers,
                  users: users,
                  onCreateUser: createUser,
                  onUpdateUser: updateUser,
                  onDeleteUser: deleteUser,
                ),
                CandidatasTabWidget(
                  isLoading: isLoadingCandidatas,
                  candidatas: candidatas,
                  onCreateCandidata: createCandidata,
                  onUpdateCandidata: updateCandidata,
                  onDeleteCandidata: deleteCandidata,
                ),
              ],
            ),
            // Botón de actualizar en la esquina superior derecha
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'refresh_button',
                onPressed: () {
                  switch (_tabController.index) {
                    case 0:
                      fetchRoles();
                      break;
                    case 1:
                      fetchEvents();
                      break;
                    case 2:
                      fetchUsers();
                      break;
                    case 3:
                      fetchCandidatas();
                      break;
                  }
                },
                backgroundColor: const Color(0xFF0D4F02),
                mini: true,
                tooltip: 'Actualizar',
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index != 0 ? FloatingActionButton(
        heroTag: 'add_button',
        onPressed: () {
          switch (_tabController.index) {
            case 1:  // Eventos ahora es índice 1
              // Mostrar diálogo para agregar evento
              break;
            case 2:  // Usuarios ahora es índice 2
              // Mostrar diálogo para agregar usuario
              break;
            case 3:  // Candidatas ahora es índice 3
              // Mostrar diálogo para agregar candidata
              break;
          }
        },
        backgroundColor: const Color(0xFF0D4F02),
        tooltip: 'Agregar nuevo',
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
    );
  }

  Future<void> fetchCarreras() async {
    try {
      setState(() => isLoadingCarreras = true);
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await ApiService.get('/candidatas/carreras', token: token);
      setState(() {
        carreras = List<Map<String, dynamic>>.from(data);
        isLoadingCarreras = false;
      });
    } catch (e) {
      print('Error al obtener carreras: $e');
      setState(() => isLoadingCarreras = false);
    }
  }

  // Agregar el método para actualizar features de usuarios
  Future<void> updateRoleFeatures(int roleId, List<String> features) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ApiService.updateRoleFeatures(roleId, features);
    } catch (e) {
      print('Error al actualizar features del rol: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar features del rol: $e')),
        );
      }
    }
  }

  // Estilo para los botones de acción
  final ButtonStyle greenButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF0D4F02),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  final ButtonStyle redButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Estilo para los campos de texto
  final InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}