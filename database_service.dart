// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/producto.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('productos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        precio REAL NOT NULL,
        codigoBarras TEXT,
        descripcion TEXT,
        cantidad INTEGER DEFAULT 0,
        fechaCreacion TEXT NOT NULL,
        fechaModificacion TEXT,
        categoria TEXT,
        precioCompra REAL,
        proveedor TEXT
      )
    ''');

    // Índices para mejorar búsquedas
    await db.execute(
      'CREATE INDEX idx_nombre ON productos(nombre)',
    );
    await db.execute(
      'CREATE INDEX idx_codigoBarras ON productos(codigoBarras)',
    );
  }

  // CRUD Operations

  // Crear producto
  Future<Producto> crearProducto(Producto producto) async {
    final db = await database;
    await db.insert(
      'productos',
      producto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return producto;
  }

  // Leer producto por ID
  Future<Producto?> obtenerProducto(String id) async {
    final db = await database;
    final maps = await db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Producto.fromMap(maps.first);
  }

  // Leer producto por código de barras
  Future<Producto?> obtenerProductoPorCodigo(String codigoBarras) async {
    final db = await database;
    final maps = await db.query(
      'productos',
      where: 'codigoBarras = ?',
      whereArgs: [codigoBarras],
    );

    if (maps.isEmpty) return null;
    return Producto.fromMap(maps.first);
  }

  // Obtener todos los productos
  Future<List<Producto>> obtenerTodosLosProductos() async {
    final db = await database;
    final maps = await db.query('productos', orderBy: 'nombre ASC');
    return maps.map((map) => Producto.fromMap(map)).toList();
  }

  // Buscar productos
  Future<List<Producto>> buscarProductos(String query) async {
    final db = await database;
    final maps = await db.query(
      'productos',
      where: 'nombre LIKE ? OR codigoBarras LIKE ? OR descripcion LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'nombre ASC',
    );
    return maps.map((map) => Producto.fromMap(map)).toList();
  }

  // Actualizar producto
  Future<int> actualizarProducto(Producto producto) async {
    final db = await database;
    return db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  // Eliminar producto
  Future<int> eliminarProducto(String id) async {
    final db = await database;
    return await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Actualizar cantidad (para control de inventario)
  Future<int> actualizarCantidad(String id, int nuevaCantidad) async {
    final db = await database;
    return db.update(
      'productos',
      {'cantidad': nuevaCantidad},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Incrementar/Decrementar inventario
  Future<void> ajustarInventario(String id, int ajuste) async {
    final producto = await obtenerProducto(id);
    if (producto != null) {
      final nuevaCantidad = producto.cantidad + ajuste;
      await actualizarCantidad(id, nuevaCantidad);
    }
  }

  // Obtener productos con bajo stock
  Future<List<Producto>> obtenerProductosBajoStock(int limite) async {
    final db = await database;
    final maps = await db.query(
      'productos',
      where: 'cantidad <= ?',
      whereArgs: [limite],
      orderBy: 'cantidad ASC',
    );
    return maps.map((map) => Producto.fromMap(map)).toList();
  }

  // Obtener categorías únicas
  Future<List<String>> obtenerCategorias() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT categoria FROM productos WHERE categoria IS NOT NULL ORDER BY categoria',
    );
    return result.map((row) => row['categoria'] as String).toList();
  }

  // Estadísticas
  Future<Map<String, dynamic>> obtenerEstadisticas() async {
    final db = await database;
    
    final totalProductos = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM productos'),
    ) ?? 0;

    final valorInventario = (await db.rawQuery(
      'SELECT SUM(precio * cantidad) as total FROM productos',
    )).first['total'] as double? ?? 0.0;

    final productosBajoStock = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM productos WHERE cantidad <= 5'),
    ) ?? 0;

    return {
      'totalProductos': totalProductos,
      'valorInventario': valorInventario,
      'productosBajoStock': productosBajoStock,
    };
  }

  // Importar productos desde lista
  Future<void> importarProductos(List<Producto> productos) async {
    final db = await database;
    final batch = db.batch();
    
    for (final producto in productos) {
      batch.insert(
        'productos',
        producto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  // Limpiar base de datos
  Future<void> limpiarBaseDatos() async {
    final db = await database;
    await db.delete('productos');
  }

  // Cerrar base de datos
  Future<void> cerrar() async {
    final db = await _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
