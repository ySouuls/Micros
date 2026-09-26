import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  // Em produção (site publicado), o app web é servido pela própria API,
  // então usamos caminho relativo (baseUrl vazio) — funciona em qualquer
  // domínio, sem precisar saber a URL de antemão. Isso é definido em tempo
  // de build com --dart-define=API_BASE_URL= (vazio = mesma origem).
  //
  // Em desenvolvimento local (sem o --dart-define), mantemos o
  // comportamento antigo: localhost no navegador, IP da rede no celular.
  static const String _override = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '__nao_definido__',
  );

  static String get baseUrl {
    if (_override != '__nao_definido__') return _override;
    return kIsWeb ? "http://localhost:8000" : "http://192.168.1.9:8000";
  }

  Future<Map<String, dynamic>> identificarImagem(XFile imagem) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/predict"),
    );

    if (kIsWeb) {
      // Na Web (Chrome), lemos os bytes da imagem para evitar o erro do dart:io
      final bytes = await imagem.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes,
          filename: imagem.name,
        ),
      );
    } else {
      // No Mobile/Desktop, usamos o caminho normal do arquivo
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imagem.path,
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Erro ${response.statusCode}: $body",
      );
    }
  }

  Future<List<dynamic>> obterHistorico() async {
    final response = await http.get(Uri.parse("$baseUrl/historico"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        "Erro ${response.statusCode}: ${response.body}",
      );
    }
  }

  Future<void> apagarHistorico() async {
    final response = await http.delete(Uri.parse("$baseUrl/historico"));

    if (response.statusCode != 200) {
      throw Exception(
        "Erro ${response.statusCode}: ${response.body}",
      );
    }
  }

  Future<Map<String, dynamic>> contarFungos(XFile imagem) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/contar"),
    );

    if (kIsWeb) {
      final bytes = await imagem.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes,
          filename: imagem.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imagem.path,
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Erro ${response.statusCode}: $body",
      );
    }
  }
}