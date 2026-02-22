// lib/widgets/producto_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onTap;

  const ProductoCard({
    Key? key,
    required this.producto,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y precio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (producto.categoria != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                producto.categoria!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currencyFormat.format(producto.precio),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Información adicional
              Row(
                children: [
                  // Stock
                  _buildInfoChip(
                    icon: Icons.inventory_2,
                    label: 'Stock: ${producto.cantidad}',
                    color: _getStockColor(producto.cantidad),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Código de barras
                  if (producto.codigoBarras != null)
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.qr_code,
                        label: producto.codigoBarras!,
                        color: Colors.grey[700]!,
                      ),
                    ),
                ],
              ),
              
              // Margen de ganancia
              if (producto.margenGanancia != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Margen: ${producto.margenGanancia!.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Compra: ${currencyFormat.format(producto.precioCompra)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Descripción
              if (producto.descripcion != null && producto.descripcion!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    producto.descripcion!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStockColor(int cantidad) {
    if (cantidad <= 0) return Colors.red;
    if (cantidad <= 5) return Colors.orange;
    return Colors.green;
  }
}
