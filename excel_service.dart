// lib/services/excel_service.dart

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/producto.dart';

class ExcelService {
  static final ExcelService instance = ExcelService._init();
  ExcelService._init();

  // Seleccionar archivo Excel
  Future<File?> seleccionarArchivo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error seleccionando archivo: $e');
      return null;
    }
  }

  // Importar productos desde Excel
  Future<List<Producto>> importarDesdeExcel(File archivo) async {
    try {
      final bytes = archivo.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      
      final productos = <Producto>[];
      
      // Obtener la primera hoja
      final sheet = excel.tables.keys.first;
      final table = excel.tables[sheet];
      
      if (table == null || table.rows.isEmpty) {
        throw Exception('El archivo Excel está vacío');
      }

      // La primera fila son los encabezados
      final headers = table.rows.first
          .map((cell) => cell?.value?.toString().toLowerCase().trim() ?? '')
          .toList();

      // Encontrar índices de columnas
      final nombreIdx = _encontrarIndice(headers, ['nombre', 'producto', 'descripcion']);
      final precioIdx = _encontrarIndice(headers, ['precio', 'price', 'valor']);
      final codigoIdx = _encontrarIndice(headers, ['codigo', 'barras', 'ean', 'upc', 'sku']);
      final cantidadIdx = _encontrarIndice(headers, ['cantidad', 'stock', 'inventario']);
      final categoriaIdx = _encontrarIndice(headers, ['categoria', 'category', 'tipo']);
      final descripcionIdx = _encontrarIndice(headers, ['descripcion', 'description', 'detalle']);
      final precioCompraIdx = _encontrarIndice(headers, ['compra', 'costo', 'cost']);
      final proveedorIdx = _encontrarIndice(headers, ['proveedor', 'supplier', 'distribuidor']);

      if (nombreIdx == -1 || precioIdx == -1) {
        throw Exception('El archivo debe contener columnas "Nombre" y "Precio"');
      }

      // Procesar filas (saltando la primera que son los encabezados)
      for (var i = 1; i < table.rows.length; i++) {
        final row = table.rows[i];
        
        // Obtener nombre (requerido)
        final nombre = _obtenerValorCelda(row, nombreIdx);
        if (nombre.isEmpty) continue;

        // Obtener precio (requerido)
        final precioStr = _obtenerValorCelda(row, precioIdx);
        final precio = _parsearPrecio(precioStr);
        if (precio == null || precio <= 0) continue;

        // Obtener otros valores opcionales
        final codigoBarras = codigoIdx >= 0 ? _obtenerValorCelda(row, codigoIdx) : null;
        final cantidadStr = cantidadIdx >= 0 ? _obtenerValorCelda(row, cantidadIdx) : '0';
        final cantidad = int.tryParse(cantidadStr) ?? 0;
        final categoria = categoriaIdx >= 0 ? _obtenerValorCelda(row, categoriaIdx) : null;
        final descripcion = descripcionIdx >= 0 ? _obtenerValorCelda(row, descripcionIdx) : null;
        final precioCompraStr = precioCompraIdx >= 0 ? _obtenerValorCelda(row, precioCompraIdx) : null;
        final precioCompra = precioCompraStr != null ? _parsearPrecio(precioCompraStr) : null;
        final proveedor = proveedorIdx >= 0 ? _obtenerValorCelda(row, proveedorIdx) : null;

        // Crear producto
        final producto = Producto(
          id: const Uuid().v4(),
          nombre: nombre,
          precio: precio,
          codigoBarras: codigoBarras?.isNotEmpty == true ? codigoBarras : null,
          descripcion: descripcion?.isNotEmpty == true ? descripcion : null,
          cantidad: cantidad,
          fechaCreacion: DateTime.now(),
          categoria: categoria?.isNotEmpty == true ? categoria : null,
          precioCompra: precioCompra,
          proveedor: proveedor?.isNotEmpty == true ? proveedor : null,
        );

        productos.add(producto);
      }

      return productos;
    } catch (e) {
      print('Error importando Excel: $e');
      rethrow;
    }
  }

  // Exportar productos a Excel
  Future<File?> exportarAExcel(List<Producto> productos, String nombreArchivo) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Productos'];

      // Encabezados
      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Nombre'),
        TextCellValue('Precio'),
        TextCellValue('Código de Barras'),
        TextCellValue('Descripción'),
        TextCellValue('Cantidad'),
        TextCellValue('Categoría'),
        TextCellValue('Precio Compra'),
        TextCellValue('Proveedor'),
        TextCellValue('Fecha Creación'),
      ]);

      // Aplicar estilo a encabezados
      for (var i = 0; i < 10; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.gray25,
        );
      }

      // Datos
      for (final producto in productos) {
        sheet.appendRow([
          TextCellValue(producto.id),
          TextCellValue(producto.nombre),
          DoubleCellValue(producto.precio),
          TextCellValue(producto.codigoBarras ?? ''),
          TextCellValue(producto.descripcion ?? ''),
          IntCellValue(producto.cantidad),
          TextCellValue(producto.categoria ?? ''),
          producto.precioCompra != null ? DoubleCellValue(producto.precioCompra!) : const TextCellValue(''),
          TextCellValue(producto.proveedor ?? ''),
          TextCellValue(producto.fechaCreacion.toString()),
        ]);
      }

      // Guardar archivo
      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Error generando archivo Excel');
      }

      // Aquí deberías usar path_provider para obtener el directorio apropiado
      // Por ahora, retornamos null indicando que se debe implementar
      return null;
    } catch (e) {
      print('Error exportando a Excel: $e');
      return null;
    }
  }

  // Funciones auxiliares
  int _encontrarIndice(List<String> headers, List<String> posiblesNombres) {
    for (var i = 0; i < headers.length; i++) {
      for (final nombre in posiblesNombres) {
        if (headers[i].contains(nombre)) {
          return i;
        }
      }
    }
    return -1;
  }

  String _obtenerValorCelda(List<Data?> row, int index) {
    if (index < 0 || index >= row.length) return '';
    final cell = row[index];
    if (cell == null || cell.value == null) return '';
    return cell.value.toString().trim();
  }

  double? _parsearPrecio(String valor) {
    try {
      // Limpiar el string: remover símbolos de moneda, espacios, etc.
      String limpio = valor
          .replaceAll(RegExp(r'[^\d.,]'), '')
          .replaceAll(',', '.');
      
      return double.tryParse(limpio);
    } catch (e) {
      return null;
    }
  }
}
