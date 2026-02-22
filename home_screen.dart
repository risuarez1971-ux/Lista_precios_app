// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import '../widgets/producto_card.dart';
import '../widgets/search_bar_widget.dart';
import 'scanner_screen.dart';
import 'producto_form_screen.dart';
import 'import_screen.dart';
import 'estadisticas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar productos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoProvider>().inicializar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Precios',
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'El Torreón',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          // Botón de estadísticas
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstadisticasScreen(),
                ),
              );
            },
            tooltip: 'Estadísticas',
          ),
          // Botón de importar
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImportScreen(),
                ),
              );
            },
            tooltip: 'Importar datos',
          ),
          // Menú de opciones
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              switch (value) {
                case 'exportar':
                  _exportarDatos();
                  break;
                case 'limpiar':
                  _mostrarDialogoLimpiar();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'exportar',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 12),
                    Text('Exportar datos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'limpiar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Limpiar base de datos', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const SearchBarWidget(),
          ),
          
          // Lista de productos
          Expanded(
            child: Consumer<ProductoProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.productos.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => provider.cargarProductos(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.productos.length,
                    itemBuilder: (context, index) {
                      final producto = provider.productos[index];
                      return ProductoCard(
                        producto: producto,
                        onTap: () => _editarProducto(producto.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Botones de acción flotantes
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón de escaneo
          FloatingActionButton(
            heroTag: 'scan',
            onPressed: _abrirEscaner,
            backgroundColor: Colors.purple[600],
            child: const Icon(Icons.qr_code_scanner),
          ),
          const SizedBox(height: 16),
          // Botón de agregar manual
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _agregarProductoManual,
            backgroundColor: Colors.green[600],
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay productos',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos escaneando códigos\no importando desde Excel',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _abrirEscaner,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImportScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Importar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _abrirEscaner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScannerScreen(),
      ),
    );
  }

  void _agregarProductoManual() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductoFormScreen(),
      ),
    );
  }

  void _editarProducto(String productoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductoFormScreen(productoId: productoId),
      ),
    );
  }

  Future<void> _exportarDatos() async {
    // Implementar exportación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de exportación en desarrollo'),
      ),
    );
  }

  void _mostrarDialogoLimpiar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Limpiar base de datos?'),
        content: const Text(
          'Esto eliminará todos los productos. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductoProvider>().limpiarBaseDatos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Base de datos limpiada'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );
  }
}
