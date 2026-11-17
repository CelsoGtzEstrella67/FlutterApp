import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // asegura solo una conexión abierta a la vez
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mis_tareas.db');
    return _database!;
  }

  // Crea o abre el archivo de la base de datos
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearTabla,
    );
  }

  // Crea la tabla con las columnas exactas que definimos
  Future _crearTabla(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tareas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        importancia TEXT NOT NULL,
        descripcion TEXT,
        completada INTEGER NOT NULL
      )
    ''');
  }

  // Isertar (agregar.dart)
  Future<int> insertarTarea(Map<String, dynamic> tarea) async {
    final db = await instance.database;
    return await db.insert('tareas', tarea);
  }

  // Obtener Lista (tareas.dart)
  Future<List<Map<String, dynamic>>> obtenerTareas() async {
    final db = await instance.database;
    return await db.query('tareas', orderBy: 'id DESC'); // Las más nuevas arriba
  }

  // ACTUALIZAR PALOMITA
  Future<int> actualizarEstado(int id, bool completada) async {
    final db = await instance.database;
    return await db.update(
      'tareas',
      {'completada': completada ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar (Para el botón "Cumplir")
  Future<int> eliminarCompletadas() async {
    final db = await instance.database;
    return await db.delete(
      'tareas',
      where: 'completada = ?',
      whereArgs: [1],
    );
  }
}
