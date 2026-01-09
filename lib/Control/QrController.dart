import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QrController {
  final String baseUrl = 'http://192.168.0.116:8080/v1/estudantes';

  Future<bool?> confirmarInscricao(String codigoEstudante) async {
    try {
      final url =
          '$baseUrl/EST001/inscricoes/confirmacao';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        return null; // erro da API
      }
    } catch (e) {
      debugPrint('Erro API: $e');
      return null;
    }
  }
}
