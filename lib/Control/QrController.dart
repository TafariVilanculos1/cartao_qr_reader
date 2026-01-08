import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cartao_qr_reader/model/estudante.dart';


class QrController {

  final String baseUrl = "http://192.168.0.116:8080/v1/estudantes";

  Future<Estudante?> buscarEstudantePorCodigo(int codigo) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$codigo'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return Estudante.fromJson(jsonBody);
      } else {
        return null; // estudante não encontrado
      }
    } catch (e) {
      debugPrint("Erro ao chamar API: $e");
      return null;
    }
  }
}
