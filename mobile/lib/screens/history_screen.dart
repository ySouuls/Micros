import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _api = ApiService();
  late Future<List<dynamic>> _historico;

  @override
  void initState() {
    super.initState();
    _historico = _api.obterHistorico();
  }

  Future<void> _recarregar() async {
    setState(() {
      _historico = _api.obterHistorico();
    });
    await _historico;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          tr(context, 'history'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: FutureBuilder<List<dynamic>>(
          future: _historico,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF22C55E)),
              );
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 60),
                  Icon(Icons.wifi_off_rounded,
                      color: theme.iconTheme.color?.withOpacity(0.3), size: 48),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      tr(context, 'history_load_error'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              );
            }

            final itens = snapshot.data ?? [];

            if (itens.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 60),
                  Icon(Icons.history_rounded,
                      color: theme.iconTheme.color?.withOpacity(0.3), size: 48),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      tr(context, 'no_history_yet'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _grupoTile(
                  context,
                  tr(context, 'all_analyses'),
                  itens.map((item) => item as List<dynamic>).toList(),
                  Icons.history_rounded,
                  const Color(0xFF22C55E),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _grupoTile(
    BuildContext context,
    String titulo,
    List<List<dynamic>> itens,
    IconData icon,
    Color cor,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: cor.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: cor),
          ),
          title: Text(titulo,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Text(
            itens.isEmpty
                ? tr(context, 'no_analysis_done')
                : "${itens.length} ${tr(context, 'item_count')}",
            style: theme.textTheme.bodyMedium,
          ),
          children: itens.map((item) => _itemTile(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _itemTile(BuildContext context, List<dynamic> item) {
    final theme = Theme.of(context);
    final arquivo = item[1]?.toString() ?? "";
    final classe = item[2]?.toString() ?? "";
    final confianca = item[3];
    final tipo = item.length > 4 ? item[4]?.toString() : "especie";
    final ehContagem = tipo == "contagem";

    final String texto;
    if (ehContagem) {
      final quantidade = confianca is num ? confianca.toInt() : confianca;
      texto = "$quantidade ${tr(context, 'spores_found')}";
    } else {
      final confiancaTexto =
          confianca is num ? confianca.toStringAsFixed(1) : confianca;
      texto = "${classe.replaceAll('_', ' ')} ($confiancaTexto%)";
    }

    return ListTile(
      leading: Icon(
        ehContagem ? Icons.calculate_rounded : Icons.biotech_rounded,
        color: const Color(0xFF22C55E),
      ),
      title: Text(texto, style: theme.textTheme.bodyLarge),
      subtitle: Text(arquivo, style: theme.textTheme.bodyMedium),
    );
  }
}
