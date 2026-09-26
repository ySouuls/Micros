import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Notificador global compartilhado entre HomeScreen e ProfileScreen
// para atualizar a foto de perfil reativamente em todo o app.
//
// No mobile/desktop, o valor é um caminho de arquivo real (persiste entre
// aberturas do app). No Web, o valor é uma data URI (base64) com a foto
// embutida — o image_picker no navegador só devolve uma URL temporária
// (blob:...) que deixa de existir assim que a página é recarregada, então
// precisamos guardar os bytes da imagem em vez do "caminho".
final ValueNotifier<String?> profileImagePathNotifier = ValueNotifier<String?>(null);

ImageProvider? profileImageProvider(String? valor) {
  if (valor == null || valor.isEmpty) return null;

  if (valor.startsWith('data:')) {
    final base64Parte = valor.split(',').last;
    return MemoryImage(base64Decode(base64Parte));
  }

  if (kIsWeb) return NetworkImage(valor);
  return FileImage(File(valor));
}
