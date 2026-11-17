import 'package:flutter/material.dart';
import '../database_helper.dart'; // 1. Importamos tu base de datos

class PantallaAgregar extends StatefulWidget {
  const PantallaAgregar({super.key});

  @override
  State<PantallaAgregar> createState() => _EstadoPantallaAgregar();
}

class _EstadoPantallaAgregar extends State<PantallaAgregar> {
  final _llaveFormulario = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  String? _importanciaSeleccionada;
  final List<String> _nivelesImportancia = ['Alta', 'Media', 'Baja'];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // async para poder usar await al guardar en SQLite
  Future<void> _guardarYRegresar() async {
    if (_llaveFormulario.currentState!.validate()) {
      
      final nuevaTarea = {
        'nombre': _nombreController.text.trim(),
        'importancia': _importanciaSeleccionada!,
        'descripcion': _descripcionController.text.trim(),
        'completada': 0, // 0 significa false (sin palomita al crearse)
      };

      // Guardamos en SQLite
      await DatabaseHelper.instance.insertarTarea(nuevaTarea);

      // Verificamos que la pantalla siga abierta antes de regresar
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar tarea'),
        backgroundColor: const Color(0xFF648BC1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _llaveFormulario,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la tarea *',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Por favor escribe el nombre de la tarea';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _importanciaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Importancia *',
                  border: OutlineInputBorder(),
                ),
                items: _nivelesImportancia.map((nivel) {
                  return DropdownMenuItem(
                    value: nivel,
                    child: Text(nivel),
                  );
                }).toList(),
                onChanged: (nuevoValor) {
                  setState(() {
                    _importanciaSeleccionada = nuevoValor;
                  });
                },
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Selecciona un nivel de importancia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _guardarYRegresar,
        backgroundColor: const Color(0xFF648BC1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.check),
        label: const Text('Guardar'),
      ),
    );
  }
}
