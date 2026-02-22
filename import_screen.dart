// lib/screens/import_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import '../services/excel_service.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({Key? key}) : super(key: key);

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool _isLoading = false;
  String? _fileName;
  int? _productosImportados;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Datos'),
        backgroundColor: Colors.blue[600],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Importando productos...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icono
                  Icon(
                    Icons.file_upload,
                    size: 80,
                    color: Colors.blue[300],
                  ),
                  const SizedBox(height: 24),

                  // Título
                  const Text(
                    'Importar desde Excel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Selecciona un archivo .xlsx o .xls',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Instrucciones
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              const Text(
                                'Formato del archivo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'El archivo Excel debe contener las siguientes columnas:',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          _buildRequirement('Nombre', required: true),
                          _buildRequirement('Precio', required: true),
                          _buildRequirement('Código de Barras', required: false),
                          _buildRequirement('Cantidad', required: false),
                          _buildRequirement('Categoría', required: false),
                          _buildRequirement('Descripción', required: false),
                          _buildRequirement('Precio de Compra', required: false),
                          _buildRequirement('Proveedor', required: false),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber, color: Colors.amber[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'La primera fila debe contener los encabezados',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Resultado de importación
                  if (_productosImportados != null)
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green[700]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Importación exitosa',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '$_productosImportados productos importados desde $_fileName',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Botón de importar
                  ElevatedButton.icon(
                    onPressed: _importarArchivo,
                    icon: const Icon(Icons.file_open),
                    label: const Text('Seleccionar archivo Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRequirement(String nombre, {required bool required}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            required ? Icons.check_box : Icons.check_box_outline_blank,
            size: 18,
            color: required ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            nombre,
            style: TextStyle(
              fontSize: 13,
              color: required ? Colors.black87 : Colors.grey[600],
              fontWeight: required ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          if (required)
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _importarArchivo() async {
    try {
      setState(() => _isLoading = true);

      // Seleccionar archivo
      final archivo = await ExcelService.instance.seleccionarArchivo();
      
      if (archivo == null) {
        setState(() => _isLoading = false);
        return;
      }

      setState(() => _fileName = archivo.path.split('/').last);

      // Importar productos
      final productos = await ExcelService.instance.importarDesdeExcel(archivo);

      if (productos.isEmpty) {
        throw Exception('No se encontraron productos en el archivo');
      }

      // Guardar en base de datos
      final provider = context.read<ProductoProvider>();
      final exito = await provider.importarProductos(productos);

      setState(() {
        _isLoading = false;
        if (exito) {
          _productosImportados = productos.length;
        }
      });

      if (!mounted) return;

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${productos.length} productos importados exitosamente'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Ver',
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      } else {
        throw Exception('Error al guardar los productos');
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error al importar'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }
}
