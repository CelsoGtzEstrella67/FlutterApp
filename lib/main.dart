import 'dart:io';
import 'package:flutter/material.dart';

import 'pantallas/inicio.dart';
import 'pantallas/tareas.dart';
import 'pantallas/agregar.dart';
import 'pantallas/informacion.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Tareas',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),

      initialRoute: '/',
    
      routes: {
        '/': (context) => const PantallaInicio(),
        '/tareas': (context) => const PantallaTareas(),
        '/agregar': (context) => const PantallaAgregar(),
        '/informacion': (context) => const PantallaInformacion(),
      },
    );
  }
}
