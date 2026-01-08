import 'package:cartao_qr_reader/model/estudante.dart';
import 'package:flutter/material.dart';
import 'package:cartao_qr_reader/View/LeituraQR.dart';
import 'package:cartao_qr_reader/View/TelaInscrito.dart';
import 'package:cartao_qr_reader/View/TelaNaoInscrito.dart';
import 'package:cartao_qr_reader/Control/QrController.dart';


void main()
{
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
                 "VERIFICAR INSCRIÇÃO",
                 style: TextStyle(
                   fontSize: 18,
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
                       Estudante est = Estudante(codigo: 202202442, nome: "Tafari", curso: "Desenvolvimento de Software", faculdade: "FCTI", contacto: "841478096");
                       bool semestre = true;
                       bool continuar = true;
                       //final controller = QrController();

                     while (continuar) {
                       final codigoLido = await Navigator.push(
                       context,
                       MaterialPageRoute(builder: (_) => const LeituraQr()),
                       );

                       if (!context.mounted) return;

                       if(codigoLido=="202202442"&& semestre==true)
                       {
                         final voltar = await Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (_) => TelaInscrito(estudante: est),
                           ),
                         );
                         continuar = voltar == true;

                       }else if(codigoLido=="202202442" && semestre==false){

                         final voltar = await Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (_) => TelaNaoInscrito(estudante: est),
                           ),
                         );
                          continuar = voltar == true;
                       }

                          /*
                           if (estudante != null) {
                           final voltar = await Navigator.push(
                           context,
                           MaterialPageRoute(
                           builder: (_) => TelaInscrito(estudante: estudante),
                           ),
                           );
                           continuar = voltar == true;
                           } else {
                           final voltar = await Navigator.push(
                           context,
                           MaterialPageRoute(builder: (_) => TelaNaoInscrito(estudante: estudante!,)),
                           );
                           continuar = voltar == true;
                           }

                           */
                         }
                       },


                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                     foregroundColor: Colors.white,
                     minimumSize: const Size(260, 56),
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
                     minimumSize: const Size(260, 56),
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

   void mostrarDialog(BuildContext context) {
     TextEditingController textcontroller = TextEditingController();
     QrController controller = QrController();

     showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: const Text("CÓDIGO DE ESTUDANTE"),
           content: TextField(
             controller: textcontroller,
             keyboardType: TextInputType.number,
             decoration: const InputDecoration(hintText: "DIGITE O CÓDIGO"),
           ),
           actions: [
             TextButton(
               onPressed: () => Navigator.pop(context),
               child: const Text("Cancelar"),
             ),
             TextButton(
               onPressed: () async {
                 bool semestre = true;
                 Estudante est = Estudante(codigo: 202202442, nome: "Tafari", curso: "Desenvolvimento de Software", faculdade: "FCTI", contacto: "841478096");

                 final codigo = int.tryParse(textcontroller.text);

                 if (codigo == null) return;

                 Navigator.pop(context);

                 if(codigo==est.codigo && semestre==true)
                 {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => TelaInscrito(estudante: est)));

                 }else if(codigo==est.codigo && semestre==false){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => TelaNaoInscrito(estudante: est)));
                 }
                 // fecha dialog
                 /*
                 final est = await controller.buscarEstudantePorCodigo(codigo);

                 if (!context.mounted) return;

                 if (est != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TelaInscrito(estudante: est)));
                 } else {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> TelaNaoInscrito(estudante: est!)));
                 }

                  */
               },
               child: const Text("Verificar"),
             ),
           ],
         );
       },
     );
   }

 }
