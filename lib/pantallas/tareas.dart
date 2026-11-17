import 'package:flutter/material.dart';
import '../database_helper.dart'; // 1. Importamos tu base de datos

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _EstadoTareas();
}

class _EstadoTareas extends State<PantallaTareas> {
  
  List<Map<String, dynamic>> listaTareas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarTareas(); // Carga los datos apenas se abre la pantalla
  }

  // Lee todas las tareas de SQLite y actualiza la pantalla
  Future<void> _cargarTareas() async {
    final datos = await DatabaseHelper.instance.obtenerTareas();
    setState(() {
      listaTareas = datos;
      _cargando = false;
    });
  }

  // Actualiza la palomita en SQLite y recarga la lista
  Future<void> _cambiarEstado(int id, bool? valor) async {
    final nuevoEstado = valor ?? false;
    await DatabaseHelper.instance.actualizarEstado(id, nuevoEstado);
    _cargarTareas();
  }

  // Borra las tareas con palomita al presionar "Cumplir"
  Future<void> _cumplirTareas() async {
    await DatabaseHelper.instance.eliminarCompletadas();
    _cargarTareas();
  }

  Map<String, Color> _obtenerColores(String importancia) {
    switch (importancia) {
      case 'Alta':
        return {
          'fondo': const Color(0xFFFFEBEE),
          'circulo': const Color(0xFFE53935),
        };
      case 'Media':
        return {
          'fondo': const Color(0xFFFFFDE7),
          'circulo': const Color(0xFFFBC02D),
        };
      case 'Baja':
      default:
        return {
          'fondo': const Color(0xFFE0F7FA),
          'circulo': const Color(0xFF00897B),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        backgroundColor: const Color(0xFF648BC1),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: _cumplirTareas, // Ejecuta el DELETE en SQLite
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cumplir',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : listaTareas.isEmpty
              ? const Center(
                  child: Text(
                    'No hay tareas pendientes',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: listaTareas.length,
                  itemBuilder: (context, posicion) {
                    final tarea = listaTareas[posicion];
                    final colores = _obtenerColores(tarea['importancia']);
                    final String descripcion = tarea['descripcion'] ?? '';
                    final bool tieneDescripcion = descripcion.trim().isNotEmpty;
                    // En SQLite 1 es true y 0 es false
                    final bool estaCompletada = tarea['completada'] == 1;

                    return Card(
                      color: colores['fondo'],
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: tieneDescripcion
                          ? ExpansionTile(
                              shape: const Border(),
                              collapsedShape: const Border(),
                              leading: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: colores['circulo'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(
                                tarea['nombre'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: estaCompletada
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: Checkbox(
                                value: estaCompletada,
                                activeColor: colores['circulo'],
                                onChanged: (valor) {
                                  _cambiarEstado(tarea['id'], valor);
                                },
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(50, 0, 20, 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      descripcion,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListTile(
                              leading: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: colores['circulo'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(
                                tarea['nombre'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: estaCompletada
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: Checkbox(
                                value: estaCompletada,
                                activeColor: colores['circulo'],
                                onChanged: (valor) {
                                  _cambiarEstado(tarea['id'], valor);
                                },
                              ),
                            ),
                    );
                  },
                ),
    );
  }
}
