import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../services/api_service.dart';

class ClearHistoryScreen extends StatefulWidget {
  const ClearHistoryScreen({super.key});

  @override
  State<ClearHistoryScreen> createState() => _ClearHistoryScreenState();
}

class _ClearHistoryScreenState extends State<ClearHistoryScreen> {
  final ApiService _api = ApiService();
  late Future<List<dynamic>> _historico;

  @override
  void initState() {
    super.initState();
    _historico = _api.obterHistorico();
  }

  Future<void> _apagar(int quantidade) async {
    if (quantidade == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'nothing_to_clear'))),
      );
      return;
    }

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'delete_all_history')),
        content: Text(tr(context, 'delete_history_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'delete'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    try {
      await _api.apagarHistorico();
      if (!mounted) return;

      setState(() {
        _historico = _api.obterHistorico();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'history_deleted'))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${tr(context, 'delete_notifications_error')}: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(tr(context, 'clear_history')),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historico,
        builder: (context, snapshot) {
          final carregando = snapshot.connectionState == ConnectionState.waiting;
          final quantidade = snapshot.data?.length ?? 0;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    tr(context, 'clear_history_intro'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15),
                  if (!carregando)
                    Text(
                      "$quantidade ${tr(context, 'saved_analyses_count')}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.delete_forever, color: Colors.white),
                      label: Text(
                        tr(context, 'delete_all_history'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: carregando ? null : () => _apagar(quantidade),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
