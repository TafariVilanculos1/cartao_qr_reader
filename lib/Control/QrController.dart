import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/estudante.dart';

class QrController {
  final String baseUrl = 'https://becard.ustm.ac.mz:8443/v1/estudantes';

  Future<Estudante?> buscarEstudante(String codigo) async {
    try {
      final url = '$baseUrl/$codigo';

      final response = await http.get(Uri.parse(url));

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
        jsonDecode(utf8.decode(response.bodyBytes));

        return Estudante.fromJson(json);
      }

      if (response.statusCode == 404) {
        return null;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar estudante: $e');
      return null;
    }
  }



  Future<bool?> confirmarInscricao(String codigoEstudante) async {
    try {
      final url =
          '$baseUrl/$codigoEstudante/inscricoes/confirmacao';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      }

      return null;
    } catch (e) {
      debugPrint('Erro API inscrição: $e');
      return null;
    }
  }
}

