import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/strings.dart';
import '../services/api_service.dart';
import '../widgets/image_source_sheet.dart';

class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({super.key});

  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  final ApiService _api = ApiService();

  XFile? _imagem;
  bool _carregando = false;
  String? _erro;
  Map<String, dynamic>? _resultado;

  Future<void> _selecionarEIdentificar() async {
    final foto = await selecionarImagem(context);
    if (foto == null) return;

    setState(() {
      _imagem = foto;
      _resultado = null;
      _erro = null;
      _carregando = true;
    });

    try {
      final resultado = await _api.identificarImagem(foto);
      if (!mounted) return;
      setState(() {
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

  Color _corConfianca(num confianca) {
    if (confianca >= 70) return const Color(0xFF22C55E);
    if (confianca >= 40) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
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
    final Map<String, dynamic>? especie =
        deteccoes.isNotEmpty ? deteccoes.first as Map<String, dynamic> : null;
    final num confianca = especie?["confianca"] ?? 0;
    final Color destaque =
        especie == null ? Colors.grey : _corConfianca(confianca);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          tr(context, 'new_identification'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selecionarEIdentificar,
              child: Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: destaque.withOpacity(0.25),
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
                        child: _imagemWidget(),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            if (_carregando)
              Column(
                children: [
                  const CircularProgressIndicator(color: Color(0xFF22C55E)),
                  const SizedBox(height: 12),
                  Text(tr(context, 'identifying_image'),
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            if (_erro != null)
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            if (_resultado != null && _erro == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: destaque.withOpacity(0.25)),
                ),
                child: especie == null
                    ? Column(
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            color: theme.iconTheme.color?.withOpacity(0.4),
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            tr(context, 'no_species_identified'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: destaque.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.biotech_rounded,
                              color: destaque,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            especie["classe"].toString().replaceAll("_", " "),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: (confianca.clamp(0, 100)) / 100,
                              minHeight: 10,
                              backgroundColor: destaque.withOpacity(0.15),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(destaque),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${tr(context, 'confidence')}: $confianca%",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: destaque,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            if (_imagem != null && !_carregando) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: _selecionarEIdentificar,
                icon:
                    const Icon(Icons.refresh_rounded, color: Color(0xFF22C55E)),
                label: Text(
                  tr(context, 'new_identification'),
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
