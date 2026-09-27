import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/pressable_card.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 130,
            ),
            const SizedBox(height: 16),

            // Card 1: NOVA IDENTIFICAÇÃO
            Expanded(
              child: PressableCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IdentificationScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_camera_rounded,
                        size: 60,
                        color: Color(0xFF22C55E),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(context, 'new_identification_upper'),
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tr(context, 'tap_to_start'),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card 2: NOVA CONTAGEM
            Expanded(
              child: PressableCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NovaContagemScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calculate_rounded,
                        size: 60,
                        color: Color(0xFF22C55E),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(context, 'new_count_upper'),
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tr(context, 'tap_to_start'),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    );
  }
}
