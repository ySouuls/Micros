import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../state/app_state.dart';
import 'history_screen.dart';
import 'identification_screen.dart';
import 'juliano_intro_screen.dart';
import 'notifications_screen.dart';
import 'nova_contagem_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// Estrutura própria da versão web: mais dinâmica e animada, com
/// menu superior no lugar da barra inferior do app. O app (celular)
/// continua usando o [HomeScreen] de sempre.
class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrada;
  late final AnimationController _flutuacao;

  @override
  void initState() {
    super.initState();
    _entrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _flutuacao = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entrada.dispose();
    _flutuacao.dispose();
    super.dispose();
  }

  Animation<double> _fade(double inicio, double fim) => CurvedAnimation(
        parent: _entrada,
        curve: Interval(inicio, fim, curve: Curves.easeOut),
      );

  Animation<Offset> _slide(double inicio, double fim) => Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _entrada,
        curve: Interval(inicio, fim, curve: Curves.easeOutCubic),
      ));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final largura = MediaQuery.of(context).size.width;
    final isWide = largura >= 760;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _flutuacao,
              builder: (context, _) => CustomPaint(
                painter: _FundoAnimado(_flutuacao.value),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(context, theme, isWide),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 40 : 20,
                      vertical: 30,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          children: [
                            FadeTransition(
                              opacity: _fade(0, 0.5),
                              child: SlideTransition(
                                position: _slide(0, 0.5),
                                child: _hero(context, theme, isWide),
                              ),
                            ),
                            const SizedBox(height: 40),
                            FadeTransition(
                              opacity: _fade(0.25, 0.85),
                              child: SlideTransition(
                                position: _slide(0.25, 0.85),
                                child: isWide
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: _cartaoFuncao(
                                              context: context,
                                              theme: theme,
                                              icon: Icons.photo_camera_rounded,
                                              titulo: tr(context,
                                                  'new_identification_upper'),
                                              subtitulo:
                                                  tr(context, 'tap_to_start'),
                                              cor: const Color(0xFF22C55E),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const IdentificationScreen(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: _cartaoFuncao(
                                              context: context,
                                              theme: theme,
                                              icon: Icons.calculate_rounded,
                                              titulo: tr(
                                                  context, 'new_count_upper'),
                                              subtitulo:
                                                  tr(context, 'tap_to_start'),
                                              cor: const Color(0xFF3B82F6),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const NovaContagemScreen(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _cartaoFuncao(
                                            context: context,
                                            theme: theme,
                                            icon: Icons.photo_camera_rounded,
                                            titulo: tr(context,
                                                'new_identification_upper'),
                                            subtitulo:
                                                tr(context, 'tap_to_start'),
                                            cor: const Color(0xFF22C55E),
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const IdentificationScreen(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          _cartaoFuncao(
                                            context: context,
                                            theme: theme,
                                            icon: Icons.calculate_rounded,
                                            titulo:
                                                tr(context, 'new_count_upper'),
                                            subtitulo:
                                                tr(context, 'tap_to_start'),
                                            cor: const Color(0xFF3B82F6),
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const NovaContagemScreen(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context, ThemeData theme, bool isWide) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 40 : 16,
        vertical: 16,
      ),
      child: Row(
        children: [
          _HoverIcon(
            icon: Icons.chat_bubble_outline_rounded,
            cor: const Color(0xFF22C55E),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JulianoIntroScreen()),
            ),
          ),
          const SizedBox(width: 10),
          Image.asset("assets/images/logo.png", width: 32),
          const SizedBox(width: 10),
          Text(
            "MICROS",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isWide ? 24 : 20,
            ),
          ),
          const Spacer(),
          _HoverIcon(
            icon: Icons.history_rounded,
            cor: theme.iconTheme.color ?? Colors.grey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          _HoverIcon(
            icon: Icons.notifications_none_rounded,
            cor: theme.iconTheme.color ?? Colors.grey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          _HoverIcon(
            icon: Icons.settings_rounded,
            cor: theme.iconTheme.color ?? Colors.grey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          const SizedBox(width: 6),
          _HoverAvatar(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, ThemeData theme, bool isWide) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _flutuacao,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, math.sin(_flutuacao.value * math.pi) * 6),
            child: child,
          ),
          child: Image.asset(
            "assets/images/logo.png",
            width: isWide ? 110 : 90,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "MICROS",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isWide ? 40 : 30,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          tr(context, 'web_hero_tagline'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: isWide ? 17 : 15,
          ),
        ),
      ],
    );
  }

  Widget _cartaoFuncao({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return _HoverCard(
      cor: cor,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 46, color: cor),
            ),
            const SizedBox(height: 18),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 6),
            Text(subtitulo, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

/// Cartão com efeito de "levantar" ao passar o mouse.
class _HoverCard extends StatefulWidget {
  final Widget child;
  final Color cor;
  final VoidCallback onTap;

  const _HoverCard({
    required this.child,
    required this.cor,
    required this.onTap,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: widget.cor.withOpacity(_hover ? 0.5 : 0.18),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.cor.withOpacity(_hover ? 0.25 : 0.08),
                  blurRadius: _hover ? 30 : 14,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Ícone do menu superior com leve animação ao passar o mouse.
class _HoverIcon extends StatefulWidget {
  final IconData icon;
  final Color cor;
  final VoidCallback onTap;

  const _HoverIcon({
    required this.icon,
    required this.cor,
    required this.onTap,
  });

  @override
  State<_HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<_HoverIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Icon(widget.icon, color: widget.cor, size: 24),
          ),
        ),
      ),
    );
  }
}

class _HoverAvatar extends StatefulWidget {
  final VoidCallback onTap;

  const _HoverAvatar({required this.onTap});

  @override
  State<_HoverAvatar> createState() => _HoverAvatarState();
}

class _HoverAvatarState extends State<_HoverAvatar> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: ValueListenableBuilder<String?>(
            valueListenable: profileImagePathNotifier,
            builder: (context, imagePath, child) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF22C55E),
                backgroundImage: profileImageProvider(imagePath),
                child: imagePath == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Fundo com círculos suaves flutuando, só decoração.
class _FundoAnimado extends CustomPainter {
  final double t;

  _FundoAnimado(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final circulos = [
      (const Color(0xFF22C55E), 0.18, Offset(0.15, 0.2), 220.0),
      (const Color(0xFF3B82F6), 0.12, Offset(0.85, 0.15), 180.0),
      (const Color(0xFF22C55E), 0.10, Offset(0.8, 0.85), 260.0),
    ];

    for (final (cor, opacidade, base, raio) in circulos) {
      final dx = base.dx * size.width + math.sin(t * 2 * math.pi) * 16;
      final dy = base.dy * size.height + math.cos(t * 2 * math.pi) * 16;
      final paint = Paint()
        ..color = cor.withOpacity(opacidade)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
      canvas.drawCircle(Offset(dx, dy), raio, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FundoAnimado oldDelegate) => oldDelegate.t != t;
}
