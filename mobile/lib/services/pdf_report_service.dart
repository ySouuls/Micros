import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const _corVerde = PdfColor.fromInt(0xFF22C55E);
const _corNavy = PdfColor.fromInt(0xFF0F172A);
const _urlSite = "https://ysouuls.github.io/Micros/";

/// Gera e abre/baixa um relatório em PDF com a logo do MICROS, a
/// imagem analisada e os campos de resultado informados.
class PdfReportService {
  /// Layout antigo (mais simples). Mantido caso o novo não agrade.
  static Future<void> gerar({
    required String titulo,
    required Uint8List imagemBytes,
    required List<MapEntry<String, String>> campos,
    String? notaRodape,
  }) async {
    final documento = pw.Document();

    final logoBytes =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
    final logo = pw.MemoryImage(logoBytes);
    final imagem = pw.MemoryImage(imagemBytes);

    final agora = DateTime.now();
    String dois(int n) => n.toString().padLeft(2, '0');
    final dataFormatada =
        "${dois(agora.day)}/${dois(agora.month)}/${agora.year} ${dois(agora.hour)}:${dois(agora.minute)}";

    documento.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logo, width: 46, height: 46),
                pw.SizedBox(width: 14),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "MICROS",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#22C55E"),
                      ),
                    ),
                    pw.Text(titulo, style: const pw.TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              dataFormatada,
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 14),
            pw.Center(
              child: pw.Container(
                constraints: const pw.BoxConstraints(maxHeight: 300),
                child: pw.Image(imagem, fit: pw.BoxFit.contain),
              ),
            ),
            pw.SizedBox(height: 20),
            ...campos.map(
              (campo) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 150,
                      child: pw.Text(
                        campo.key,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(campo.value,
                          style: const pw.TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),
            if (notaRodape != null) ...[
              pw.SizedBox(height: 18),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              pw.Text(
                notaRodape,
                style: pw.TextStyle(
                  fontSize: 8.5,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    final bytes = await documento.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: "micros_relatorio_${agora.millisecondsSinceEpoch}.pdf",
    );
  }

  /// Layout novo: cabeçalho com logo e cores da marca, cartão de
  /// destaque com o resultado principal, imagem(ns), tabela de
  /// resultados, interpretação automática, observações e QR code
  /// pro site.
  static Future<void> gerarCompleto({
    required String titulo,
    required String arquivoNome,
    required int tempoProcessamentoMs,
    required String valorDestaque,
    required String rotuloDestaque,
    required List<MapEntry<String, String>> estatisticasExtras,
    required Uint8List imagemPrincipalBytes,
    Uint8List? imagemSecundariaBytes,
    String rotuloImagemPrincipal = "Imagem analisada",
    String rotuloImagemSecundaria = "Imagem com detecções",
    required List<MapEntry<String, String>> campos,
    required String interpretacao,
    String? notaRodape,
  }) async {
    final documento = pw.Document();

    final logoBytes =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
    final logo = pw.MemoryImage(logoBytes);
    final imagemPrincipal = pw.MemoryImage(imagemPrincipalBytes);
    final imagemSecundaria = imagemSecundariaBytes == null
        ? null
        : pw.MemoryImage(imagemSecundariaBytes);

    final agora = DateTime.now();
    String dois(int n) => n.toString().padLeft(2, '0');
    final dataFormatada =
        "${dois(agora.day)}/${dois(agora.month)}/${agora.year}";
    final horaFormatada = "${dois(agora.hour)}:${dois(agora.minute)}";
    final idAnalise =
        "#${agora.year}${dois(agora.month)}${dois(agora.day)}-${dois(agora.hour)}${dois(agora.minute)}";
    final tempoFormatado =
        "${(tempoProcessamentoMs / 1000).toStringAsFixed(2).replaceAll('.', ',')} s";

    pw.Widget infoItem(String rotulo, String valor) {
      return pw.SizedBox(
        width: 115,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              rotulo,
              style: pw.TextStyle(
                fontSize: 7.5,
                color: PdfColors.grey600,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(valor, style: const pw.TextStyle(fontSize: 9.5)),
          ],
        ),
      );
    }

    pw.Widget imagemComRotulo(String rotulo, pw.MemoryImage img) {
      return pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: double.infinity,
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: const pw.BoxDecoration(color: _corNavy),
              child: pw.Text(
                rotulo,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              height: 125,
              width: double.infinity,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Image(img, fit: pw.BoxFit.contain),
            ),
          ],
        ),
      );
    }

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) => [
          // Cabeçalho
          pw.Container(
            width: double.infinity,
            color: _corNavy,
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Image(logo, width: 32, height: 32),
                    pw.SizedBox(width: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "MICROS",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 19,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "Identificação e contagem de esporos de fungos micorrízicos arbusculares",
                          style: pw.TextStyle(
                            color: PdfColors.grey400,
                            fontSize: 7.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Text(
                  titulo,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Grade de informações
                pw.Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    infoItem("Data da análise", dataFormatada),
                    infoItem("Hora", horaFormatada),
                    infoItem("ID da análise", idAnalise),
                    infoItem("Arquivo analisado", arquivoNome),
                    infoItem("Modelo de IA", "MICROS v1.2.0"),
                    infoItem("Tempo de processamento", tempoFormatado),
                  ],
                ),
                pw.SizedBox(height: 10),

                // Cartão de destaque
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: pw.BoxDecoration(
                    color: _corVerde,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              rotuloDestaque,
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              valorDestaque,
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...estatisticasExtras.map(
                        (e) => pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 16),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                e.key,
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 7.5,
                                ),
                              ),
                              pw.SizedBox(height: 2),
                              pw.Text(
                                e.value,
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),

                // Imagem(ns)
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: imagemSecundaria == null
                      ? [
                          imagemComRotulo(
                              rotuloImagemPrincipal, imagemPrincipal)
                        ]
                      : [
                          imagemComRotulo(
                              rotuloImagemPrincipal, imagemPrincipal),
                          pw.SizedBox(width: 10),
                          imagemComRotulo(
                              rotuloImagemSecundaria, imagemSecundaria),
                        ],
                ),
                pw.SizedBox(height: 12),

                // Tabela de resultados
                pw.Text(
                  "Resumo dos resultados",
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.3),
                    1: pw.FlexColumnWidth(2),
                  },
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: _corNavy),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: pw.Text("Parâmetro",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: pw.Text("Resultado",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    for (var i = 0; i < campos.length; i++)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: i.isEven ? PdfColors.grey100 : PdfColors.white,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: pw.Text(campos[i].key,
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: pw.Text(campos[i].value,
                                textAlign: pw.TextAlign.left,
                                style: const pw.TextStyle(fontSize: 8.5)),
                          ),
                        ],
                      ),
                  ],
                ),
                pw.SizedBox(height: 10),

                // Interpretação
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: PdfColors.green200),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Interpretação",
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: _corNavy,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(interpretacao,
                          textAlign: pw.TextAlign.left,
                          style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),

                if (notaRodape != null) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(
                    notaRodape,
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      fontSize: 7.5,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],

                pw.SizedBox(height: 10),

                // Observações
                pw.Text(
                  "Observações",
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Container(
                  width: double.infinity,
                  height: 34,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text(
                    "",
                    style: const pw.TextStyle(
                        fontSize: 9, color: PdfColors.grey400),
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Divider(color: PdfColors.grey300, thickness: 0.6),
                pw.SizedBox(height: 8),

                // Rodapé
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(logo, width: 20, height: 20),
                        pw.SizedBox(width: 8),
                        pw.Text(
                          "Relatório gerado automaticamente pelo MICROS.",
                          style: pw.TextStyle(
                              fontSize: 8, color: PdfColors.grey600),
                        ),
                      ],
                    ),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("Acesse o MICROS",
                                style: pw.TextStyle(
                                    fontSize: 7.5, color: PdfColors.grey600)),
                            pw.Text(_urlSite,
                                style: pw.TextStyle(
                                    fontSize: 6.5, color: PdfColors.grey500)),
                          ],
                        ),
                        pw.SizedBox(width: 8),
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: _urlSite,
                          width: 40,
                          height: 40,
                          drawText: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final bytes = await documento.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: "micros_relatorio_${agora.millisecondsSinceEpoch}.pdf",
    );
  }
}
