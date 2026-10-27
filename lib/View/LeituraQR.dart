
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
    try {
      await _controller.switchCamera();

      if (!mounted) return;

      setState(() {
        _cameraFrontal = !_cameraFrontal;
      });
    } catch (e) {
      debugPrint('Erro ao alternar câmara: $e');
    }
  }

  Future<void> _processar(String codigo) async {
    if (_ocupado) return;

    _ocupado = true;

    codigo = codigo.trim().toUpperCase();

    try {
      // 1. Buscar estudante
      final estudante = await api.buscarEstudante(codigo);

      if (!mounted) return;

      if (estudante == null) {
        _mostrar("❌ NÃO EXISTE", Colors.red);
        return;
      }

      // 2. Confirmar inscrição
      final inscrito = await api.confirmarInscricao(codigo);

      if (!mounted) return;

      if (inscrito == null) {
        _mostrar("❌ ERRO NA VERIFICAÇÃO DA INSCRIÇÃO", Colors.red);
        return;
      }

      if (inscrito == false) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TelaNaoInscrito(
              estudante: estudante,
            ),
          ),
        );

        if (mounted) {
          _ocupado = false;
        }

        return;
      }

      // 3. Consultar situação financeira
      final valorDivida =
      await api.confirmarSituacaoFinanceira(codigo);

      if (!mounted) return;

      if (valorDivida == null) {
        _mostrar(
          "❌ ERRO NA VERIFICAÇÃO FINANCEIRA",
          Colors.red,
        );
        return;
      }

      // 4. Apresentar os dados do estudante e a dívida
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TelaInscrito(
            estudante: estudante,
            valorDivida: valorDivida,
          ),
        ),
      );

      if (mounted) {
        _ocupado = false;
      }

    } catch (e) {
      debugPrint('Erro ao processar QR: $e');

      if (!mounted) return;

      _mostrar("❌ ERRO DE COMUNICAÇÃO", Colors.red);
    }
  }

  void _mostrar(String texto, Color cor) {
    if (!mounted) return;

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
            tooltip: _cameraFrontal
                ? "Usar câmara traseira"
                : "Usar câmara frontal",
            icon: const Icon(
              Icons.cameraswitch,
              color: Colors.white,
            ),
            onPressed: _alternarCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;

              final codigo = capture.barcodes.first.rawValue;

              if (codigo != null && codigo.isNotEmpty) {
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
