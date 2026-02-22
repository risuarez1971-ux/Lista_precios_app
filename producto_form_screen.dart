// lib/screens/producto_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';

class ProductoFormScreen extends StatefulWidget {
  final String? productoId;
  final String? codigoBarrasInicial;

  const ProductoFormScreen({
    Key? key,
    this.productoId,
    this.codigoBarrasInicial,
  }) : super(key: key);

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _codigoBarrasController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _proveedorController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.productoId != null;
    
    if (widget.codigoBarrasInicial != null) {
      _codigoBarrasController.text = widget.codigoBarrasInicial!;
    }

    if (_isEditing) {
      _cargarProducto();
    }
  }

  void _cargarProducto() {
    final provider = context.read<ProductoProvider>();
    final producto = provider.obtenerProductoPorId(widget.productoId!);

    if (producto != null) {
      _nombreController.text = producto.nombre;
      _precioController.text = producto.precio.toString();
      _codigoBarrasController.text = producto.codigoBarras ?? '';
      _descripcionController.text = producto.descripcion ?? '';
      _cantidadController.text = producto.cantidad.toString();
      _categoriaController.text = producto.categoria ?? '';
      _precioCompraController.text = producto.precioCompra?.toString() ?? '';
      _proveedorController.text = producto.proveedor ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _codigoBarrasController.dispose();
    _descripcionController.dispose();
    _cantidadController.dispose();
    _categoriaController.dispose();
    _precioCompraController.dispose();
    _proveedorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
        backgroundColor: _isEditing ? Colors.blue[600] : Colors.green[600],
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _eliminarProducto,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Nombre del producto
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del producto *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Precio
                  TextFormField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      labelText: 'Precio de venta *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      prefixText: '\$',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El precio es requerido';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Ingrese un precio válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Código de barras
                  TextFormField(
                    controller: _codigoBarrasController,
                    decoration: InputDecoration(
                      labelText: 'Código de barras',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          // Abrir escáner
                        },
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Cantidad en inventario
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad en inventario',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final cantidad = int.tryParse(value);
                        if (cantidad == null || cantidad < 0) {
                          return 'Ingrese una cantidad válida';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Categoría
                  TextFormField(
                    controller: _categoriaController,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Precio de compra
                  TextFormField(
                    controller: _precioCompraController,
                    decoration: const InputDecoration(
                      labelText: 'Precio de compra',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money_off),
                      prefixText: '\$',
                      helperText: 'Para calcular margen de ganancia',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16),

                  // Proveedor
                  TextFormField(
                    controller: _proveedorController,
                    decoration: const InputDecoration(
                      labelText: 'Proveedor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 24),

                  // Botón de guardar
                  ElevatedButton(
                    onPressed: _guardarProducto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEditing ? Colors.blue[600] : Colors.green[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'Guardar Cambios' : 'Crear Producto',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<ProductoProvider>();
    
    final nombre = _nombreController.text.trim();
    final precio = double.parse(_precioController.text.trim());
    final codigoBarras = _codigoBarrasController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;
    final categoria = _categoriaController.text.trim();
    final precioCompraStr = _precioCompraController.text.trim();
    final precioCompra = precioCompraStr.isNotEmpty ? double.tryParse(precioCompraStr) : null;
    final proveedor = _proveedorController.text.trim();

    bool exito;

    if (_isEditing) {
      final productoActual = provider.obtenerProductoPorId(widget.productoId!);
      if (productoActual == null) {
        setState(() => _isLoading = false);
        return;
      }

      final productoActualizado = productoActual.copyWith(
        nombre: nombre,
        precio: precio,
        codigoBarras: codigoBarras.isNotEmpty ? codigoBarras : null,
        descripcion: descripcion.isNotEmpty ? descripcion : null,
        cantidad: cantidad,
        categoria: categoria.isNotEmpty ? categoria : null,
        precioCompra: precioCompra,
        proveedor: proveedor.isNotEmpty ? proveedor : null,
      );

      exito = await provider.actualizarProducto(productoActualizado);
    } else {
      exito = await provider.crearProducto(
        nombre: nombre,
        precio: precio,
        codigoBarras: codigoBarras.isNotEmpty ? codigoBarras : null,
        descripcion: descripcion.isNotEmpty ? descripcion : null,
        cantidad: cantidad,
        categoria: categoria.isNotEmpty ? categoria : null,
        precioCompra: precioCompra,
        proveedor: proveedor.isNotEmpty ? proveedor : null,
      );
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Producto actualizado' : 'Producto creado',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar el producto'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _eliminarProducto() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _isLoading = true);

    final provider = context.read<ProductoProvider>();
    final exito = await provider.eliminarProducto(widget.productoId!);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto eliminado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar el producto'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
