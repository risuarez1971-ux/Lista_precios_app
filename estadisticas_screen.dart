// lib/screens/estadisticas_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/producto_provider.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({Key? key}) : super(key: key);

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  Map<String, dynamic>? _estadisticas;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
  }

  Future<void> _cargarEstadisticas() async {
    setState(() => _isLoading = true);
    
    final provider = context.read<ProductoProvider>();
    final stats = await provider.obtenerEstadisticas();
    
    setState(() {
      _estadisticas = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        backgroundColor: Colors.indigo[600],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarEstadisticas,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Resumen general
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Productos',
                            value: _estadisticas?['totalProductos'].toString() ?? '0',
                            icon: Icons.inventory,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Bajo Stock',
                            value: _estadisticas?['productosBajoStock'].toString() ?? '0',
                            icon: Icons.warning,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Valor de inventario
                    _buildStatCard(
                      title: 'Valor Total del Inventario',
                      value: currencyFormat.format(
                        _estadisticas?['valorInventario'] ?? 0.0,
                      ),
                      icon: Icons.attach_money,
                      color: Colors.green,
                      isLarge: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Productos con bajo stock
                    const Text(
                      'Productos con Bajo Stock',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    FutureBuilder(
                      future: context.read<ProductoProvider>().obtenerProductosBajoStock(5),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final productos = snapshot.data!;
                        
                        if (productos.isEmpty) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 48,
                                    color: Colors.green[400],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Todos los productos tienen stock suficiente',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        return Column(
                          children: productos.map((producto) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: producto.cantidad == 0
                                      ? Colors.red[100]
                                      : Colors.orange[100],
                                  child: Icon(
                                    producto.cantidad == 0
                                        ? Icons.remove_circle
                                        : Icons.warning,
                                    color: producto.cantidad == 0
                                        ? Colors.red[700]
                                        : Colors.orange[700],
                                  ),
                                ),
                                title: Text(producto.nombre),
                                subtitle: Text(
                                  producto.cantidad == 0
                                      ? 'Sin stock'
                                      : 'Stock: ${producto.cantidad}',
                                ),
                                trailing: Text(
                                  currencyFormat.format(producto.precio),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isLarge = false,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: isLarge ? 32 : 24),
                ),
                if (isLarge) const Spacer(),
              ],
            ),
            SizedBox(height: isLarge ? 16 : 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isLarge ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
