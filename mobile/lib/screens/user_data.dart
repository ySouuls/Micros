import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notifier reativo para a foto de perfil
final ValueNotifier<File?> profileImageNotifier = ValueNotifier<File?>(null);

class UserDataService {
  static const String _keyFotoPath = "foto_path";

  // Carrega a foto salva ao iniciar o app
  static Future<void> carregarFoto() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_keyFotoPath);
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        profileImageNotifier.value = file;
      }
    }
  }

  // Salva o caminho da nova foto
  static Future<void> salvarFoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFotoPath, path);
    profileImageNotifier.value = File(path);
  }
}