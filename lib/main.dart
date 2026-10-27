import 'dart:io';

import 'package:cartao_qr_reader/model/estudante.dart';
import 'package:flutter/material.dart';
import 'package:cartao_qr_reader/View/LeituraQR.dart';
import 'package:cartao_qr_reader/View/TelaInscrito.dart';
import 'package:cartao_qr_reader/View/TelaNaoInscrito.dart';
import 'package:cartao_qr_reader/Control/QrController.dart';
import 'package:flutter/services.dart';
import 'package:cartao_qr_reader/Control/MyHttpOverrides.dart';


void main()
{
  HttpOverrides.global = MyHttpOverrides();
  runApp(TelaPrincipal());
}

class TelaPrincipal extends StatefulWidget{
  @override
  TelaMenu createState()=> TelaMenu();

}

class TelaMenu extends State<TelaPrincipal>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:TelaFuncionalidades()
    );
  }

}

class TelaFuncionalidades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Controlo do Estudante",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // centraliza horizontalmente
        children: [

          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Center( // garante que o texto fique no centro
              child: Text(
                "SCE - SISTEMA DE CONTROLO DE ESTUDANTE",textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // centraliza os botões
              children: [
                ElevatedButton(
                  onPressed:(){
                    Navigator.push(context,MaterialPageRoute(builder: (_) => const LeituraQr()),
                    );
                  },


                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(260, 150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "LEITURA QR CODE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    mostrarDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(260, 150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "CÓDIGO DE ESTUDANTE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void mostrarDialog(BuildContext contextTela) {
    final textController = TextEditingController();
    final controller = QrController();

    showDialog(
      context: contextTela,
      barrierDismissible: false, // Impede fechar o diálogo ao clicar fora enquanto processa
      builder: (dialogContext) {
        bool carregando = false;

        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              title: const Text("CÓDIGO DE ESTUDANTE"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    enabled: !carregando, // Desativa o input enquanto processa
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: "Ex: EST001",
                    ),
                  ),
                  if (carregando) ...[
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "A processar...",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: carregando ? null : () => Navigator.pop(dialogContext),
                  child: const Text("Cancelar"),
                ),

                TextButton(
                  onPressed: carregando ? null : () async {
                    final codigo = textController.text.trim().toUpperCase();

                    if (codigo.isEmpty) return;

                    // Ativa o estado de carregamento
                    setStateBuilder(() {
                      carregando = true;
                    });

                    // 1. Buscar estudante
                    final estudante = await controller.buscarEstudante(codigo);

                    if (!contextTela.mounted) return;

                    if (estudante == null) {
                      Navigator.pop(dialogContext); // Fecha o diálogo
                      ScaffoldMessenger.of(contextTela).showSnackBar(
                        const SnackBar(
                          content: Text("Estudante não existe"),
                        ),
                      );
                      return;
                    }

                    // 2. Confirmar inscrição
                    final inscrito = await controller.confirmarInscricao(codigo);

                    if (!contextTela.mounted) return;

                    if (inscrito == null) {
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(contextTela).showSnackBar(
                        const SnackBar(
                          content: Text("Erro ao confirmar inscrição"),
                        ),
                      );
                      return;
                    }

                    // 3. Se não estiver inscrito
                    if (inscrito == false) {
                      Navigator.pop(dialogContext);
                      Navigator.push(
                        contextTela,
                        MaterialPageRoute(
                          builder: (_) => TelaNaoInscrito(
                            estudante: estudante,
                          ),
                        ),
                      );
                      return;
                    }

                    // 4. Consultar situação financeira
                    final valorDivida = await controller.confirmarSituacaoFinanceira(codigo);

                    if (!contextTela.mounted) return;

                    if (valorDivida == null) {
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(contextTela).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Erro ao consultar situação financeira",
                          ),
                        ),
                      );
                      return;
                    }

                    // 5. Fechar o diálogo e ir para a tela de inscrito
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      contextTela,
                      MaterialPageRoute(
                        builder: (_) => TelaInscrito(
                          estudante: estudante,
                          valorDivida: valorDivida,
                        ),
                      ),
                    );
                  },
                  child: const Text("Verificar"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}