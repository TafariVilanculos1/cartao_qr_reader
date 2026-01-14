import 'package:flutter/material.dart';
import 'package:cartao_qr_reader/model/estudante.dart';

class TelaNaoInscrito extends StatefulWidget {
  final Estudante estudante;

  TelaNaoInscrito({required this.estudante});

  @override
  State<TelaNaoInscrito> createState() => _TelaInscritoState();
}


class _TelaInscritoState extends State<TelaNaoInscrito> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.estudante;

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/no.png', height: 150),
            const SizedBox(height: 20),
            const Text(
              "ESTUDANTE INACTIVO",
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
                      _info('GÊNERO', e.genero),
                      _info('FACULDADE', e.faculdade),
                      _info('CONTACTO', e.contacto),
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
