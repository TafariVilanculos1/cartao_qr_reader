import 'dart:async' show TimeoutException;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/estudante.dart';
import 'dart:io';

class QrController {
  final String baseUrl =
      'https://ecard.ustm.ac.mz/v1/estudantes';

  final String endpointSituacaoFinanceira =
      'https://144.91.69.212/v1/estudantes';

  // 1. Buscar estudante

  Future<Estudante?> buscarEstudante(String codigo) async {
    final url = '$baseUrl/$codigo';

    try {
      debugPrint('========== CONSULTA ESTUDANTE ==========');
      debugPrint('URL: $url');
      debugPrint('CÓDIGO: $codigo');

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
        jsonDecode(utf8.decode(response.bodyBytes));

        return Estudante.fromJson(json);
      }

      if (response.statusCode == 404) {
        debugPrint('ESTUDANTE NÃO ENCONTRADO NA API');
        return null;
      }

      debugPrint('ERRO HTTP: ${response.statusCode}');
      throw Exception(
        'Não foi possível consultar o estudante. Tente novamente.',
      );
    } on TimeoutException {
      debugPrint('ERRO: Tempo de ligação esgotado.');
      throw Exception(
        'A ligação ao servidor demorou demasiado. Verifique a Internet e tente novamente.',
      );
    } on SocketException catch (e) {
      debugPrint('ERRO DE REDE: $e');
      throw Exception(
        'Sem ligação à Internet. Verifique a sua conexão e tente novamente.',
      );
    } on HandshakeException catch (e) {
      debugPrint('ERRO SSL: $e');
      throw Exception(
        'Não foi possível estabelecer uma ligação segura com o servidor.',
      );
    } catch (e) {
      debugPrint('ERRO NA CONSULTA DO ESTUDANTE: $e');
      rethrow;
    }
  }

  // 2. Confirmar inscrição
  Future<bool?> confirmarInscricao(String codigoEstudante) async {
    try {
      final url =
          '$baseUrl/$codigoEstudante/inscricoes/confirmacao';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      }

      return null;
    } catch (e) {
      debugPrint('Erro API inscrição: $e');
      return null;
    }
  }

  // 3. Consultar situação financeira
  Future<double?> confirmarSituacaoFinanceira(
      String codigoEstudante) async {
    try {
      final url =
          '$endpointSituacaoFinanceira/$codigoEstudante/dividas';

      final response = await http.get(Uri.parse(url));

      debugPrint('FINANCEIRO STATUS: ${response.statusCode}');
      debugPrint('FINANCEIRO BODY: ${response.body}');

      if (response.statusCode == 200) {
        final resultado = jsonDecode(response.body);

        if (resultado is num) {
          return resultado.toDouble();
        }

        return null;
      }

      return null;
    } catch (e) {
      debugPrint('Erro API Situação Financeira: $e');
      return null;
    }
  }
}