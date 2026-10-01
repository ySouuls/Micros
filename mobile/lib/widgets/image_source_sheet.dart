import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/strings.dart';

bool _ehTiff(String nome) {
  final minusculo = nome.toLowerCase();
  return minusculo.endsWith('.tif') || minusculo.endsWith('.tiff');
}

// O Flutter não consegue exibir .tif/.tiff direto (Image.file/Image.network
// não decodificam esse formato), então convertemos pra PNG assim que a
// imagem é selecionada. Isso também garante que a API recebe um formato
// que o Pillow/YOLO leem sem surpresas.
Future<XFile> _converterSeTiff(XFile original) async {
  if (!_ehTiff(original.name)) return original;

  final bytes = await original.readAsBytes();
  var decodificada = img.decodeTiff(bytes);
  if (decodificada == null) return original;

  // Mesma lógica de redimensionamento usada pro image_picker: evita mandar
  // imagens gigantes de microscópio pra API à toa.
  if (decodificada.width > 1280) {
    decodificada = img.copyResize(decodificada, width: 1280);
  }

  final pngBytes = Uint8List.fromList(img.encodePng(decodificada));
  final nomeBase =
      original.name.replaceAll(RegExp(r'\.tiff?$', caseSensitive: false), '');
  final novoNome = '$nomeBase.png';

  if (kIsWeb) {
    return XFile.fromData(pngBytes, name: novoNome, mimeType: 'image/png');
  }

  final pasta = await getTemporaryDirectory();
  final novoCaminho =
      '${pasta.path}/${DateTime.now().millisecondsSinceEpoch}_$novoNome';
  await File(novoCaminho).writeAsBytes(pngBytes);
  return XFile(novoCaminho);
}

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

  final picker = ImagePicker();
  XFile? imagem;
  try {
    // Reduzimos o tamanho aqui: os modelos de IA usam imagens bem menores
    // internamente (224 a 640px), então mandar a foto em resolução original
    // da câmera só deixa o upload e o processamento mais lentos à toa.
    imagem = await picker.pickImage(
      source: source,
      maxWidth: 1280,
      imageQuality: 85,
    );
  } catch (_) {
    // O redimensionamento nativo de algumas plataformas não entende .tif.
    // Nesse caso pegamos a imagem sem comprimir e convertemos manualmente.
    imagem = await picker.pickImage(source: source);
  }

  if (imagem == null) return null;
  return _converterSeTiff(imagem);
}
