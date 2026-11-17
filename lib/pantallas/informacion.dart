
import 'package:flutter/material.dart';

class PantallaInformacion extends StatelessWidget {
  const PantallaInformacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
        backgroundColor: const Color(0xFF648BC1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Autores: Gladys Chumá Pérez y Celso Gutiérrez Estrella',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
