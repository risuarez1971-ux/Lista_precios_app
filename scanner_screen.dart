// lib/screens/scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import 'producto_form_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código'),
        backgroundColor: Colors.purple[600],
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return const Icon(Icons.cameraswitch);
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Cámara
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          
          // Overlay con marco de escaneo
          CustomPaint(
            painter: ScannerOverlay(),
            child: Container(),
          ),
          
          // Instrucciones
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Apunta al código de barras o QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Se detectará automáticamente',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Indicador de procesamiento
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final String? code = barcode.rawValue;

    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);

    // Buscar producto por código de barras
    final provider = context.read<ProductoProvider>();
    final producto = await provider.buscarPorCodigoBarras(code);

    if (!mounted) return;

    if (producto != null) {
      // Producto existente - mostrar diálogo con opciones
      _mostrarDialogoProductoExistente(producto.id, code);
    } else {
      // Producto nuevo - ir a formulario de creación
      _crearNuevoProducto(code);
    }

    setState(() => _isProcessing = false);
  }

  void _mostrarDialogoProductoExistente(String productoId, String codigo) {
    final provider = context.read<ProductoProvider>();
    final producto = provider.obtenerProductoPorId(productoId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Producto encontrado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              producto?.nombre ?? 'Sin nombre',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Precio: \$${producto?.precio.toStringAsFixed(2)}'),
            Text('Stock: ${producto?.cantidad ?? 0} unidades'),
            if (producto?.categoria != null)
              Text('Categoría: ${producto?.categoria}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _ajustarInventario(productoId);
            },
            child: const Text('Ajustar Stock'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductoFormScreen(productoId: productoId),
                ),
              );
            },
            child: const Text('Ver Detalles'),
          ),
        ],
      ),
    );
  }

  void _crearNuevoProducto(String codigo) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductoFormScreen(
          codigoBarrasInicial: codigo,
        ),
      ),
    );
  }

  void _ajustarInventario(String productoId) {
    final provider = context.read<ProductoProvider>();
    final producto = provider.obtenerProductoPorId(productoId);
    
    if (producto == null) return;

    showDialog(
      context: context,
      builder: (context) {
        int ajuste = 1;
        return AlertDialog(
          title: const Text('Ajustar inventario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stock actual: ${producto.cantidad} unidades'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (ajuste > -producto.cantidad) {
                        ajuste--;
                        (context as Element).markNeedsBuild();
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: 32,
                  ),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ajuste.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ajuste++;
                      (context as Element).markNeedsBuild();
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Nuevo stock: ${producto.cantidad + ajuste}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await provider.ajustarInventario(productoId, ajuste);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Inventario actualizado: ${producto.cantidad + ajuste} unidades',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

// Painter para el overlay del escáner
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Dibujar overlay oscuro
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Dibujar esquinas del área de escaneo
    final Paint cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final double cornerLength = 30;

    // Esquina superior izquierda
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      cornerPaint,
    );

    // Esquina superior derecha
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize - cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );

    // Esquina inferior izquierda
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left + cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left, top + scanAreaSize - cornerLength),
      cornerPaint,
    );

    // Esquina inferior derecha
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
