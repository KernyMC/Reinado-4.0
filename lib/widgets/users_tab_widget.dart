import 'package:flutter/material.dart';

class UsersTab extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> users;
  final void Function(
    String username,
    String email,
    String password,
    String name,
    String lastname,
    String rol,
  ) onCreateUser;
  final void Function(
    int userId,
    String email,
    String name,
    String lastname,
    String rol,
  ) onUpdateUser;
  final void Function(int userId) onDeleteUser;

  // Hacer la lista estática y constante
  static const List<String> roles = ['usuario', 'juez', 'juezx', 'admin', 'notario', 'superadmin'];

  const UsersTab({
    super.key,
    required this.isLoading,
    required this.users,
    required this.onCreateUser,
    required this.onUpdateUser,
    required this.onDeleteUser,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.white.withOpacity(0.1),
              child: ExpansionTile(
                title: Text(
                  user['username'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Rol: ${(user['rol'] ?? '').toUpperCase()}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Email:', user['email'] ?? ''),
                        const SizedBox(height: 8),
                        _buildInfoRow('Nombre:', user['name'] ?? ''),
                        const SizedBox(height: 8),
                        _buildInfoRow('Apellido:', user['lastname'] ?? ''),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                'Editar',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => _showUpdateUserDialog(context, user),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () => _showDeleteConfirmationDialog(context, user),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF0D4F02),
            onPressed: () => _showCreateUserDialog(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  //========================================================
  // CREAR Usuario
  //========================================================
  void _showCreateUserDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String username = '', email = '', password = '', name = '', lastname = '';
    String? selectedRol = 'usuario';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Crear Usuario',
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  label: 'Username',
                  onChanged: (value) => username = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  label: 'Email',
                  onChanged: (value) => email = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  label: 'Password',
                  onChanged: (value) => password = value,
                  obscureText: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  label: 'Nombre',
                  onChanged: (value) => name = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  label: 'Apellido',
                  onChanged: (value) => lastname = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedRol,
                  decoration: InputDecoration(
                    labelText: 'Rol',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) => selectedRol = value,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D4F02),
            ),
            child: const Text('Crear'),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                onCreateUser(
                  username,
                  email,
                  password,
                  name,
                  lastname,
                  selectedRol!,
                );
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String) onChanged,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }

  //========================================================
  // EDITAR Usuario
  //========================================================
  void _showUpdateUserDialog(BuildContext context, Map<String, dynamic> user) {
    final emailCtrl = TextEditingController(text: user['email'] ?? '');
    final nombreCtrl = TextEditingController(text: user['name'] ?? '');
    final apellidoCtrl = TextEditingController(text: user['lastname'] ?? '');
    String? selectedRol = user['rol'] ?? 'usuario'; // Usar String? para permitir nulos

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Editar Usuario (ID: ${user['id']})'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              DropdownButtonFormField<String>(
                value: selectedRol,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: const [
                  DropdownMenuItem(value: 'usuario', child: Text('Usuario')),
                  DropdownMenuItem(value: 'juez', child: Text('Juez')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'notario', child: Text('Notario')),
                  DropdownMenuItem(value: 'superadmin', child: Text('Super Admin')),
                ],
                onChanged: (value) {
                  selectedRol = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Guardar'),
            onPressed: () {
              final email = emailCtrl.text.trim();
              final nombre = nombreCtrl.text.trim();
              final apellido = apellidoCtrl.text.trim();
              final rol = selectedRol ?? user['rol'] ?? 'usuario'; // Mantener el rol actual si no cambia

              // Validar que al menos un campo tenga cambios
              if (email != user['email'] || 
                  nombre != user['name'] || 
                  apellido != user['lastname'] || 
                  rol != user['rol']) {
                
                onUpdateUser(
                  user['id'],
                  email,
                  nombre,
                  apellido,
                  rol,
                );
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No hay cambios para guardar'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Confirmar Eliminación',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Está seguro que desea eliminar al usuario ${user['username']}?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
            onPressed: () {
              onDeleteUser(user['id']);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
