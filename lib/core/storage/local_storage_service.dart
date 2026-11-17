import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._init();
  static Database? _database;

  LocalStorageService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('melodyk.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS usuarios');
        await db.execute('DROP TABLE IF EXISTS productos');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabla Usuarios (incluye bandera de administrador)
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        usuario TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        es_admin INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Tabla Productos
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo_barras TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        categoria TEXT NOT NULL,
        marca TEXT NOT NULL,
        precio_compra REAL NOT NULL,
        precio_venta REAL NOT NULL,
        existencia INTEGER NOT NULL,
        stock_minimo INTEGER NOT NULL
      )
    ''');

    // Usuario Administrador inicial
    await db.insert('usuarios', {
      'nombre': 'Administrador Principal',
      'usuario': 'karly',
      'password': '127',
      'es_admin': 1,
    });
  }

  // --- MÓDULO DE USUARIOS ---
  Future<Map<String, dynamic>?> validarCredenciales(String usuario, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'usuarios',
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final db = await instance.database;
    return await db.query('usuarios', orderBy: 'id ASC');
  }

  Future<int> insertarUsuario(Map<String, dynamic> usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario);
  }

  Future<int> actualizarUsuario(int id, Map<String, dynamic> usuario) async {
    final db = await instance.database;
    return await db.update('usuarios', usuario, where: 'id = ?', whereArgs: [id]);
  }

  // --- MÓDULO DE PRODUCTOS ---
  Future<int> insertarProducto(Map<String, dynamic> producto) async {
    final db = await instance.database;
    return await db.insert('productos', producto);
  }

  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final db = await instance.database;
    return await db.query('productos', orderBy: 'nombre ASC');
  }

  Future<List<Map<String, dynamic>>> buscarProductos(String query) async {
    final db = await instance.database;
    return await db.query(
      'productos',
      where: 'nombre LIKE ? OR categoria LIKE ? OR codigo_barras LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
  }

  Future<int> actualizarProducto(int id, Map<String, dynamic> producto) async {
    final db = await instance.database;
    return await db.update('productos', producto, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> eliminarProducto(int id) async {
    final db = await instance.database;
    return await db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }
}