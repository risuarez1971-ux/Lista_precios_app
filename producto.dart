// lib/models/producto.dart

class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String? codigoBarras;
  final String? descripcion;
  final int cantidad;
  final DateTime fechaCreacion;
  final DateTime? fechaModificacion;
  final String? categoria;
  final double? precioCompra;
  final String? proveedor;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.codigoBarras,
    this.descripcion,
    this.cantidad = 0,
    required this.fechaCreacion,
    this.fechaModificacion,
    this.categoria,
    this.precioCompra,
    this.proveedor,
  });

  // Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'codigoBarras': codigoBarras,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaModificacion': fechaModificacion?.toIso8601String(),
      'categoria': categoria,
      'precioCompra': precioCompra,
      'proveedor': proveedor,
    };
  }

  // Crear desde Map (SQLite)
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      precio: (map['precio'] as num).toDouble(),
      codigoBarras: map['codigoBarras'] as String?,
      descripcion: map['descripcion'] as String?,
      cantidad: map['cantidad'] as int? ?? 0,
      fechaCreacion: DateTime.parse(map['fechaCreacion'] as String),
      fechaModificacion: map['fechaModificacion'] != null
          ? DateTime.parse(map['fechaModificacion'] as String)
          : null,
      categoria: map['categoria'] as String?,
      precioCompra: map['precioCompra'] != null 
          ? (map['precioCompra'] as num).toDouble() 
          : null,
      proveedor: map['proveedor'] as String?,
    );
  }

  // Copiar con modificaciones
  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    String? codigoBarras,
    String? descripcion,
    int? cantidad,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
    String? categoria,
    double? precioCompra,
    String? proveedor,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      descripcion: descripcion ?? this.descripcion,
      cantidad: cantidad ?? this.cantidad,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      categoria: categoria ?? this.categoria,
      precioCompra: precioCompra ?? this.precioCompra,
      proveedor: proveedor ?? this.proveedor,
    );
  }

  // Calcular margen de ganancia
  double? get margenGanancia {
    if (precioCompra == null || precioCompra == 0) return null;
    return ((precio - precioCompra!) / precioCompra!) * 100;
  }

  // Valor total del inventario
  double get valorInventario => precio * cantidad;

  @override
  String toString() {
    return 'Producto(id: $id, nombre: $nombre, precio: $precio, cantidad: $cantidad)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Producto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
