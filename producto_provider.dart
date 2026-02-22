// lib/providers/producto_provider.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/producto.dart';
import '../services/database_service.dart';

class ProductoProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _categoriaFiltro;

  List<Producto> get productos => _productosFiltrados;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get categoriaFiltro => _categoriaFiltro;

  // Inicializar y cargar productos
  Future<void> inicializar() async {
    await cargarProductos();
  }

  // Cargar todos los productos
  Future<void> cargarProductos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _productos = await _db.obtenerTodosLosProductos();
      _aplicarFiltros();
    } catch (e) {
      debugPrint('Error cargando productos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Aplicar filtros
  void _aplicarFiltros() {
    _productosFiltrados = _productos.where((producto) {
      // Filtro por búsqueda
      final cumpleBusqueda = _searchQuery.isEmpty ||
          producto.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (producto.codigoBarras?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (producto.descripcion?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      // Filtro por categoría
      final cumpleCategoria = _categoriaFiltro == null ||
          producto.categoria == _categoriaFiltro;

      return cumpleBusqueda && cumpleCategoria;
    }).toList();
  }

  // Buscar productos
  void buscar(String query) {
    _searchQuery = query;
    _aplicarFiltros();
    notifyListeners();
  }

  // Filtrar por categoría
  void filtrarPorCategoria(String? categoria) {
    _categoriaFiltro = categoria;
    _aplicarFiltros();
    notifyListeners();
  }

  // Limpiar filtros
  void limpiarFiltros() {
    _searchQuery = '';
    _categoriaFiltro = null;
    _aplicarFiltros();
    notifyListeners();
  }

  // Buscar por código de barras
  Future<Producto?> buscarPorCodigoBarras(String codigoBarras) async {
    return await _db.obtenerProductoPorCodigo(codigoBarras);
  }

  // Agregar producto
  Future<bool> agregarProducto(Producto producto) async {
    try {
      await _db.crearProducto(producto);
      await cargarProductos();
      return true;
    } catch (e) {
      debugPrint('Error agregando producto: $e');
      return false;
    }
  }

  // Crear nuevo producto
  Future<bool> crearProducto({
    required String nombre,
    required double precio,
    String? codigoBarras,
    String? descripcion,
    int cantidad = 0,
    String? categoria,
    double? precioCompra,
    String? proveedor,
  }) async {
    final producto = Producto(
      id: const Uuid().v4(),
      nombre: nombre,
      precio: precio,
      codigoBarras: codigoBarras,
      descripcion: descripcion,
      cantidad: cantidad,
      fechaCreacion: DateTime.now(),
      categoria: categoria,
      precioCompra: precioCompra,
      proveedor: proveedor,
    );

    return await agregarProducto(producto);
  }

  // Actualizar producto
  Future<bool> actualizarProducto(Producto producto) async {
    try {
      final productoActualizado = producto.copyWith(
        fechaModificacion: DateTime.now(),
      );
      await _db.actualizarProducto(productoActualizado);
      await cargarProductos();
      return true;
    } catch (e) {
      debugPrint('Error actualizando producto: $e');
      return false;
    }
  }

  // Eliminar producto
  Future<bool> eliminarProducto(String id) async {
    try {
      await _db.eliminarProducto(id);
      await cargarProductos();
      return true;
    } catch (e) {
      debugPrint('Error eliminando producto: $e');
      return false;
    }
  }

  // Ajustar inventario
  Future<bool> ajustarInventario(String id, int ajuste) async {
    try {
      await _db.ajustarInventario(id, ajuste);
      await cargarProductos();
      return true;
    } catch (e) {
      debugPrint('Error ajustando inventario: $e');
      return false;
    }
  }

  // Establecer cantidad exacta
  Future<bool> establecerCantidad(String id, int cantidad) async {
    try {
      await _db.actualizarCantidad(id, cantidad);
      await cargarProductos();
      return true;
    } catch (e) {
      debugPrint('Error estableciendo cantidad: $e');
      return false;
    }
  }

  // Obtener producto por ID
  Producto? obtenerProductoPorId(String id) {
    try {
      return _productos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtener categorías
  Future<List<String>> obtenerCategorias() async {
    return await _db.obtenerCategorias();
  }

  // Obtener estadísticas
  Future<Map<String, dynamic>> obtenerEstadisticas() async {
    return await _db.obtenerEstadisticas();
  }

  // Productos con bajo stock
  Future<List<Producto>> obtenerProductosBajoStock(int limite) async {
    return await _db.obtenerProductosBajoStock(limite);
  }

  // Importar productos
  Future<bool> importarProductos(List<Producto> productos) async {
    try {
      await _db.importarProductos(productos);
      await cargarProductos();
      return true;
    } catch (e) {
      debugPrint('Error importando productos: $e');
      return false;
    }
  }

  // Limpiar base de datos
  Future<void> limpiarBaseDatos() async {
    try {
      await _db.limpiarBaseDatos();
      await cargarProductos();
    } catch (e) {
      debugPrint('Error limpiando base de datos: $e');
    }
  }

  @override
  void dispose() {
    _db.cerrar();
    super.dispose();
  }
}
