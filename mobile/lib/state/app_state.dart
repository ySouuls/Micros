import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Notificador global compartilhado entre HomeScreen e ProfileScreen
// para atualizar a foto de perfil reativamente em todo o app.
final ValueNotifier<String?> profileImagePathNotifier = ValueNotifier<String?>(null);

// No Flutter Web o image_picker retorna uma URL temporária do navegador
// (blob:...), que não é um arquivo de verdade — dart:io File não funciona
// nesse caso. No mobile/desktop o retorno é um caminho de arquivo real.
ImageProvider? profileImageProvider(String? path) {
  if (path == null || path.isEmpty) return null;
  if (kIsWeb) return NetworkImage(path);
  return FileImage(File(path));
}
