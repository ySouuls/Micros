import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/strings.dart';
import '../services/api_service.dart';
import '../services/pdf_report_service.dart';
import '../widgets/image_source_sheet.dart';

Future<Size> _tamanhoDaImagem(XFile imagem) async {
  final bytes = await imagem.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
}

/// Desenha as caixinhas de detecção direto em cima da imagem original
/// (coordenadas já vêm em pixels da imagem, sem precisar de ajuste de
/// escala como no CustomPaint da tela).
Future<Uint8List> _imagemComCaixas(
  Uint8List imagemBytes,
  Size tamanhoOriginal,
  List deteccoes,
) async {
  final codec = await ui.instantiateImageCodec(imagemBytes);
  final frame = await codec.getNextFrame();
  final imagem = frame.image;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImage(imagem, Offset.zero, Paint());

  final paint = Paint()
    ..color = const Color(0xFF22C55E)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  for (final det in deteccoes) {
    final rect = Rect.fromLTRB(
      (det["x1"] ?? 0).toDouble(),
      (det["y1"] ?? 0).toDouble(),
      (det["x2"] ?? 0).toDouble(),
      (det["y2"] ?? 0).toDouble(),
    );
    canvas.drawRect(rect, paint);
  }

  final picture = recorder.endRecording();
  final composta = await picture.toImage(
    tamanhoOriginal.width.toInt(),
    tamanhoOriginal.height.toInt(),
  );
  final bytes = await composta.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

class NovaContagemScreen extends StatefulWidget {
  const NovaContagemScreen({super.key});

  @override
  State<NovaContagemScreen> createState() => _NovaContagemScreenState();
}

class _NovaContagemScreenState extends State<NovaContagemScreen> {
  final ApiService _api = ApiService();

  XFile? _imagem;
  Size? _tamanhoOriginal;
  bool _carregando = false;
  bool _gerandoPdf = false;
  String? _erro;
  Map<String, dynamic>? _resultado;

  Future<void> _selecionarEContar() async {
    final foto = await selecionarImagem(context);
    if (foto == null) return;

    setState(() {
      _imagem = foto;
      _tamanhoOriginal = null;
      _resultado = null;
      _erro = null;
      _carregando = true;
    });

    try {
      final tamanho = await _tamanhoDaImagem(foto);
      final resultado = await _api.contarFungos(foto);
      if (!mounted) return;
      setState(() {
        _tamanhoOriginal = tamanho;
        _resultado = resultado;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString();
        _carregando = false;
      });
    }
  }

  Future<void> _baixarRelatorio(int quantidade, List deteccoes) async {
    if (_imagem == null) return;

    setState(() => _gerandoPdf = true);
    try {
      final bytesOriginais = await _imagem!.readAsBytes();
      final bytesFinais = (deteccoes.isNotEmpty && _tamanhoOriginal != null)
          ? await _imagemComCaixas(bytesOriginais, _tamanhoOriginal!, deteccoes)
          : bytesOriginais;

      await PdfReportService.gerar(
        titulo: tr(context, 'report_title_count'),
        imagemBytes: bytesFinais,
        campos: [
          MapEntry(tr(context, 'report_field_file'), _imagem!.name),
          MapEntry(tr(context, 'spores_found'), "$quantidade"),
        ],
      );
    } finally {
      if (mounted) setState(() => _gerandoPdf = false);
    }
  }

  Widget _imagemWidget() {
    if (kIsWeb) {
      return Image.network(_imagem!.path, fit: BoxFit.contain);
    }
    return Image.file(File(_imagem!.path), fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List deteccoes = _resultado?["deteccoes"] ?? [];
    final int quantidade = _resultado?["quantidade"] ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(tr(context, 'new_count')),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selecionarEContar,
              child: Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: _imagem == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 70,
                            color: theme.iconTheme.color?.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tr(context, 'tap_to_select_image'),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _imagemWidget(),
                            if (deteccoes.isNotEmpty &&
                                _tamanhoOriginal != null)
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _CaixasPainter(
                                      deteccoes, _tamanhoOriginal!),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            if (_carregando)
              Column(
                children: [
                  const CircularProgressIndicator(color: Color(0xFF22C55E)),
                  const SizedBox(height: 12),
                  Text(tr(context, 'counting_spores'),
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            if (_erro != null)
              Text(
                "${tr(context, 'count_error')}: $_erro",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            if (_resultado != null && _erro == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF22C55E).withOpacity(0.25)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.calculate_rounded,
                        color: const Color(0xFF22C55E), size: 34),
                    const SizedBox(height: 10),
                    Text(
                      "$quantidade",
                      style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(tr(context, 'spores_found'),
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            if (_resultado != null && _erro == null && !_carregando) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _gerandoPdf
                    ? null
                    : () => _baixarRelatorio(quantidade, deteccoes),
                icon: _gerandoPdf
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_rounded,
                        color: Color(0xFF22C55E)),
                label: Text(
                  tr(context, 'download_report'),
                  style: const TextStyle(
                      color: Color(0xFF22C55E), fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF22C55E)),
                  minimumSize: const Size(double.infinity, 46),
                ),
              ),
            ],
            if (_imagem != null && !_carregando) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _selecionarEContar,
                icon:
                    const Icon(Icons.refresh_rounded, color: Color(0xFF22C55E)),
                label: Text(
                  tr(context, 'count_another_image'),
                  style: const TextStyle(
                      color: Color(0xFF22C55E), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CaixasPainter extends CustomPainter {
  final List deteccoes;
  final Size tamanhoOriginal;

  _CaixasPainter(this.deteccoes, this.tamanhoOriginal);

  @override
  void paint(Canvas canvas, Size size) {
    // As coordenadas vêm em pixels da imagem original. Como o Image widget
    // usa BoxFit.contain (mantém proporção, pode sobrar espaço nas laterais
    // ou em cima/baixo), calculamos a mesma transformação aqui pra alinhar
    // as caixinhas certinho em cima da imagem exibida.
    final ajuste = applyBoxFit(BoxFit.contain, tamanhoOriginal, size);
    final escala = ajuste.destination.width / tamanhoOriginal.width;
    final deslocX = (size.width - ajuste.destination.width) / 2;
    final deslocY = (size.height - ajuste.destination.height) / 2;

    final paint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final det in deteccoes) {
      final rect = Rect.fromLTRB(
        (det["x1"] ?? 0).toDouble() * escala + deslocX,
        (det["y1"] ?? 0).toDouble() * escala + deslocY,
        (det["x2"] ?? 0).toDouble() * escala + deslocX,
        (det["y2"] ?? 0).toDouble() * escala + deslocY,
      );
      canvas.drawRect(rect, paint);

      final confianca = det["confianca"];
      if (confianca == null) continue;

      final texto = "$confianca%";
      final tp = TextPainter(
        text: TextSpan(
          text: texto,
          style: const TextStyle(
            color: Color(0xFF22C55E),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.black54,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(rect.left, rect.top - tp.height - 1));
    }
  }

  @override
  bool shouldRepaint(covariant _CaixasPainter oldDelegate) =>
      oldDelegate.deteccoes != deteccoes ||
      oldDelegate.tamanhoOriginal != tamanhoOriginal;
}
