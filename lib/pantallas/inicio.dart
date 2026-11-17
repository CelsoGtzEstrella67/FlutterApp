
import 'package:flutter/material.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: const Color(0xFF648BC1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment,
              size: 80,
              color: Color(0xFF648BC1),
            ),

            const SizedBox(height: 20),

            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Organiza tus actividades de manera sencilla',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/tareas');
              },
              icon: const Icon(Icons.list),
              label: const Text('Ver mis tareas'),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/agregar');
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/informacion');
              },
              child: const Text('Información'),
            ),
          ],
        ),
      ),
    );
  }
}
