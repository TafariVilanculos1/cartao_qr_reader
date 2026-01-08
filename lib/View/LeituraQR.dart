import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LeituraQr extends StatefulWidget {
  const LeituraQr({super.key});

  @override
  State<LeituraQr> createState() => _LeituraQrState();
}

class _LeituraQrState extends State<LeituraQr> {
  bool _lido = false;

  final MobileScannerController _controller =
  MobileScannerController(
    facing: CameraFacing.front,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitura QR Code'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          if (_lido) return;
          _lido = true;

          final codigo = capture.barcodes.first.rawValue;

          if (codigo != null) {
            Navigator.pop(context, codigo);
          }
        },
      ),
    );
  }
}
