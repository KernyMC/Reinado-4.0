import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class CandidatasTabWidget extends StatefulWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> candidatas;
  final Function(Map<String, dynamic>) onCreateCandidata;
  final Function(int, Map<String, dynamic>) onUpdateCandidata;
  final Function(int) onDeleteCandidata;

  const CandidatasTabWidget({
    super.key,
    required this.isLoading,
    required this.candidatas,
    required this.onCreateCandidata,
    required this.onUpdateCandidata,
    required this.onDeleteCandidata,
  });

  @override
  State<CandidatasTabWidget> createState() => _CandidatasTabWidgetState();
}

class _CandidatasTabWidgetState extends State<CandidatasTabWidget> {
  List<Map<String, dynamic>> carreras = [];
  bool isLoadingCarreras = false;

  @override
  void initState() {
    super.initState();
    fetchCarreras();
  }

  Future<void> fetchCarreras() async {
    try {
      setState(() => isLoadingCarreras = true);
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      print('Obteniendo carreras...');
      final data = await ApiService.get('/candidatas/carreras', token: token);
      print('Carreras obtenidas: $data');
      setState(() {
        carreras = List<Map<String, dynamic>>.from(data);
        isLoadingCarreras = false;
      });
    } catch (e) {
      print('Error al obtener carreras: $e');
      setState(() => isLoadingCarreras = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4F02), Color(0xFF002401)],
          ),
        ),
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestión de Candidatas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFF0D4F02).withOpacity(0.3),
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Nombre Completo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Carrera',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Acciones',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      rows: widget.candidatas.map((candidata) {
                        final nombreCompleto = '${candidata['CAND_NOMBRE1']} '
                            '${candidata['CAND_NOMBRE2'] ?? ''} '
                            '${candidata['CAND_APELLIDOPATERNO']} '
                            '${candidata['CAND_APELLIDOMATERNO']}'
                            .trim();

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                nombreCompleto,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Text(
                                candidata['CARRERA_NOMBRE'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    onPressed: () => _showAddEditDialog(
                                      context,
                                      candidata: candidata,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _showDeleteDialog(
                                      context,
                                      candidata['CANDIDATA_ID'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      /// Botón flotante para agregar candidatas
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D4F02),
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _showAddEditDialog(
    BuildContext context, {
    Map<String, dynamic>? candidata,
  }) async {
    String? selectedCarreraId = candidata?['CARRERA_ID']?.toString();

    final nombre1Controller =
        TextEditingController(text: candidata?['CAND_NOMBRE1']);
    final nombre2Controller =
        TextEditingController(text: candidata?['CAND_NOMBRE2']);
    final apellidoPaternoController =
        TextEditingController(text: candidata?['CAND_APELLIDOPATERNO']);
    final apellidoMaternoController =
        TextEditingController(text: candidata?['CAND_APELLIDOMATERNO']);
    final fechaNacimientoController =
        TextEditingController(text: candidata?['CAND_FECHANACIMIENTO']);
    final actividadExtraController =
        TextEditingController(text: candidata?['CAND_ACTIVIDAD_EXTRA']);
    final estaturaController =
        TextEditingController(text: candidata?['CAND_ESTATURA']?.toString());
    final hobbiesController =
        TextEditingController(text: candidata?['CAND_HOBBIES']);
    final idiomasController =
        TextEditingController(text: candidata?['CAND_IDIOMAS']);
    final colorOjosController =
        TextEditingController(text: candidata?['CAND_COLOROJOS']);
    final colorCabelloController =
        TextEditingController(text: candidata?['CAND_COLORCABELLO']);
    final logrosAcademicosController =
        TextEditingController(text: candidata?['CAND_LOGROS_ACADEMICOS']);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          candidata == null ? 'Nueva Candidata' : 'Editar Candidata',
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCarreraId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Carrera *',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black),
                  items: carreras.map((carrera) {
                    return DropdownMenuItem(
                      value: carrera['CARRERA_ID'].toString(),
                      child: Text(
                        '${carrera['DEPARTAMENTO_NOMBRE']} - ${carrera['CARRERA_NOMBRE']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCarreraId = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione una carrera';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: nombre1Controller,
                  label: 'Primer Nombre *',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: nombre2Controller,
                  label: 'Segundo Nombre',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: apellidoPaternoController,
                  label: 'Apellido Paterno *',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: apellidoMaternoController,
                  label: 'Apellido Materno *',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: fechaNacimientoController,
                  label: 'Fecha de Nacimiento',
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: actividadExtraController,
                  label: 'Actividad Extra',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: estaturaController,
                  label: 'Estatura',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: hobbiesController,
                  label: 'Hobbies',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: idiomasController,
                  label: 'Idiomas',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: colorOjosController,
                  label: 'Color de Ojos',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: colorCabelloController,
                  label: 'Color de Cabello',
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: logrosAcademicosController,
                  label: 'Logros Académicos',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D4F02),
            ),
            onPressed: () {
              if (selectedCarreraId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor seleccione una carrera'),
                  ),
                );
                return;
              }

              final data = {
                'CARRERA_ID': int.parse(selectedCarreraId!),
                'CAND_NOMBRE1': nombre1Controller.text,
                'CAND_NOMBRE2': nombre2Controller.text,
                'CAND_APELLIDOPATERNO': apellidoPaternoController.text,
                'CAND_APELLIDOMATERNO': apellidoMaternoController.text,
                'CAND_FECHANACIMIENTO': fechaNacimientoController.text,
                'CAND_ACTIVIDAD_EXTRA': actividadExtraController.text,
                'CAND_ESTATURA': double.tryParse(estaturaController.text),
                'CAND_HOBBIES': hobbiesController.text,
                'CAND_IDIOMAS': idiomasController.text,
                'CAND_COLOROJOS': colorOjosController.text,
                'CAND_COLORCABELLO': colorCabelloController.text,
                'CAND_LOGROS_ACADEMICOS': logrosAcademicosController.text,
              };

              if (candidata != null) {
                widget.onUpdateCandidata(candidata['CANDIDATA_ID'], data);
              } else {
                widget.onCreateCandidata(data);
              }

              Navigator.pop(context);
            },
            child: Text(
              candidata == null ? 'Crear' : 'Guardar',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int candidataId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Confirmar Eliminación',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Está seguro de que desea eliminar esta candidata?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
            onPressed: () {
              widget.onDeleteCandidata(candidataId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
