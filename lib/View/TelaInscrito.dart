import 'package:flutter/material.dart';
import 'package:cartao_qr_reader/model/estudante.dart';

class TelaInscrito extends StatefulWidget {
  final Estudante estudante;
  final double valorDivida;

  const TelaInscrito({
    super.key,
    required this.estudante,
    required this.valorDivida,
  });

  @override
  State<TelaInscrito> createState() => _TelaInscritoState();
}

class _TelaInscritoState extends State<TelaInscrito> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 120), () {
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.estudante;
    final divida = widget.valorDivida;

    final bool temDivida = divida > 0;

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Image.asset('assets/check.png', height: 150),

            const SizedBox(height: 20),

            const Text(
              "ESTUDANTE INSCRITO",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _info('CÓDIGO', e.codigo.toString()),
                      _info('NOME', e.nome),
                      _info('DELEGAÇÃO', e.delegacao),
                      _info('CAMPUS', e.campus),
                    ],
                  ),
                ),
              ),
            ),

            const Text(
              "SITUAÇÃO FINANCEIRA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _info(
                        'SITUAÇÃO',
                        temDivida ? 'COM DÍVIDA' : 'SEM DÍVIDA',
                      ),

                      _info(
                        'VALOR DA DÍVIDA',
                        '${divida.toStringAsFixed(2)} MT',
                      ),

                      const SizedBox(height: 10),

                      Icon(
                        temDivida
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle,
                        color: temDivida ? Colors.orange : Colors.green,
                        size: 45,
                      ),

                      Text(
                        temDivida
                            ? 'ESTUDANTE COM VALORES EM DÍVIDA'
                            : 'SITUAÇÃO FINANCEIRA REGULAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: temDivida ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
        const Divider(),
      ],
    );
  }
}