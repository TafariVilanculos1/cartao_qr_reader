import 'package:flutter/material.dart';
import 'package:cartao_qr_reader/model/estudante.dart';

class TelaInscrito extends StatefulWidget {
  final Estudante estudante;

  TelaInscrito({required this.estudante});

  @override
  State<TelaInscrito> createState() => _TelaInscritoState();
}


class _TelaInscritoState extends State<TelaInscrito> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.estudante;

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
              "ESTUDANTE ACTIVO",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

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
              "Situação Financeira",
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
                      _info('NOME', e.codigo.toString()),
                      _info('DÍVIDA', e.nome)
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
            Text('$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value)),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
