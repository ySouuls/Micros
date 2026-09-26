import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/strings.dart';

// Abre o menu de Câmera/Galeria e já devolve a imagem escolhida (ou null
// se o usuário cancelar). Usado por qualquer tela que precise selecionar
// uma foto (Home, Nova Identificação, Nova Contagem).
Future<XFile?> selecionarImagem(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_camera,
                color: Theme.of(sheetContext).iconTheme.color,
              ),
              title: Text(tr(sheetContext, 'take_photo')),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Theme.of(sheetContext).iconTheme.color,
              ),
              title: Text(tr(sheetContext, 'open_gallery')),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );

  if (source == null) return null;

  return ImagePicker().pickImage(source: source, imageQuality: 100);
}
