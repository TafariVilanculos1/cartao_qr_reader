
import 'package:cartao_qr_reader/View/TelaInscrito.dart';
import 'package:cartao_qr_reader/View/TelaNaoInscrito.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../Control/QrController.dart';

class LeituraQr extends StatefulWidget {
  const LeituraQr({super.key});

  @override
  State<LeituraQr> createState() => _LeituraQrState();
}

class _LeituraQrState extends State<LeituraQr> {

  final MobileScannerController _controller =
  MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  final QrController api = QrController();

  bool _ocupado = false;
  bool _cameraFrontal = false;

  String _mensagem = "";
  Color _cor = Colors.transparent;

  Future<void> _alternarCamera() async {
    await _controller.switchCamera();

    if (!mounted) return;

    setState(() {
      _cameraFrontal = !_cameraFrontal;
    });
  }

  Future<void> _processar(String codigo) async {
    if (_ocupado) return;

    _ocupado = true;

    codigo = codigo.trim().toUpperCase();

    try {
      final estudante = await api.buscarEstudante(codigo);

      if (!mounted) return;

      if (estudante == null) {
        _mostrar("❌ NÃO EXISTE", Colors.red);
        return;
      }

      final inscrito = await api.confirmarInscricao(codigo);

      if (!mounted) return;

      if (inscrito == true) {
        Navigator.push(context, MaterialPageRoute(builder:(_)=>TelaInscrito(estudante: estudante)));
      } else if (inscrito == false) {
        Navigator.push(context, MaterialPageRoute(builder:(_)=>TelaNaoInscrito(estudante: estudante)));
      } else {
        _mostrar("❌ ERRO NA VERIFICAÇÃO", Colors.red);
      }

    } catch (e) {
      if (!mounted) return;
      _mostrar("❌ ERRO DE COMUNICAÇÃO", Colors.red);
    }
  }

  void _mostrar(String texto, Color cor) {
    setState(() {
      _mensagem = texto;
      _cor = cor;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _mensagem = "";
        _cor = Colors.transparent;
      });

      _ocupado = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitura DO QRCODE"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            tooltip: "Alternar câmara",
            icon: const Icon(Icons.cameraswitch,color: Colors.white,),
            onPressed: _alternarCamera,
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final codigo = capture.barcodes.first.rawValue;

              if (codigo != null) {
                _processar(codigo);
              }
            },
          ),

          if (_mensagem.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
