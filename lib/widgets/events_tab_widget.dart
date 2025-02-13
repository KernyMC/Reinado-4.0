import 'package:flutter/material.dart';

class EventsTab extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> events;
  final void Function(int eventId, String name, double peso, String estado) onUpdateEvent;
  final void Function(int eventId) onDeleteEvent;

  const EventsTab({
    super.key,
    required this.isLoading,
    required this.events,
    required this.onUpdateEvent,
    required this.onDeleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              "${e['EVENTO_NOMBRE']} (ID: ${e['EVENTO_ID']})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Peso: ${e['EVENTO_PESO']} - Estado: ${e['EVENTO_ESTADO']}",
              style: TextStyle(
                color: e['EVENTO_ESTADO'] == 'si' ? Colors.green : Colors.red,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Editar evento',
                  onPressed: () => _showUpdateEventDialog(context, e),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Eliminar evento',
                  onPressed: () => _showDeleteConfirmationDialog(context, e),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateEventDialog(BuildContext context, Map<String, dynamic> eventData) {
    final TextEditingController nameCtrl = TextEditingController(text: eventData['EVENTO_NOMBRE']);
    final TextEditingController pesoCtrl = TextEditingController(text: eventData['EVENTO_PESO'].toString());
    String selectedEstado = eventData['EVENTO_ESTADO'] ?? 'no';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Editar Evento (ID: ${eventData['EVENTO_ID']})"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pesoCtrl,
              decoration: const InputDecoration(
                labelText: 'Peso',
                border: OutlineInputBorder(),
                filled: true,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
                filled: true,
              ),
              value: selectedEstado,
              items: const [
                DropdownMenuItem(value: 'si', child: Text('Activo')),
                DropdownMenuItem(value: 'no', child: Text('Inactivo')),
              ],
              onChanged: (value) {
                selectedEstado = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final peso = double.tryParse(pesoCtrl.text.trim()) ?? 0.0;
              if (name.isNotEmpty) {
                onUpdateEvent(eventData['EVENTO_ID'], name, peso, selectedEstado);
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Está seguro que desea eliminar el evento ${event['EVENTO_NOMBRE']}?'
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
            onPressed: () {
              onDeleteEvent(event['EVENTO_ID']);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
