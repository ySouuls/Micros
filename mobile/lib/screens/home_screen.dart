import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/pressable_card.dart';
import '../widgets/responsive.dart';
import 'identification_screen.dart';
import 'history_screen.dart';
import 'juliano_intro_screen.dart';
import 'logo_detail_screen.dart';
import 'notifications_screen.dart';
import 'nova_contagem_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../l10n/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          tooltip: '', // Remove mensagem amarela ao passar o mouse
          icon: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Color(0xFF22C55E),
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Direciona para a tela com o vídeo da animação do Juliano
                builder: (_) => const JulianoIntroScreen(),
              ),
            );
          },
        ),
        title: Text(
          "MICROS",
          style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botão Notificações com animação
          PressableCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.notifications_none_rounded,
                color: theme.iconTheme.color,
              ),
            ),
          ),

          // Botão Perfil (Avatar) com animação e atualização reativa
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 5),
            child: PressableCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
              child: ValueListenableBuilder<String?>(
                valueListenable: profileImagePathNotifier,
                builder: (context, imagePath, child) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF22C55E),
                    backgroundImage: profileImageProvider(imagePath),
                    child: imagePath == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= kLargeScreenBreakpoint;

          final cardIdentificacao = _HomeCard(
            theme: theme,
            icon: Icons.photo_camera_rounded,
            titulo: tr(context, 'new_identification_upper'),
            subtitulo: tr(context, 'tap_to_start'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const IdentificationScreen(),
                ),
              );
            },
          );

          final cardContagem = _HomeCard(
            theme: theme,
            icon: Icons.calculate_rounded,
            titulo: tr(context, 'new_count_upper'),
            subtitulo: tr(context, 'tap_to_start'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NovaContagemScreen(),
                ),
              );
            },
          );

          final logo = Image.asset(
            "assets/images/logo.png",
            width: isWide ? 150 : 130,
          );

          final Widget conteudo = isWide
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logo,
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 300,
                      child: Row(
                        children: [
                          Expanded(child: cardIdentificacao),
                          const SizedBox(width: 24),
                          Expanded(child: cardContagem),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    logo,
                    const SizedBox(height: 16),
                    Expanded(child: cardIdentificacao),
                    const SizedBox(height: 16),
                    Expanded(child: cardContagem),
                  ],
                );

          return Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: isWide ? 900 : double.infinity),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: conteudo,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão Histórico com animação
                PressableCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HistoryScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.history,
                      color: theme.iconTheme.color,
                      size: 30,
                    ),
                  ),
                ),

                // Logo central com animação
                PressableCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LogoDetailScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                  ),
                ),

                // Botão Configurações com animação
                PressableCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.settings,
                      color: theme.iconTheme.color,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _HomeCard({
    required this.theme,
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: const Color(0xFF22C55E)),
            const SizedBox(height: 12),
            Text(titulo, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(subtitulo, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
