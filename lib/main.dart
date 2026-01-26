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
                     onPressed: () async {
                     final controller = QrController();
                     bool continuar = true;

                     while (continuar) {
                       final codigoLido = await Navigator.push(
                       context,
                       MaterialPageRoute(builder: (_) => const LeituraQr()),
                       );

                       if (!context.mounted || codigoLido == null) return;

                       final codigo =
                       codigoLido.toString().trim().toUpperCase();


                       // 1️⃣ Buscar estudante
                       final estudante = await controller.buscarEstudante(codigo);

                       if (!context.mounted) return;

                       if (estudante == null) {
                         await showDialog(
                             context: context,
                             builder: (_) => const AlertDialog(
                             title: Text("Erro"),
                             content: Text("Estudante não existe"),
                             ),
                         );
                         continue;
                       }

                       // 2️⃣ Confirmar inscrição
                       final inscrito =
                       await controller.confirmarInscricao(codigo);

                       if (inscrito == null) {
                               ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                               content: Text("Erro ao confirmar inscrição"),
                               ),
                           );
                           continue;
                       }

                       // 3️⃣ Navegação
                       final voltar = await Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (_) => inscrito
                         ? TelaInscrito(estudante: estudante)
                             : TelaNaoInscrito(estudante: estudante),
                         ),
                       );

                       continuar = voltar == true;
                         }
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
       builder: (dialogContext) {
         return AlertDialog(
           title: const Text("CÓDIGO DE ESTUDANTE"),
           content: TextField(
             controller: textController,
             textCapitalization: TextCapitalization.characters,
             decoration: const InputDecoration(
               hintText: "Ex: EST001",
             ),
           ),
           actions: [
             TextButton(
               onPressed: () => Navigator.pop(dialogContext),
               child: const Text("Cancelar"),
             ),
             TextButton(
               onPressed: () async {
                 final codigo =
                 textController.text.trim().toUpperCase();


                 Navigator.pop(dialogContext);

                 // 1️⃣ Buscar estudante
                 final estudante =
                 await controller.buscarEstudante(codigo);

                 if (!contextTela.mounted) return;

                 if (estudante == null) {
                   showDialog(
                     context: contextTela,
                     builder: (_) => const AlertDialog(
                       title: Text("Erro"),
                       content: Text("Estudante não existe"),
                     ),
                   );
                   return;
                 }
                 // 2️⃣ Confirmar inscrição
                 final inscrito =
                 await controller.confirmarInscricao(codigo);

                 if (inscrito == null) {
                   ScaffoldMessenger.of(contextTela).showSnackBar(
                     const SnackBar(
                       content: Text("Erro ao confirmar inscrição"),
                     ),
                   );
                   return;
                 }

                 // 3️⃣ Navegação final
                 Navigator.push(
                   contextTela,
                   MaterialPageRoute(
                     builder: (_) => inscrito
                         ? TelaInscrito(estudante: estudante)
                         : TelaNaoInscrito(estudante: estudante),
                   ),
                 );
               },
               child: const Text("Verificar"),
             ),
           ],
         );
       },
     );
   }
 }
