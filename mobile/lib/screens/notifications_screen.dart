import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService _api = ApiService();
  late Future<List<dynamic>> _historico;
  int _quantidade = 0;

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

  Future<void> _confirmarApagarTudo() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(tr(context, 'delete_notifications_title'), style: const TextStyle(color: Colors.white)),
        content: Text(
          tr(context, 'delete_notifications_confirm'),
          style: const TextStyle(color: Colors.white60),
        ),
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
      await _recarregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${tr(context, 'delete_notifications_error')}: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(tr(context, 'notifications')),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_quantidade > 0)
            IconButton(
              tooltip: tr(context, 'delete_all'),
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _confirmarApagarTudo,
            ),
        ],
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _quantidade != 0) setState(() => _quantidade = 0);
              });
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 48),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      tr(context, 'notifications_load_error'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              );
            }

            final analises = snapshot.data ?? [];

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _quantidade != analises.length) {
                setState(() => _quantidade = analises.length);
              }
            });

            if (analises.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.check_circle_outline_rounded, color: Colors.white38, size: 48),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      tr(context, 'notifications_empty'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: analises.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                // Cada linha vem do banco como [id, arquivo, classe, confianca, tipo, data_hora]
                final item = analises[index] as List<dynamic>;
                final arquivo = item[1]?.toString() ?? "imagem";
                final classe = item[2]?.toString() ?? "estrutura";
                final confianca = item[3];
                final tipo = item.length > 4 ? item[4]?.toString() : "especie";
                final ehContagem = tipo == "contagem";

                final emIngles = LocaleScope.of(context).languageCode == 'en';

                final String subtitle;
                if (ehContagem) {
                  final quantidade = confianca is num ? confianca.toInt() : confianca;
                  subtitle = emIngles
                      ? "$quantidade ${tr(context, 'spores_found')} in $arquivo"
                      : "$quantidade ${tr(context, 'spores_found')} em $arquivo";
                } else {
                  final confiancaTexto = confianca is num ? confianca.toStringAsFixed(1) : confianca;
                  subtitle = emIngles
                      ? "$classe detected ($confiancaTexto% confidence) in $arquivo"
                      : "$classe detectado ($confiancaTexto% de confiança) em $arquivo";
                }

                return NotificationCard(
                  icon: ehContagem ? Icons.calculate_rounded : Icons.biotech_rounded,
                  color: const Color(0xFF22C55E),
                  title: tr(context, ehContagem ? 'count_complete' : 'identification_complete'),
                  subtitle: subtitle,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
