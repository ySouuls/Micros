import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Gera e abre/baixa um relatório em PDF com a logo do MICROS, a
/// imagem analisada e os campos de resultado informados.
class PdfReportService {
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
}
